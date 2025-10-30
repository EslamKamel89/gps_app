class EndPoint {
  // static const String baseUrl = "http://10.0.2.2:8000";
  static const String baseUrl = "https://gps.gaztec.org";
  static const String category = "$baseUrl/api/category";
  static const String states = "$baseUrl/api/states";
  static const String holidays = "$baseUrl/api/holidays";
  static const String districts = "$baseUrl/api/districts";
  static const String userRegister = "$baseUrl/api/user-register";
  static const String userSync = "$baseUrl/api/user-sync";
  static const String vendorRegister = "$baseUrl/api/vendor-register";
  static const String login = "$baseUrl/api/login";
  static const String uploadImages = "$baseUrl/api/uploads/images";
  static const String vendorCatalogSection = "$baseUrl/api/vendors/catalog/bulk";
  static const String otpVerify = "$baseUrl/api/email/otp/verify";
  static const String otpRequest = "$baseUrl/api/email/otp";
  static const String restaurantBranches = "$baseUrl/api/vendors/branch/bulk";
  static const String restaurantMenus = "$baseUrl/api/restaurant-menus";
  static const String addRestaurantMenus = "$baseUrl/api/add-restaurant-menu";
  static const String restaurantCertificates = "$baseUrl/api/certificates";
  static const String restaurants = "$baseUrl/api/restaurants";
  static const String wishlist = "$baseUrl/api/wishlists";
  static const String acceptWishList = "$baseUrl/api/accept-wishlists";
  static const String mealItems = "$baseUrl/api/wishlists/get-items";
  static const String itemDetails = "$baseUrl/api/wishlists/get-item-details";
  static const String addMeal = "$baseUrl/api/meals";
  static const String branches = "$baseUrl/api/branches";
  static const String sections = "$baseUrl/api/catalog-sections";
}
