import 'package:flutter/widgets.dart';
import 'package:bloc_lite/bloc_lite.dart';

typedef BlocBuilderOnBuild<B extends BlocController> = Widget Function(
    BuildContext context, B controller);
typedef BlocBuilderOnError<B extends BlocController> = Widget Function(
    BuildContext context, B controller, Object error, StackTrace stackTrace);
typedef BlocBuilderOnClose<B extends BlocController> = Widget Function(
    BuildContext context, B controller);
