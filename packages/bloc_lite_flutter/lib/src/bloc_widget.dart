import 'package:bloc_lite/bloc_lite.dart';
import 'package:flutter/widgets.dart';

import 'bloc_builder.dart';

/// A class that abstracts the lifetime management and update rebuilding of a
/// [BlocController]. This class extends [StatefulWidget] in order to dispose
/// the controller automatically in the event that this widget gets removed
/// from the widget tree.
abstract class BlocWidget<B extends BlocController> extends StatefulWidget {
  BlocWidget({
    Key key,
  }) : super(key: key);

  // A really janky way to store a reference to the state in order to expose the
  // controller object to the extending class. (Temporary while I hunt for a
  // better solution.)
  final _stateStore = <_BlocWidgetState<B>>[null];
  B get controller => this._stateStore[0].controller;

  @protected
  /// A function to create the [BlocController]. This function is called for the
  /// first time after `didChangeDependencies` is called for the first time on
  /// the underlying [State].
  B createController(BuildContext context);

  @protected
  /// The build function for this widget. It is called from the underlying
  /// [State] object on a rebuild. Follows the same rules as the typical Flutter
  /// build method.
  Widget build(BuildContext context);

  @protected
  /// An optional build function that is called in the event that the controller's
  /// underlying stream object reports an error. Redirects to `build` by default.
  Widget buildOnError(BuildContext context, Object error, StackTrace stackTrace) => build(context);

  @protected
  /// An optional build function that is called in the event that the controller's
  /// underlying stream object has closed. Redirects to `build` by default.
  Widget buildOnClose(BuildContext context) => build(context);

  @override
  _BlocWidgetState<B> createState() => _BlocWidgetState<B>();
}

class _BlocWidgetState<B extends BlocController> extends State<BlocWidget> {
  B controller;

  void _initController() {
    controller = widget.createController(context);
    assert(controller != null, 'The bloc controller must not be null.');
  }

  @override
  void initState() {
    widget._stateStore[0] = this;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (controller == null) _initController();
    widget._stateStore[0] = this;
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(BlocWidget<BlocController> oldWidget) {
    if (controller == null) _initController();
    widget._stateStore[0] = this;
    super.didUpdateWidget(oldWidget);
  }

  @override
  dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext cxt) {
    return BlocBuilder(
      controller: controller,
      autoDispose: true,
      builder: (_, __) => widget.build(cxt),
      builderOnError: (_, __, err, st) => widget.buildOnError(cxt, err, st),
      builderOnClose: (_, __) => widget.buildOnClose(cxt),
    );
  }
}