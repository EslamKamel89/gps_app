// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/api_service/api_consumer.dart';
import 'package:gps_app/core/api_service/end_points.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:image_picker/image_picker.dart';

import 'uploaded_image.dart';

enum _UploadStatus { uploading, success, failed }

class _UploadItem {
  _UploadItem({
    required this.localFile,
    this.serverImage,
    this.status = _UploadStatus.uploading,
    this.errorMessage,
  });

  final XFile localFile;

  UploadedImage? serverImage;

  _UploadStatus status;

  String? errorMessage;

  bool get isCompleted => status == _UploadStatus.success;
  bool get isFailed => status == _UploadStatus.failed;

  @override
  String toString() =>
      '_UploadItem(localFile: $localFile , serverImage: $serverImage , status: $status , errorMessage: $errorMessage)';
}

class ImageUploadField extends StatefulWidget {
  const ImageUploadField({
    super.key,
    required this.resource,
    required this.child,
    required this.onChanged,
    this.multiple = false,
    this.maxCount,
    this.initial = const <UploadedImage>[],
    this.gridCrossAxisCount = 3,
    this.gridSpacing = 8,
    this.showPreview = true,
  }) : assert(
         multiple || (maxCount == null || maxCount == 1),
         'When multiple=false, maxCount should be null or 1',
       );

  final bool multiple;

  final int? maxCount;

  final UploadResource resource;

  final Widget child;

  final void Function(List<UploadedImage> images) onChanged;

  final List<UploadedImage> initial;

  final int gridCrossAxisCount;
  final double gridSpacing;
  final bool showPreview;
  @override
  State<ImageUploadField> createState() => _ImageUploadFieldState();
}

class _ImageUploadFieldState extends State<ImageUploadField> {
  final _picker = ImagePicker();
  late final ApiConsumer _api = serviceLocator<ApiConsumer>();

  final List<_UploadItem> _items = [];

  List<UploadedImage> get _successful =>
      _items.where((e) => e.serverImage != null).map((e) => e.serverImage!).toList();

  String get _uploadUrl => '${EndPoint.baseUrl}/api/uploads/images';

  @override
  void initState() {
    super.initState();
    for (final img in widget.initial) {
      _items.add(
        _UploadItem(localFile: XFile(''), serverImage: img, status: _UploadStatus.success),
      );
    }
  }

  Future<void> _openPickerSheet() async {
    final action = await showModalBottomSheet<_PickAction>(
      context: context,
      showDragHandle: true,
      builder:
          (ctx) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Pick from Gallery'),
                  onTap: () => Navigator.pop(ctx, _PickAction.gallery),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Use Camera'),
                  onTap: () => Navigator.pop(ctx, _PickAction.camera),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
    );

    if (!mounted || action == null) return;

    switch (action) {
      case _PickAction.gallery:
        await _pickFromGallery();
        break;
      case _PickAction.camera:
        await _pickFromCamera();
        break;
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      if (widget.multiple) {
        final remaining =
            widget.maxCount == null
                ? null
                : (widget.maxCount! - _items.where((e) => e.isCompleted).length);
        final multi = await _picker.pickMultiImage();
        if (multi.isEmpty) return;

        final selected = remaining == null ? multi : multi.take(remaining.clamp(0, multi.length));
        if (selected.isEmpty) return;

        await _enqueueAndUpload(selected.toList());
      } else {
        final single = await _picker.pickImage(source: ImageSource.gallery);
        if (single == null) return;
        await _replaceSingleAndUpload(single);
      }
    } catch (e) {
      _showSnack('Failed to pick images');
    }
  }

  Future<void> _pickFromCamera() async {
    try {
      final single = await _picker.pickImage(source: ImageSource.camera);
      if (single == null) return;
      if (widget.multiple) {
        await _enqueueAndUpload([single]);
      } else {
        await _replaceSingleAndUpload(single);
      }
    } catch (e) {
      _showSnack('Failed to access camera');
    }
  }

  Future<void> _replaceSingleAndUpload(XFile file) async {
    // Remove any previous items entirely (single mode = replace).
    _items.clear();
    setState(() {});
    await _uploadBatch([file]);
  }

  Future<void> _enqueueAndUpload(List<XFile> files) async {
    await _uploadBatch(files);
  }

  Future<void> _uploadBatch(List<XFile> files) async {
    final startIndex = _items.length;
    for (final f in files) {
      _items.add(_UploadItem(localFile: f, status: _UploadStatus.uploading));
    }
    setState(() {});
    final imageFiles = [];

    for (final f in files) {
      imageFiles.add(await MultipartFile.fromFile(f.path, filename: f.name));
    }
    try {
      final res = await _api.post(
        _uploadUrl,
        data: {'dir': widget.resource.dir, 'images[]': imageFiles},
        isFormData: true,
      );

      if (res is List) {
        for (int i = 0; i < res.length; i++) {
          final map = Map<String, dynamic>.from(res[i] as Map);
          final uploaded = UploadedImage.fromJson(map);
          final localIndex = startIndex + i;
          if (localIndex < _items.length) {
            _items[localIndex]
              ..serverImage = uploaded
              ..status = _UploadStatus.success
              ..errorMessage = null;
          }
        }
        for (int j = startIndex + res.length; j < startIndex + files.length; j++) {
          if (j < _items.length) {
            _items[j]
              ..status = _UploadStatus.failed
              ..errorMessage = 'Upload did not return an item.';
          }
        }
        setState(() {});
        widget.onChanged(_successful);
      } else {
        for (int j = startIndex; j < startIndex + files.length; j++) {
          _items[j]
            ..status = _UploadStatus.failed
            ..errorMessage = 'Unexpected server response.';
        }
        setState(() {});
        _showSnack('Unexpected server response.');
      }
    } catch (e) {
      pr('Error, $e');
      for (int j = startIndex; j < startIndex + files.length; j++) {
        _items[j]
          ..status = _UploadStatus.failed
          ..errorMessage = 'Upload failed';
      }
      setState(() {});
      _showSnack('Upload failed. You can retry individual items.');
    }
  }

  Future<void> _retrySingle(int index) async {
    if (index < 0 || index >= _items.length) return;
    final item = _items[index];
    if (!item.isFailed) return;

    setState(() {
      item.status = _UploadStatus.uploading;
      item.errorMessage = null;
    });

    final formData = FormData.fromMap({
      'dir': widget.resource.dir,
      'images[]': await MultipartFile.fromFile(item.localFile.path, filename: item.localFile.name),
    });

    try {
      final res = await _api.post(_uploadUrl, data: formData, isFormData: true);

      if (res is List && res.isNotEmpty) {
        final uploaded = UploadedImage.fromJson(Map<String, dynamic>.from(res.first as Map));
        setState(() {
          item.serverImage = uploaded;
          item.status = _UploadStatus.success;
        });
        widget.onChanged(_successful);
      } else {
        setState(() {
          item.status = _UploadStatus.failed;
          item.errorMessage = 'Unexpected server response.';
        });
        _showSnack('Unexpected server response.');
      }
    } catch (e) {
      setState(() {
        item.status = _UploadStatus.failed;
        item.errorMessage = 'Upload failed';
      });
      _showSnack('Retry failed.');
    }
  }

  void _removeItem(int index) {
    if (index < 0 || index >= _items.length) return;
    _items.removeAt(index);
    setState(() {});
    widget.onChanged(_successful);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _openPickerSheet,
          behavior: HitTestBehavior.opaque,
          child: widget.child,
        ),
        if ((_items.isNotEmpty || widget.multiple) && widget.showPreview) ...[
          const SizedBox(height: 12),
          _buildGrid(context),
        ],
      ],
    );
  }

  Widget _buildGrid(BuildContext context) {
    final canAddMore =
        widget.multiple &&
        (widget.maxCount == null || _items.where((e) => e.isCompleted).length < widget.maxCount!);

    final itemCount = _items.length + (canAddMore ? 1 : 0);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.gridCrossAxisCount,
        crossAxisSpacing: widget.gridSpacing,
        mainAxisSpacing: widget.gridSpacing,
      ),
      itemBuilder: (context, index) {
        if (canAddMore && index == itemCount - 1) {
          return _AddTile(onTap: _openPickerSheet);
        }
        return _buildThumb(context, index);
      },
    );
  }

  Widget _buildThumb(BuildContext context, int index) {
    final item = _items[index];
    final placeholder = Container(color: Theme.of(context).colorScheme.surfaceContainerHighest);

    Widget imageWidget;
    if (item.serverImage != null && item.localFile.path.isEmpty) {
      // Display server image (you can swap to CachedNetworkImage in your codebase)
      final url =
          item.serverImage!.path.startsWith('http')
              ? item.serverImage!.path
              : '${EndPoint.baseUrl}/${item.serverImage!.path}';
      pr(url, 'url');
      imageWidget = Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => placeholder,
      );
    } else {
      if (item.localFile.path.isEmpty) {
        imageWidget = placeholder;
      } else {
        imageWidget = Image.file(File(item.localFile.path), fit: BoxFit.cover);
      }
    }

    if (item.status == _UploadStatus.uploading) {
      imageWidget = Stack(
        fit: StackFit.expand,
        children: [imageWidget, Container(color: Colors.black.withOpacity(0.1))],
      ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          imageWidget,
          Positioned(
            top: 6,
            right: 6,
            child: InkWell(
              onTap: () => _removeItem(index),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ),
          ),
          if (item.isFailed)
            Container(
              color: Colors.black45,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white),
                    const SizedBox(height: 6),
                    Text(
                      item.errorMessage ?? 'Upload failed',
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () => _retrySingle(index),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

enum _PickAction { gallery, camera }

class _AddTile extends StatelessWidget {
  const _AddTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final border = BorderRadius.circular(12);
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: border,
      child: InkWell(
        borderRadius: border,
        onTap: onTap,
        child: const Center(child: Icon(Icons.add, size: 36)),
      ),
    );
  }
}
