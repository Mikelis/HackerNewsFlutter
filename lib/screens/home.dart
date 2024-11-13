import 'package:entain_test/networking/bloc/story_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../common/bloc_manager/bloc_manager.dart';
import '../common/ui/list_item.dart';
import '../common/ui/url_launch.dart';
import '../generated/l10n.dart';
import '../networking/provider/api_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StoryBloc bloc;

  @override
  void initState() {
    bloc = StoryBloc(GetIt.I<ApiProvider>());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocManager<StoryBloc, StoryDataState>()
        .manageCubit(bloc, (context, state) {}, (context, state) {
      return Stack(children: [
        StoryList(bloc),
        if (state is Loading) const Center(child: CircularProgressIndicator())
      ]);
    });
  }
}

class StoryList extends StatelessWidget {
  final StoryBloc bloc;

  const StoryList(
    this.bloc, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).list_title),
      ),
      body: NotificationListener<ScrollEndNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels ==
              notification.metrics.maxScrollExtent) {
            context.read<StoryBloc>().getStories();
          }
          return false;
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: bloc.stories.length,
          itemBuilder: (context, index) {
            final item = bloc.stories[index];
            return ListTile(
              title: StoryListItem(
                title: item.title ?? "",
                subtitle: item.by ?? "",
                time: item.time ?? 0,
              ),
              onTap: () {
                openWeb(item.url);
              }, // Handle your onTap here.
            );
          },
        ),
      ),
    );
  }
}
