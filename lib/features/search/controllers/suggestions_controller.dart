import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gps_app/core/api_service/api_consumer.dart';
import 'package:gps_app/core/api_service/end_points.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/helpers/snackbar.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/search/cubits/search_cubit/search_cubit.dart';
import 'package:gps_app/features/search/models/suggestion_model/location.dart';
import 'package:gps_app/features/search/models/suggestion_model/suggestion_model.dart';
import 'package:gps_app/features/user/preferences/models/diet_model.dart';

class SuggestionsController {
  final api = serviceLocator<ApiConsumer>();

  Future<ApiResponseModel<List<DietModel>>> dietsIndex() async {
    final t = prt('dietsIndex - SearchController');
    try {
      final response = await api.get(EndPoint.diet);
      pr(response, '$t - response');
      final List<DietModel> models =
          (response as List).map((json) => DietModel.fromJson(json)).toList();
      return pr(ApiResponseModel(response: ResponseEnum.success, data: models), t);
    } catch (e) {
      String errorMessage = e.toString();
      if (e is DioException) {
        errorMessage = jsonEncode(e.response?.data ?? 'Unknown error occurred');
      }
      showSnackbar('Error', errorMessage, true);
      return pr(ApiResponseModel(errorMessage: errorMessage, response: ResponseEnum.failed), t);
    }
  }

  Future<ApiResponseModel<List<SuggestionModel>>> search({required SearchState state}) async {
    final t = prt('suggestions - SearchController');
    try {
      // final response = await api.get(EndPoint.diet);
      // pr(response, '$t - response');
      // final List<DietModel> models =
      //     (response as List).map((json) => DietModel.fromJson(json)).toList();
      return pr(ApiResponseModel(response: ResponseEnum.success, data: dummySuggestions), t);
    } catch (e) {
      String errorMessage = e.toString();
      if (e is DioException) {
        errorMessage = jsonEncode(e.response?.data ?? 'Unknown error occurred');
      }
      showSnackbar('Error', errorMessage, true);
      return pr(ApiResponseModel(errorMessage: errorMessage, response: ResponseEnum.failed), t);
    }
  }
}

final List<SuggestionModel> dummySuggestions = [
  // SuggestionModel(
  //   type: 'restaurant',
  //   userId: 1,
  //   vendorId: 101,
  //   restaurantId: 201,
  //   name: 'Brooklyn Brasserie',
  //   image: 'https://images.unsplash.com/photo-1541542684-0b6f6b2d2b66',
  //   distance: 520,
  //   address: '142 Wythe Ave, Brooklyn, NY 11249',
  //   location: Location(latitude: 40, longitude: -73),
  // ),
  SuggestionModel(
    type: 'restaurant',
    userId: 2,
    vendorId: 102,
    restaurantId: 202,
    name: 'Mission Taqueria',
    image: 'https://images.unsplash.com/photo-1544025162-d76694265947',
    distance: 1200,
    address: '288 Valencia St, San Francisco, CA 94103',
    location: Location(latitude: 37, longitude: -122),
  ),
  SuggestionModel(
    type: 'vendor',
    userId: 3,
    vendorId: 103,
    restaurantId: 203,
    name: 'Lincoln Produce Market',
    image: 'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0',
    distance: 900,
    address: '110 N State St, Chicago, IL 60602',
    location: Location(latitude: 41, longitude: -87),
  ),
  SuggestionModel(
    type: 'restaurant',
    userId: 4,
    vendorId: 104,
    restaurantId: 204,
    name: 'Sunset Burger Co.',
    image: 'https://images.unsplash.com/photo-1550547660-d9450f859349',
    distance: 650,
    address: '2311 Sunset Blvd, Los Angeles, CA 90026',
    location: Location(latitude: 34, longitude: -118),
  ),
  SuggestionModel(
    type: 'restaurant',
    userId: 5,
    vendorId: 105,
    restaurantId: 205,
    name: 'Capitol Hill Coffee',
    image: 'https://images.unsplash.com/photo-1511920170033-f8396924c348',
    distance: 430,
    address: '801 E Pike St, Seattle, WA 98122',
    location: Location(latitude: 47, longitude: -122),
  ),
  SuggestionModel(
    type: 'vendor',
    userId: 6,
    vendorId: 106,
    restaurantId: 206,
    name: 'Austin Farmers Co-op',
    image: 'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0',
    distance: 1100,
    address: '500 W 2nd St, Austin, TX 78701',
    location: Location(latitude: 30, longitude: -97),
  ),
  SuggestionModel(
    type: 'restaurant',
    userId: 7,
    vendorId: 107,
    restaurantId: 207,
    name: 'Beacon Hill Deli',
    image: 'https://images.unsplash.com/photo-1551782450-a2132b4ba21d',
    distance: 980,
    address: '97 Charles St, Boston, MA 02114',
    location: Location(latitude: 42, longitude: -71),
  ),
  SuggestionModel(
    type: 'restaurant',
    userId: 8,
    vendorId: 108,
    restaurantId: 208,
    name: 'South Beach Poke',
    image: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    // image: 'https://images.unsplash.com/photo-1529692236671-f1d6a1f7f1a3',
    distance: 820,
    address: '145 Ocean Dr, Miami Beach, FL 33139',
    location: Location(latitude: 25, longitude: -80),
  ),
  SuggestionModel(
    type: 'vendor',
    userId: 9,
    vendorId: 109,
    restaurantId: 209,
    name: 'Union Square Bakery',
    image: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    distance: 480,
    address: '200 E 14th St, New York, NY 10003',
    location: Location(latitude: 40, longitude: -73),
  ),
  SuggestionModel(
    type: 'restaurant',
    userId: 10,
    vendorId: 110,
    restaurantId: 210,
    name: 'The Denver Smokehouse',
    image: 'https://images.unsplash.com/photo-1529042410759-befb1204b468',
    distance: 980,
    address: '459 S Broadway, Denver, CO 80209',
    location: Location(latitude: 39, longitude: -104),
  ),
  SuggestionModel(
    type: 'restaurant',
    userId: 11,
    vendorId: 111,
    restaurantId: 211,
    name: 'Nashville Hot Chicken',
    image: 'https://images.unsplash.com/photo-1529042410759-befb1204b468',
    // image: 'https://images.unsplash.com/photo-1612874742237-6523e98f7a5b',
    distance: 720,
    address: '201 5th Ave S, Nashville, TN 37203',
    location: Location(latitude: 36, longitude: -86),
  ),
  SuggestionModel(
    type: 'vendor',
    userId: 12,
    vendorId: 112,
    restaurantId: 212,
    name: 'Greenway Organics',
    image: 'https://images.unsplash.com/photo-1529042410759-befb1204b468',
    // image: 'https://images.unsplash.com/photo-1615484477591-4aa1c4f7e2be',
    distance: 1300,
    address: '4301 E 9th St, Cleveland, OH 44114',
    location: Location(latitude: 41, longitude: -81),
  ),
  SuggestionModel(
    type: 'restaurant',
    userId: 13,
    vendorId: 113,
    restaurantId: 213,
    name: 'Little Havana Cocina',
    image: 'https://images.unsplash.com/photo-1529042410759-befb1204b468',
    // image: 'https://images.unsplash.com/photo-1601050690597-3b40f95d4328',
    distance: 850,
    address: '1428 SW 8th St, Miami, FL 33135',
    location: Location(latitude: 25, longitude: -80),
  ),
  SuggestionModel(
    type: 'restaurant',
    userId: 14,
    vendorId: 114,
    restaurantId: 214,
    name: 'Philly Cheesesteak House',
    image: 'https://images.unsplash.com/photo-1578683010236-d716f9a3f461',
    distance: 550,
    address: '124 Market St, Philadelphia, PA 19106',
    location: Location(latitude: 39, longitude: -75),
  ),
  SuggestionModel(
    type: 'vendor',
    userId: 15,
    vendorId: 115,
    restaurantId: 215,
    name: 'Pacific Grove Market',
    image: 'https://images.unsplash.com/photo-1511690743698-d9d85f2fbf38',
    distance: 1100,
    address: '78 Broadway, San Diego, CA 92101',
    location: Location(latitude: 32, longitude: -117),
  ),
  SuggestionModel(
    type: 'restaurant',
    userId: 16,
    vendorId: 116,
    restaurantId: 216,
    name: 'Desert Bowl (Mediterranean)',
    image: 'https://images.unsplash.com/photo-1529042410759-befb1204b468',
    // image: 'https://images.unsplash.com/photo-1601924582971-bd07b3f1c8d7',
    distance: 450,
    address: '600 E Camelback Rd, Phoenix, AZ 85014',
    location: Location(latitude: 33, longitude: -112),
  ),
  SuggestionModel(
    type: 'restaurant',
    userId: 17,
    vendorId: 117,
    restaurantId: 217,
    name: 'Twin Cities Sushi',
    image: 'https://images.unsplash.com/photo-1529042410759-befb1204b468',
    // image: 'https://images.unsplash.com/photo-1605478571929-d44c2e4f6ec4',
    distance: 920,
    address: '321 Hennepin Ave, Minneapolis, MN 55414',
    location: Location(latitude: 44, longitude: -93),
  ),
  SuggestionModel(
    type: 'vendor',
    userId: 18,
    vendorId: 118,
    restaurantId: 218,
    name: 'Bay Area Bakers',
    image: 'https://images.unsplash.com/photo-1509440159596-0249088772ff',
    distance: 700,
    address: '210 Castro St, San Francisco, CA 94114',
    location: Location(latitude: 37, longitude: -122),
  ),
  SuggestionModel(
    type: 'restaurant',
    userId: 19,
    vendorId: 119,
    restaurantId: 219,
    name: 'Orlando Family Pizzeria',
    image: 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c',
    distance: 640,
    address: '412 S Orange Ave, Orlando, FL 32801',
    location: Location(latitude: 28, longitude: -81),
  ),
  SuggestionModel(
    type: 'restaurant',
    userId: 20,
    vendorId: 120,
    restaurantId: 220,
    name: 'Sacramento Farm Kitchen',
    image: 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c',
    distance: 800,
    address: '98 Capitol Mall, Sacramento, CA 95814',
    location: Location(latitude: 38, longitude: -121),
  ),
];
