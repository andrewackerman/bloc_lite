import 'package:flutter/widgets.dart';

import 'inherited_bloc.dart';

/// A Flutter widget which injects multiple [BlocController]s into the widget
/// tree. The blocs can then be retrieved as dependency injections by multiple
/// widget descendants within the child widget subtree.
class InheritedBlocTree extends StatelessWidget {

  InheritedBlocTree({
    Key key,
    @required this.child,
    @required this.blocProviders,
  }) 
    : assert(child != null),
      assert(blocProviders != null),
      super(key: key);

  /// The [Widget] and its descendants will be able to access the
  /// [BlocController] via the associated [BuildContext] object.
  final Widget child;

  /// A collection of [InheritedBloc] widgets to be inserted into the widget
  /// tree as ancestors of `child`.
  final List<InheritedBloc> blocProviders;

  @override
  Widget build(BuildContext cxt) {
    Widget child = this.child;

    for (var bloc in blocProviders.reversed) {
      child = bloc.withChild(child);
    }

    return child;
  }

}