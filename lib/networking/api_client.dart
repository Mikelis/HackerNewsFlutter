import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'models/story.dart';
import 'models/user.dart';
part 'api_client.g.dart';


@RestApi(baseUrl: 'https://hacker-news.firebaseio.com/v0')
abstract class ApiClient {
  factory ApiClient(Dio dio) = _ApiClient;

  @GET('/topstories.json')
  Future<List<int>> getTopStories();

  @GET('/item/{id}.json')
  Future<Story> getSingleStory(@Path('id') String id);

  @GET('/user/{id}.json')
  Future<User> getUserInfo(@Path('id') String id);
}
