import 'package:flutter/material.dart';
import 'package:bloc_lite_todo/model/enums.dart';

class ExtraActionsButton extends StatelessWidget {

  ExtraActionsButton({
    this.onSelected,
    this.allComplete = false,
    this.hasCompletedTodos = true,
  });

  final PopupMenuItemSelected<ExtraAction> onSelected;
  final bool allComplete;
  final bool hasCompletedTodos;

  @override
  Widget build(BuildContext cxt) {
    return PopupMenuButton(
      onSelected: onSelected,
      itemBuilder: (btnCxt) => [
        PopupMenuItem(
          value: ExtraAction.toggleAllComplete,
          child: Text(allComplete
            ? 'Mark All Incomplete'
            : 'Mark All Complete'),
        ),
        PopupMenuItem(
          value: ExtraAction.clearCompleted,
          child: Text('Clear Completed'),
        ),
      ],
    );
  }

}