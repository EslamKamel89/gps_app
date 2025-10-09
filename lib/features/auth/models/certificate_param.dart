class CertificateParam {
  String? title;
  String? description;
  int? fileId;

  CertificateParam({this.title, this.description, this.fileId});

  @override
  String toString() {
    return 'CertificateParam(title: $title, description: $description, fileId: $fileId)';
  }

  factory CertificateParam.fromJson(Map<String, dynamic> json) {
    return CertificateParam(
      title: json['title'] as String?,
      description: json['description'] as String?,
      fileId: json['file_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'file_id': fileId,
  };

  CertificateParam copyWith({String? title, String? description, int? fileId}) {
    return CertificateParam(
      title: title ?? this.title,
      description: description ?? this.description,
      fileId: fileId ?? this.fileId,
    );
  }
}
