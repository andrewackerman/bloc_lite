import 'package:flutter/widgets.dart';

import 'inherited_bloc.dart';

class InheritedBlocTree extends StatelessWidget {

  InheritedBlocTree({
    Key key,
    @required this.child,
    @required this.blocProviders,
  }) 
    : assert(child != null),
      assert(blocProviders != null),
      super(key: key);

  final Widget child;
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