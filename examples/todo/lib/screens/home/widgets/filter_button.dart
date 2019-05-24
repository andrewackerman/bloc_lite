import 'package:flutter/material.dart';
import 'package:bloc_lite_todo/model/enums.dart';

class FilterButton extends StatelessWidget {
  FilterButton({
    this.onSelected,
    this.activeFilter,
    this.isActive,
  });

  final PopupMenuItemSelected<VisibilityFilter> onSelected;
  final VisibilityFilter activeFilter;
  final bool isActive;

  @override
  Widget build(BuildContext cxt) {
    final defaultStyle = Theme.of(cxt).textTheme.body1;
    final activeStyle = Theme.of(cxt).textTheme.body1.copyWith(
          color: Theme.of(cxt).accentColor,
        );

    final button = _Button(
      onSelected: onSelected,
      activeFilter: activeFilter,
      activeStyle: activeStyle,
      defaultStyle: defaultStyle,
    );

    return AnimatedOpacity(
      opacity: isActive ? 1 : 0,
      duration: Duration(milliseconds: 100),
      child: isActive ? button : IgnorePointer(child: button),
    );
  }
}

class _Button extends StatelessWidget {
  _Button({
    this.onSelected,
    this.activeFilter,
    this.defaultStyle,
    this.activeStyle,
  });

  final PopupMenuItemSelected<VisibilityFilter> onSelected;
  final VisibilityFilter activeFilter;
  final TextStyle defaultStyle;
  final TextStyle activeStyle;

  @override
  Widget build(BuildContext cxt) {
    return PopupMenuButton<VisibilityFilter>(
      tooltip: 'Filter Todos',
      onSelected: onSelected,
      icon: Icon(Icons.filter_list),
      itemBuilder: (BuildContext btnCxt) => [
            PopupMenuItem(
              value: VisibilityFilter.all,
              child: Text(
                'Show All',
                style: activeFilter == VisibilityFilter.all
                    ? activeStyle
                    : defaultStyle,
              ),
            ),
            PopupMenuItem(
              value: VisibilityFilter.active,
              child: Text(
                'Show Active',
                style: activeFilter == VisibilityFilter.active
                    ? activeStyle
                    : defaultStyle,
              ),
            ),
            PopupMenuItem(
              value: VisibilityFilter.completed,
              child: Text(
                'Show Completed',
                style: activeFilter == VisibilityFilter.completed
                    ? activeStyle
                    : defaultStyle,
              ),
            ),
          ],
    );
  }
}
