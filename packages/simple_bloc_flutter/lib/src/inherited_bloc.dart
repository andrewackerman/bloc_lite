import 'package:flutter/widgets.dart';
import 'package:simple_bloc/simple_bloc.dart';

Type _typeOf<T>() => T;

/// A Flutter widget which injects a [BlocController] into the widget tree.
/// The bloc can then be retrieved as a dependency injection by multiple widget
/// descendants within the child widget subtree.
class InheritedBloc<B extends BlocController> extends InheritedWidget {

  InheritedBloc({
    Key key,
    this.child,
    @required this.bloc,
  })
    : assert(bloc != null),
      super(key: key);

  /// The [Widget] and its descendants will be able to access the
  /// [BlocController] via the associated [BuildContext] object.
  final Widget child;

  /// The [BlocController] to be injected into the widget tree.
  final B bloc;

  /// A method which finds a [BlocController] of the specified subtype in the
  /// ancestor widget tree. Returns `null` if no [BlocController] is found.
  ///
  /// This method runs in O(1) time.
  static B of<B extends BlocController>(BuildContext context) {
    final type = _typeOf<InheritedBloc<B>>();
    final provider = context.ancestorInheritedElementForWidgetOfExactType(type)?.widget as InheritedBloc<B>;
    return provider?.bloc;
  }

  /// A method which crawls the ancestor tree and returns all [BlocController]s
  /// of the specified subtype that are an ancestor to the `context`. The order
  /// of the widgets will be the closest ancestor to the furthest ancestor.
  ///
  /// This method runs in O(N) time, which can be slow for large widget trees.
  /// Avoid using frequently if possible. If all you need is a single ancestor
  /// of the given type, use [of].
  static Iterable allOfType<B extends BlocController>(BuildContext context) sync* {
    final blocs = <B>[];
    context.visitAncestorElements((elem) {
      if (elem.widget is InheritedBloc<B>) {
        blocs.add((elem.widget as InheritedBloc<B>).bloc);
      }
      return true;
    });

    yield* blocs;
  }

  /// A method which crawls the ancestor tree and returns all [BlocController]s
  /// that are an ancestor to the `context`. The order of the widgets will be
  /// the closest ancestor to the furthest ancestor.
  ///
  /// This method runs in O(N) time, which can be slow for large widget trees.
  /// Avoid using frequently if possible. If all you need is a single ancestor
  /// of a particular type, use [of].
  static Iterable all(BuildContext context) sync* {
    final blocs = <BlocController>[];
    context.visitAncestorElements((elem) {
      if (elem.widget is InheritedBloc) {
        blocs.add((elem.widget as InheritedBloc).bloc);
      }
      return true;
    });

    yield* blocs;
  }

  /// Copy method which duplicates this widget with the given [Widget] child.
  /// Intended to be used by [InheritedBlocTree] to generate the necessary
  /// widget tree.
  InheritedBloc<B> withChild(Widget child) {
    return InheritedBloc<B>(key: this.key, bloc: this.bloc, child: child);
  }

  @override
  bool updateShouldNotify(InheritedBloc oldWidget) => false;

}