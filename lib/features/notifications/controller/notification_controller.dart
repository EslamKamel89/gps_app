import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gps_app/core/api_service/api_consumer.dart';
import 'package:gps_app/core/api_service/end_points.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/helpers/snackbar.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/notifications/models/notification_model.dart';

class NotificationController {
  final _api = serviceLocator<ApiConsumer>();
  Future<ApiResponseModel<List<NotificationModel>>> notifications() async {
    final t = prt('notifications - NotificationController');
    try {
      final response = await _api.get("${EndPoint.notifications}?want=all");
      pr(response, '$t - response');
      final List<NotificationModel> models =
          (response['notifications'] as List)
              // (dummyData['notifications'] as List)
              .map((json) => NotificationModel.fromJson(json))
              .toList();
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

  Future<ApiResponseModel<bool>> markAsRead(int? notificationId) async {
    final t = prt('markAsRead - NotificationController');
    try {
      final response = await _api.put("${EndPoint.notifications}/$notificationId");
      pr(response, '$t - response');
      return pr(ApiResponseModel(response: ResponseEnum.success, data: true), t);
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

final dummyData = {
  "notifications": [
    {
      "id": 5,
      "path": "wishList",
      "content": "New wishlist Added",
      "path_id": 5,
      "created_at": "2025-11-18 06:45:49",
      "updated_at": "2025-11-18 06:45:49",
      "device_id": 6,
      "is_read": 1,
      "user_id": 4,
      "access_token":
          "dqSl7Z4nQA6vf6LGPr6DZk:APA91bFX6SGCHps_seB1nkN5UJBIfOPJH7xcIfVSwIt7D0WdwmWvhG5p_9zpkWixRvbZtuyGuF18-3nHxMG0bvuxxgFXc0IArlDPLeaj74uipr5ZpwhdcDM",
    },
    {
      "id": 6,
      "path": "wishList",
      "content": "New wishlist Added",
      "path_id": 5,
      "created_at": "2025-11-18 07:12:05",
      "updated_at": "2025-11-18 07:12:05",
      "device_id": 6,
      "is_read": 1,
      "user_id": 4,
      "access_token":
          "dqSl7Z4nQA6vf6LGPr6DZk:APA91bFX6SGCHps_seB1nkN5UJBIfOPJH7xcIfVSwIt7D0WdwmWvhG5p_9zpkWixRvbZtuyGuF18-3nHxMG0bvuxxgFXc0IArlDPLeaj74uipr5ZpwhdcDM",
    },
    {
      "id": 7,
      "path": "wishList",
      "content": "New wishlist Added",
      "path_id": 5,
      "created_at": "2025-11-18 07:13:14",
      "updated_at": "2025-11-18 07:13:14",
      "device_id": 6,
      "is_read": 1,
      "user_id": 4,
      "access_token":
          "dqSl7Z4nQA6vf6LGPr6DZk:APA91bFX6SGCHps_seB1nkN5UJBIfOPJH7xcIfVSwIt7D0WdwmWvhG5p_9zpkWixRvbZtuyGuF18-3nHxMG0bvuxxgFXc0IArlDPLeaj74uipr5ZpwhdcDM",
    },
    {
      "id": 8,
      "path": "wishList",
      "content": "New wishlist Added",
      "path_id": 5,
      "created_at": "2025-11-18 07:17:25",
      "updated_at": "2025-11-18 07:17:25",
      "device_id": 6,
      "is_read": 1,
      "user_id": 4,
      "access_token":
          "dqSl7Z4nQA6vf6LGPr6DZk:APA91bFX6SGCHps_seB1nkN5UJBIfOPJH7xcIfVSwIt7D0WdwmWvhG5p_9zpkWixRvbZtuyGuF18-3nHxMG0bvuxxgFXc0IArlDPLeaj74uipr5ZpwhdcDM",
    },
    {
      "id": 9,
      "path": "wishList",
      "content": "user : OsaMA need food please food",
      "path_id": 5,
      "created_at": "2025-11-18 07:38:36",
      "updated_at": "2025-11-18 07:38:36",
      "device_id": 6,
      "is_read": 1,
      "user_id": 4,
      "access_token":
          "dqSl7Z4nQA6vf6LGPr6DZk:APA91bFX6SGCHps_seB1nkN5UJBIfOPJH7xcIfVSwIt7D0WdwmWvhG5p_9zpkWixRvbZtuyGuF18-3nHxMG0bvuxxgFXc0IArlDPLeaj74uipr5ZpwhdcDM",
    },
    {
      "id": 10,
      "path": "itemInfoScreen",
      "content": "Your wish has been accepted",
      "path_id": 1,
      "created_at": "2025-11-18 08:06:52",
      "updated_at": "2025-11-18 08:06:52",
      "device_id": 6,
      "is_read": 1,
      "user_id": 4,
      "access_token":
          "dqSl7Z4nQA6vf6LGPr6DZk:APA91bFX6SGCHps_seB1nkN5UJBIfOPJH7xcIfVSwIt7D0WdwmWvhG5p_9zpkWixRvbZtuyGuF18-3nHxMG0bvuxxgFXc0IArlDPLeaj74uipr5ZpwhdcDM",
    },
    {
      "id": 11,
      "path": "itemInfoScreen",
      "content": "Your wish list has been accepted by vendor Osama is here",
      "path_id": 1,
      "created_at": "2025-11-18 08:11:25",
      "updated_at": "2025-11-18 08:11:25",
      "device_id": 6,
      "is_read": 1,
      "user_id": 4,
      "access_token":
          "dqSl7Z4nQA6vf6LGPr6DZk:APA91bFX6SGCHps_seB1nkN5UJBIfOPJH7xcIfVSwIt7D0WdwmWvhG5p_9zpkWixRvbZtuyGuF18-3nHxMG0bvuxxgFXc0IArlDPLeaj74uipr5ZpwhdcDM",
    },
    {
      "id": 12,
      "path": "wishList",
      "content": "Your wish has been accepted by vendor Osama is here",
      "path_id": 2,
      "created_at": "2025-11-18 08:25:18",
      "updated_at": "2025-11-18 08:25:18",
      "device_id": 6,
      "is_read": 1,
      "user_id": 4,
      "access_token":
          "dqSl7Z4nQA6vf6LGPr6DZk:APA91bFX6SGCHps_seB1nkN5UJBIfOPJH7xcIfVSwIt7D0WdwmWvhG5p_9zpkWixRvbZtuyGuF18-3nHxMG0bvuxxgFXc0IArlDPLeaj74uipr5ZpwhdcDM",
    },
    {
      "id": 13,
      "path": "blogListScreen",
      "content": "New blog post: dfsdfsdg",
      "path_id": 8,
      "created_at": "2025-11-18 08:30:08",
      "updated_at": "2025-11-18 08:30:08",
      "device_id": 6,
      "is_read": 1,
      "user_id": 4,
      "access_token":
          "dqSl7Z4nQA6vf6LGPr6DZk:APA91bFX6SGCHps_seB1nkN5UJBIfOPJH7xcIfVSwIt7D0WdwmWvhG5p_9zpkWixRvbZtuyGuF18-3nHxMG0bvuxxgFXc0IArlDPLeaj74uipr5ZpwhdcDM",
    },
    {
      "id": 14,
      "path": "wishList",
      "content": "user : OsaMA need food please food",
      "path_id": 9,
      "created_at": "2025-11-18 11:23:18",
      "updated_at": "2025-11-18 11:23:18",
      "device_id": 6,
      "is_read": 1,
      "user_id": 4,
      "access_token":
          "dqSl7Z4nQA6vf6LGPr6DZk:APA91bFX6SGCHps_seB1nkN5UJBIfOPJH7xcIfVSwIt7D0WdwmWvhG5p_9zpkWixRvbZtuyGuF18-3nHxMG0bvuxxgFXc0IArlDPLeaj74uipr5ZpwhdcDM",
    },
    {
      "id": 15,
      "path": "wishList",
      "content": "user : wish from app",
      "path_id": 10,
      "created_at": "2025-11-18 11:24:02",
      "updated_at": "2025-11-18 11:24:02",
      "device_id": 6,
      "is_read": 1,
      "user_id": 4,
      "access_token":
          "dqSl7Z4nQA6vf6LGPr6DZk:APA91bFX6SGCHps_seB1nkN5UJBIfOPJH7xcIfVSwIt7D0WdwmWvhG5p_9zpkWixRvbZtuyGuF18-3nHxMG0bvuxxgFXc0IArlDPLeaj74uipr5ZpwhdcDM",
    },
  ],
};
