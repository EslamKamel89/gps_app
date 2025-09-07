// features/vendor_onboarding/models/branch.dart

class VendorBranch {
  String id;
  String branchName;
  String phoneNumber;
  Map<String, String> openingHours;
  String? website;
  double latitude;
  double longitude;
  String address;
  List<String> photos;
  bool isVerified;

  VendorBranch({
    required this.id,
    required this.branchName,
    required this.phoneNumber,
    required this.openingHours,
    this.website,
    this.latitude = 40.7128,
    this.longitude = -74.0060,
    required this.address,
    this.photos = const [],
    this.isVerified = false,
  });

  factory VendorBranch.empty() => VendorBranch(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    branchName: '',
    phoneNumber: '',
    openingHours: {'Mon-Fri': '9:00 AM - 10:00 PM'},
    address: '123 Main St, New York, NY',
    photos: [],
    isVerified: false,
  );
  VendorBranch copyWith(Map<String, dynamic> updates) {
    return VendorBranch(
      id: updates['id'] as String? ?? id,
      branchName: updates['branchName'] as String? ?? branchName,
      phoneNumber: updates['phoneNumber'] as String? ?? phoneNumber,
      openingHours:
          updates['openingHours'] as Map<String, String>? ?? openingHours,
      website: updates['website'] as String? ?? website,
      latitude: updates['latitude'] as double? ?? latitude,
      longitude: updates['longitude'] as double? ?? longitude,
      address: updates['address'] as String? ?? address,
      photos: updates['photos'] as List<String>? ?? photos,
      isVerified: updates['isVerified'] as bool? ?? isVerified,
    );
  }
}
