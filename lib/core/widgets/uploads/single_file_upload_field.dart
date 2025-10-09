import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:image_picker/image_picker.dart';

class UploadedFile {
  UploadedFile({required this.id, required this.path});

  final int id;
  final String path;

  factory UploadedFile.fromJson(Map<String, dynamic> json) {
    return UploadedFile(id: (json['id'] as num).toInt(), path: (json['path'] as String));
  }

  @override
  String toString() => 'UploadedFile(id: $id, path: $path)';
}

class UploadResponse {
  UploadResponse({required this.message, required this.file});

  final String message;
  final UploadedFile file;

  factory UploadResponse.fromJson(Map<String, dynamic> json) {
    return UploadResponse(
      message: json['message'] as String,
      file: UploadedFile.fromJson(Map<String, dynamic>.from(json['file'] as Map)),
    );
  }

  @override
  String toString() => 'UploadResponse(message: $message, file: $file)';
}

enum _UploadStatus { idle, picking, ready, uploading, success, failed }

class SingleFileUploadField extends StatefulWidget {
  const SingleFileUploadField({
    super.key,
    required this.baseUrl,
    required this.dir,
    required this.onUploaded,
    this.buttonLabel = 'Select File',
    this.initialText,
    this.enabled = true,
  });

  final String baseUrl;
  final String dir;
  final void Function(UploadedFile file) onUploaded;

  final String buttonLabel;
  final String? initialText;
  final bool enabled;

  @override
  State<SingleFileUploadField> createState() => _SingleFileUploadFieldState();
}

class _SingleFileUploadFieldState extends State<SingleFileUploadField> {
  late final Dio _dio = serviceLocator<Dio>();
  final _imagePicker = ImagePicker();

  _UploadStatus _status = _UploadStatus.idle;
  _LocalSelection? _selection;
  double? _progress;
  UploadedFile? _uploadedFile;

  String get _endpoint => '${widget.baseUrl}/api/files';

  @override
  Widget build(BuildContext context) {
    final hasSelection = _selection != null || _uploadedFile != null;
    final isBusy = _status == _UploadStatus.picking || _status == _UploadStatus.uploading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: widget.enabled && !isBusy ? _openPickActionSheet : null,
              child: Container(
                decoration: BoxDecoration(
                  color: GPSColors.accent,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    const Icon(Icons.upload_file, color: Colors.white),
                    GPSGaps.w8,
                    Text(
                      hasSelection ? 'Change File' : widget.buttonLabel,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            if (isBusy)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
        const SizedBox(height: 12),
        _SelectionPanel(
          status: _status,
          selection: _selection,
          uploadedFile: _uploadedFile,
          progress: _progress,
          initialText: widget.initialText,
        ),
      ],
    );
  }

  Future<void> _openPickActionSheet() async {
    setState(() => _status = _UploadStatus.picking);

    final action = await showModalBottomSheet<_PickAction>(
      context: context,
      showDragHandle: true,
      builder:
          (ctx) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_camera_outlined),
                  title: const Text('Use Camera (Image)'),
                  onTap: () => Navigator.of(ctx).pop(_PickAction.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.folder_open),
                  title: const Text('Pick from Files (Any Type)'),
                  onTap: () => Navigator.of(ctx).pop(_PickAction.files),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
    );

    if (!mounted) return;

    if (action == null) {
      setState(() => _status = _uploadedFile == null ? _UploadStatus.idle : _UploadStatus.success);
      return;
    }

    try {
      switch (action) {
        case _PickAction.camera:
          await _pickFromCamera();
          break;
        case _PickAction.files:
          await _pickFromFiles();
          break;
      }
    } catch (_) {
      _failPick('Failed to pick file.');
    }
  }

  Future<void> _pickFromCamera() async {
    final x = await _imagePicker.pickImage(source: ImageSource.camera);
    if (x == null) {
      setState(() => _status = _uploadedFile == null ? _UploadStatus.idle : _UploadStatus.success);
      return;
    }

    _selection = _LocalSelection(path: x.path, name: x.name, bytes: null);
    _uploadedFile = null;
    _progress = null;

    setState(() => _status = _UploadStatus.ready);
    await _uploadCurrentSelection();
  }

  Future<void> _pickFromFiles() async {
    final res = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withData: false,
      type: FileType.any,
    );
    if (res == null || res.files.isEmpty) {
      setState(() => _status = _uploadedFile == null ? _UploadStatus.idle : _UploadStatus.success);
      return;
    }

    final f = res.files.single;
    _selection = _LocalSelection(path: f.path, name: f.name, bytes: f.bytes);
    _uploadedFile = null;
    _progress = null;

    setState(() => _status = _UploadStatus.ready);
    await _uploadCurrentSelection();
  }

  Future<void> _uploadCurrentSelection() async {
    final sel = _selection;
    if (sel == null) return;

    setState(() {
      _status = _UploadStatus.uploading;
      _progress = 0.0;
    });

    try {
      final filePart = await _toMultipart(sel);

      final form = FormData.fromMap(<String, dynamic>{'dir': widget.dir, 'file': filePart});

      final response = await _dio.post(
        _endpoint,
        data: form,
        options: Options(contentType: 'multipart/form-data', responseType: ResponseType.json),
        onSendProgress: (sent, total) {
          if (!mounted) return;
          if (total > 0) {
            setState(() => _progress = sent / total);
          }
        },
      );

      final data = response.data;
      if (data is! Map) throw StateError('Unexpected server response type.');

      final parsed = UploadResponse.fromJson(Map<String, dynamic>.from(data));
      _uploadedFile = parsed.file;

      setState(() {
        _status = _UploadStatus.success;
        _progress = null;
      });

      widget.onUploaded(parsed.file);
    } catch (e) {
      setState(() {
        _status = _UploadStatus.failed;
        _progress = null;
      });
      _showSnack('Upload failed. Please try again.');
    }
  }

  Future<MultipartFile> _toMultipart(_LocalSelection sel) async {
    if (sel.path != null) {
      return MultipartFile.fromFile(sel.path!, filename: sel.name);
    }
    if (sel.bytes != null) {
      return MultipartFile.fromBytes(sel.bytes!, filename: sel.name);
    }
    throw StateError('No data source for file.');
  }

  void _failPick(String msg) {
    setState(() => _status = _uploadedFile == null ? _UploadStatus.idle : _UploadStatus.success);
    _showSnack(msg);
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

enum _PickAction { camera, files }

class _LocalSelection {
  _LocalSelection({required this.path, required this.name, required this.bytes});

  final String? path;
  final String name;
  final List<int>? bytes;

  bool get isImage {
    final n = name.toLowerCase();
    return n.endsWith('.png') ||
        n.endsWith('.jpg') ||
        n.endsWith('.jpeg') ||
        n.endsWith('.webp') ||
        n.endsWith('.gif') ||
        n.endsWith('.bmp') ||
        n.endsWith('.heic') ||
        n.endsWith('.heif');
  }
}

class _SelectionPanel extends StatelessWidget {
  const _SelectionPanel({
    required this.status,
    required this.selection,
    required this.uploadedFile,
    required this.progress,
    required this.initialText,
  });

  final _UploadStatus status;
  final _LocalSelection? selection;
  final UploadedFile? uploadedFile;
  final double? progress;
  final String? initialText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (selection == null && uploadedFile == null) {
      final hint =
          (initialText == null || initialText!.trim().isEmpty) ? 'No file selected.' : initialText!;
      return Text(hint, style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor));
    }

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThumb(context),
            const SizedBox(width: 12),
            Expanded(child: _buildMeta(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildThumb(BuildContext context) {
    final size = 56.0;

    if (selection?.isImage == true && selection?.path != null) {
      final p = selection!.path!;
      if (File(p).existsSync()) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(File(p), width: size, height: size, fit: BoxFit.cover),
        );
      }
    }

    final isServer = uploadedFile != null && selection == null;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        isServer ? Icons.cloud_done_outlined : Icons.insert_drive_file_outlined,
        size: 28,
      ),
    );
  }

  Widget _buildMeta(BuildContext context) {
    final theme = Theme.of(context);

    final name = selection?.name ?? uploadedFile?.path.split('/').last ?? '(file)';
    final statusText = switch (status) {
      _UploadStatus.idle => 'Idle',
      _UploadStatus.picking => 'Opening picker…',
      _UploadStatus.ready => 'Ready to upload…',
      _UploadStatus.uploading => 'Uploading…',
      _UploadStatus.success => 'Uploaded successfully',
      _UploadStatus.failed => 'Upload failed',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: theme.textTheme.titleSmall),
        const SizedBox(height: 6),
        Row(
          children: [
            _statusDot(context, status),
            const SizedBox(width: 6),
            Text(statusText, style: theme.textTheme.bodySmall),
          ],
        ),
        if (status == _UploadStatus.uploading && progress != null) ...[
          const SizedBox(height: 8),
          LinearProgressIndicator(value: progress),
        ],
        if (uploadedFile != null) ...[
          const SizedBox(height: 8),
          Text(
            'File ID: ${uploadedFile!.id}',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
          ),
          Text(
            uploadedFile!.path,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
          ),
        ],
      ],
    );
  }

  Widget _statusDot(BuildContext context, _UploadStatus s) {
    final color = switch (s) {
      _UploadStatus.success => Colors.green,
      _UploadStatus.failed => Colors.red,
      _UploadStatus.uploading => Colors.blue,
      _UploadStatus.picking || _UploadStatus.ready => Colors.orange,
      _UploadStatus.idle => Theme.of(context).disabledColor,
    };
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
