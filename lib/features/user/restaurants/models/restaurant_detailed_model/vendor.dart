import 'operating_hours.dart';

class Vendor {
  String? vendorName;
  dynamic priceRange;
  String? address;
  int? seatingCapacity;
  OperatingHours? operatingHours;

  Vendor({
    this.vendorName,
    this.priceRange,
    this.address,
    this.seatingCapacity,
    this.operatingHours,
  });

  @override
  String toString() {
    return 'Vendor(vendorName: $vendorName, priceRange: $priceRange, address: $address, seatingCapacity: $seatingCapacity, operatingHours: $operatingHours)';
  }

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
    vendorName: json['vendor_name'] as String?,
    priceRange: json['price_range'] as dynamic,
    address: json['address'] as String?,
    seatingCapacity: json['seating_capacity'] as int?,
    operatingHours:
        json['operating_hours'] == null
            ? null
            : OperatingHours.fromJson(
              json['operating_hours'] as Map<String, dynamic>,
            ),
  );

  Map<String, dynamic> toJson() => {
    'vendor_name': vendorName,
    'price_range': priceRange,
    'address': address,
    'seating_capacity': seatingCapacity,
    'operating_hours': operatingHours?.toJson(),
  };

  Vendor copyWith({
    String? vendorName,
    dynamic priceRange,
    String? address,
    int? seatingCapacity,
    OperatingHours? operatingHours,
  }) {
    return Vendor(
      vendorName: vendorName ?? this.vendorName,
      priceRange: priceRange ?? this.priceRange,
      address: address ?? this.address,
      seatingCapacity: seatingCapacity ?? this.seatingCapacity,
      operatingHours: operatingHours ?? this.operatingHours,
    );
  }
}
