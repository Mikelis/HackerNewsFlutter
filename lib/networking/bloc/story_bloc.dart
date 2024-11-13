import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/bloc_manager/navigation_state.dart';
import '../models/story.dart';
import '../provider/api_provider.dart';

class StoryBloc extends Cubit<StoryDataState> {
  List<Story> stories = [];
  ApiProvider provider;
  int page = 0;

  StoryBloc(this.provider) : super(Complete()) {
    start();
  }

  Future<void> start() async {
     getStories();
  }

  Future<List<Story>> getStories() async {
    emit(Loading());
    var result = await provider.getFullStories(page: page);
    var error = result.keys.first;
    if(error != null){
      final res = (error).response;
      emit(Error("Error: ${res?.statusMessage ?? ""}"));
    }
    var storyList = result.values.first;
    if(storyList.isNotEmpty){
      page++;
    }
    stories.addAll(storyList);
    emit(Complete());
    return storyList;
  }
}

class StoryDataState extends NavigationState {}

class Error extends StoryDataState {
  final String error;

  Error(this.error) {
    super.msg = error;
  }
}

class Loading extends StoryDataState {}

class Complete extends StoryDataState {}
