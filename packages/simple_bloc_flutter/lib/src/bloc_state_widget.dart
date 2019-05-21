import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:simple_bloc/simple_bloc.dart';

import 'bloc_flutter.dart';
import 'inherited_bloc.dart';

class BlocStateWidget<B extends BlocController, S extends BlocState> extends StatefulWidget {

  BlocStateWidget({
    Key key,
    @required this.controller,
    @required this.builder,
    this.builderOnError,
    this.builderOnClose,
  }) : assert(controller != null),
       assert(controller is BlocControllerWithState),
       assert(builder != null),
       super(key: key);

  BlocStateWidget.inherited({
    Key key,
    @required BuildContext context,
    @required Widget Function(BuildContext, B, S) builder,
    Function(BuildContext, Error, StackTrace) builderOnError,
    Widget Function(BuildContext) builderOnClose,
  }) : this(
      key: key,
      controller: InheritedBloc.of<B>(context),
      builder: builder,
      builderOnError: builderOnError,
      builderOnClose: builderOnClose,
    );

  final B controller;
  final BlocStateBuilder<B, S> builder;
  final BlocBuilderOnError builderOnError;
  final BlocBuilderOnClose builderOnClose;

  @override
  _BlocStateWidgetState<B, S> createState() => _BlocStateWidgetState<B, S>();

}

class _BlocStateWidgetState<B extends BlocController, S extends BlocState> extends State<BlocStateWidget<B, S>> {

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
    _subscription = widget.controller.subscribeToUpdates(_onData, onError: _onError, onDone: _onDone);
  }

  void _unsubscribe() {
    if (_subscription == null) {
      _subscription.cancel();
      _subscription = null;
    }
  }

  @override
  Widget build(BuildContext cxt) {
    if (_builderState == BlocWidgetBlocState.done && widget.builderOnClose != null) {
      return widget.builderOnClose(cxt);
    }

    if (_builderState == BlocWidgetBlocState.error && widget.builderOnError != null) {
      return widget.builderOnError(cxt, _error, _stackTrace);
    }

    final state = (widget.controller as BlocControllerWithState).state;
    return widget.builder(cxt, widget.controller, state);
  }

}