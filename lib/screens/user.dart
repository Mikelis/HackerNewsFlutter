import 'package:entain_test/networking/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../common/bloc_manager/bloc_manager.dart';
import '../common/ui/list_item.dart';
import '../common/ui/url_launch.dart';
import '../generated/l10n.dart';
import '../networking/provider/api_provider.dart';

class UserScreen extends StatefulWidget {
  final String userId;

  const UserScreen({super.key, required this.userId});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late UserBloc bloc;

  @override
  void initState() {
    bloc = UserBloc(widget.userId, GetIt.I<ApiProvider>());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocManager<UserBloc, UserDataState>()
        .manageCubit(bloc, (context, state) {}, (context, state) {
      return Stack(children: [
        Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).user_title),
          ),
          body: NotificationListener<ScrollEndNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels ==
                  notification.metrics.maxScrollExtent) {
                context.read<UserBloc>().getUserInfo(widget.userId);
              }
              return false;
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: bloc.stories.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return UserProfileHeading(
                    userName: bloc.user?.id ?? "",
                    about: bloc.user?.about ?? "",
                    creationDate: bloc.user?.created ?? 0,
                  );
                } else {
                  final item = bloc.stories[index - 1];
                  return ListTile(
                    title: StoryListItem(
                      title: item.title ?? "",
                      subtitle: null,
                      time: item.time ?? 0,
                    ),
                    onTap: () {
                      openWeb(item.url);
                    }, // Handle your onTap here.
                  );
                }
              },
            ),
          ),
        ),
        if (state is Loading) const Center(child: CircularProgressIndicator())
      ]);
    });
  }
}

class UserProfileHeading extends StatelessWidget {
  final String userName;
  final int creationDate;
  final String about;
  final Color nameColor;
  final Color dateColor;
  final Color aboutColor;
  final double nameFontSize;
  final double dateFontSize;
  final double aboutFontSize;
  final double padding;

  const UserProfileHeading({
    super.key,
    required this.userName,
    required this.creationDate,
    required this.about,
    this.nameColor = Colors.black,
    this.dateColor = Colors.grey,
    this.aboutColor = Colors.black87,
    this.nameFontSize = 26.0,
    this.dateFontSize = 14.0,
    this.aboutFontSize = 16.0,
    this.padding = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat.yMMMMd()
        .format(DateTime.fromMillisecondsSinceEpoch(creationDate * 1000));

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userName,
            style: TextStyle(
              fontSize: nameFontSize,
              fontWeight: FontWeight.bold,
              color: nameColor,
            ),
          ),
          if (creationDate != 0)
            Text(
              formattedDate,
              style: TextStyle(
                fontSize: dateFontSize,
                color: dateColor,
              ),
            ),
          const SizedBox(height: 8.0),
          Html(
            data: about,
          ),
        ],
      ),
    );
  }
}
