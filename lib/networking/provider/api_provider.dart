import 'package:dio/dio.dart';
import 'package:entain_test/networking/models/story.dart';
import 'package:entain_test/networking/models/user.dart';
import 'package:logger/logger.dart';

import '../api_client.dart';

class ApiProvider {
  ApiClient apiClient;
  List<int>? topStoriesWithIds;
  List<int>? userStoriesWithIds;
  final logger = Logger();
  int storiesPerPage = 10;

  ApiProvider(this.apiClient);

  Future<Map<DioException?, List<Story>>> getFullStories(
      {int page = 0, bool cache = true, List<int>? storyIds}) async {
    var storiesIdsToUse = topStoriesWithIds;
    if (storyIds != null) {
      storiesIdsToUse = storyIds;
    }
    DioException? error;
    if (storiesIdsToUse == null || cache == false) {
      storiesIdsToUse = await apiClient.getTopStories().then((onValue) {
        return onValue;
      }).catchError((obj) {
        error = handleError(obj, error);
        return <int>[];
      });
    }
    int maxCount = storiesIdsToUse.length ?? 0;
    int start = page * storiesPerPage;
    int end = (page + 1) * storiesPerPage;

    if (start > maxCount) {
      start = maxCount;
    }
    if (end > maxCount) {
      end = maxCount;
    }
    Iterable<int> queryStoryIds = storiesIdsToUse.getRange(start, end) ?? [];

    List<Story> list = [];
    for (int id in queryStoryIds) {
      await apiClient.getSingleStory(id.toString()).then((value) {
        logger.i(value.title);
        if(value.title != null){
          list.add(value);
        }
      }).catchError((obj) {
        error = handleError(obj, error);
      });
    }
    return {error: list};
  }

  DioException? handleError(obj, DioException? error) {
    switch (obj.runtimeType) {
      case const (DioException):
        error = obj;
        final res = (obj as DioException).response;
        logger.e('Got error : ${res?.statusCode} -> ${res?.statusMessage}');
        break;
      default:
        break;
    }
    return error;
  }

  Future<Map<DioException?, User>> getUserInfo(String id) async {
    DioException? error;
    var userInfo = await apiClient.getUserInfo(id).then((onValue) {
      return onValue;
    }).catchError((obj) {
      error = handleError(obj, error);
      return User();
    });
    userStoriesWithIds = userInfo.submitted;
    return {error: userInfo};
  }
}
