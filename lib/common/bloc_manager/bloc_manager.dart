import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_state.dart';

// HOW TO USE SAMPLE
// return BlocManager<CUBIT, STATE>().manageCubit(
// CUBIT(),
// (context, state) {},
// (context, state) => WIDGET);

// !!!! using this class type is required or it will fail with no Provider found !!!!
class BlocManager<CubitObject extends StateStreamableSource<State>,
    State extends NavigationState> {
  BlocProvider<CubitObject> manageCubit(
      CubitObject cubitObject,
      void Function(BuildContext context, State) onNavigationEvent,
      Widget Function(BuildContext context, State) onBuildEvent,
      {BlocBuilderCondition? buildWhen,
      BlocListenerCondition? listenWhen,
      bool reuseProvider = false}) {
    if (reuseProvider) {
      return BlocProvider<CubitObject>.value(
          value: cubitObject,
          child: getBlocConsumer(onNavigationEvent, onBuildEvent,
              buildWhen: buildWhen, listenWhen: listenWhen));
    }
    return BlocProvider<CubitObject>(
        create: (BuildContext _) {
          return cubitObject;
        },
        child: getBlocConsumer(onNavigationEvent, onBuildEvent,
            buildWhen: buildWhen, listenWhen: listenWhen));
  }

  BlocConsumer<CubitObject, State> getBlocConsumer(
      void Function(BuildContext context, State) onNavigationEvent,
      Widget Function(BuildContext context, State) onBuildEvent,
      {BlocBuilderCondition? buildWhen,
      BlocListenerCondition? listenWhen}) {
    return BlocConsumer<CubitObject, State>(
      buildWhen: buildWhen,
      listenWhen: listenWhen,
      listener: (BuildContext context, State state) {
        state.navigationAction(context);
        onNavigationEvent.call(context, state);
        if (state.msg != null) {
          final msg = state.msg;
          if (msg != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(msg),
            ));
          }
        }
      },
      builder: (BuildContext context, State state) {
        return onBuildEvent.call(context, state);
      },
    );
  }
}
