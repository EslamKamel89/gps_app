class VendorProof {
  String id;
  String title;
  String? description;
  String imageUrl;

  VendorProof({
    required this.id,
    required this.title,
    this.description,
    required this.imageUrl,
  });

  factory VendorProof.empty() => VendorProof(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    title: '',
    imageUrl:
        'https://images.unsplash.com/photo-1589330694653-ded6df03f754?q=80&w=916&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  );

  VendorProof copyWith({String? title, String? description, String? imageUrl}) {
    return VendorProof(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
