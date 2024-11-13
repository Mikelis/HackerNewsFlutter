import 'package:dio/dio.dart';
import 'package:entain_test/networking/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/bloc_manager/navigation_state.dart';
import '../models/story.dart';
import '../provider/api_provider.dart';

class UserBloc extends Cubit<UserDataState> {
  List<Story> stories = [];
  ApiProvider provider;
  int page = 0;
  String id;
  User? user;

  UserBloc(this.id, this.provider) : super(Complete()) {
    start();
  }

  Future<void> start() async {
    getUserInfo(id);
  }

  Future<Map<User?, List<Story>>> getUserInfo(String id) async {
    emit(Loading());
    DioException? error;
    if (user == null) {
      var result = await provider.getUserInfo(id);
      error = result.keys.first;
      if (error != null) {
        emitError(error);
      }
      user = result.values.first;
    }
    var userStories =
        await provider.getFullStories(page: page, storyIds: user?.submitted);
    error = userStories.keys.first;

    if (error != null) {
      emitError(error);
    }
    var storyList = userStories.values.first;

    if (storyList.isNotEmpty) {
      page++;
    }
    stories.addAll(storyList);

    emit(Complete());
    return {user: storyList};
  }

  void emitError(DioException error) {
    final res = (error).response;
    emit(Error("Error: ${res?.statusMessage ?? ""}"));
  }
}

class UserDataState extends NavigationState {}

class Error extends UserDataState {
  final String error;

  Error(this.error) {
    super.msg = error;
  }
}

class Loading extends UserDataState {}

class Complete extends UserDataState {}
