import 'package:flutter/widgets.dart';
import 'package:simple_bloc/simple_bloc.dart';

typedef BlocBuilder<B extends BlocController> = Widget Function(BuildContext context, B controller);
typedef BlocStateBuilder<B extends BlocController, S extends BlocState> = Widget Function(BuildContext context, B controller, S state);
typedef BlocBuilderOnError<B extends BlocController> = Widget Function(BuildContext context, B controller, Object error, StackTrace stackTrace);
typedef BlocBuilderOnClose<B extends BlocController> = Widget Function(BuildContext context, B controller);

enum BlocWidgetBlocState {
  normal,
  error,
  done,
}
