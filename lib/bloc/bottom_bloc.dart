import 'package:testingbloc_course/bloc/app_bloc.dart';

class BottomBloc extends AppBloc {
  BottomBloc({
    Duration? waitBeforeLoading,
    required Iterable<String> allUrls,
  }) : super(
          waitBeforeLoading: waitBeforeLoading,
          allUrls: allUrls,
        );
}
