import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:bloc_lite/bloc_lite.dart';

import 'typedefs.dart';
import 'inherited_bloc.dart';

/// A builder [Widget] that subscribes to a [BlocStateController] and
/// automatically refreshes whenever updates to the controller are published or
/// whenever the controller's [BlocState] reports that it has mutated.
class BlocStateWidget<B extends BlocStateController, S extends BlocState>
    extends StatefulWidget {
  BlocStateWidget({
    Key key,
    @required this.controller,
    @required this.builder,
    this.builderOnError,
    this.builderOnClose,
  })  : assert(controller != null),
        assert(builder != null),
        super(key: key);

  /// A factory constructor that subscribes to a [BlocStateController] of the
  /// specified type that has been injected into the widget tree as an
  /// ancestor to this widget.
  BlocStateWidget.inherited({
    Key key,
    @required BuildContext context,
    @required BlocStateBuilder<B, S> builder,
    BlocBuilderOnError<B> builderOnError,
    BlocBuilderOnClose<B> builderOnClose,
  }) : this(
          key: key,
          controller: InheritedBloc.of<B>(context),
          builder: builder,
          builderOnError: builderOnError,
          builderOnClose: builderOnClose,
        );

  /// The [BlocStateController] that this widget subscribes to.
  final B controller;

  /// The builder function for this widget. The function is passed a reference
  /// to the controller and a reference to the state object as arguments and is
  /// fired once when the widget is first built and then again when the
  /// controller publishes an update or the state reports a mutation.
  final BlocStateBuilder<B, S> builder;

  /// An optional builder function that fires when the controller reports an
  /// error. The controller as well as the error and stacktrace are passed to
  /// the function as arguments.
  ///
  /// (If this function is null, the widget will instead print a debug message
  /// containing the error message and stacktrace.)
  final BlocBuilderOnError<B> builderOnError;

  /// An optional builder function that fires when the controller reports that
  /// its underlying stream has closed. The controller is passed to the
  /// function as arguments.
  final BlocBuilderOnClose<B> builderOnClose;

  @override
  _BlocStateWidgetState<B, S> createState() => _BlocStateWidgetState<B, S>();
}

class _BlocStateWidgetState<B extends BlocStateController, S extends BlocState>
    extends State<BlocStateWidget<B, S>> {
  StreamSubscription _subscription;
  BlocWidgetBlocState _builderState;
  Object _error;
  StackTrace _stackTrace;

  @override
  void initState() {
    _subscribe();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(BlocStateWidget<B, S> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_subscription != null) {
      _unsubscribe();
    }
    _subscribe();
  }

  void _onData(B value) {
    setState(() {
      _builderState = BlocWidgetBlocState.normal;
    });
  }

  void _onError(Object error, StackTrace stackTrace) {
    print('[WARNING] Subscribed bloc stream threw an error.');
    print(stackTrace);

    setState(() {
      _error = error;
      _stackTrace = stackTrace;
      _builderState = BlocWidgetBlocState.error;
    });
  }

  void _onDone() {
    setState(() {
      _builderState = BlocWidgetBlocState.done;
    });
  }

  void _subscribe() {
    _subscription = widget.controller
        .subscribeToUpdates(_onData, onError: _onError, onDone: _onDone);
  }

  void _unsubscribe() {
    if (_subscription == null) {
      _subscription.cancel();
      _subscription = null;
    }
  }

  @override
  Widget build(BuildContext cxt) {
    if (_builderState == BlocWidgetBlocState.done &&
        widget.builderOnClose != null) {
      return widget.builderOnClose(cxt, widget.controller);
    }

    if (_builderState == BlocWidgetBlocState.error &&
        widget.builderOnError != null) {
      return widget.builderOnError(cxt, widget.controller, _error, _stackTrace);
    }

    return widget.builder(cxt, widget.controller, widget.controller.state);
  }
}
