import 'package:flutter/widgets.dart';
import 'package:bloc_lite/bloc_lite.dart';
import 'package:bloc_lite_flutter/bloc_lite_flutter.dart';
import 'package:bloc_lite_todo/bloc/todo_controller.dart';
import 'package:bloc_lite_todo/model/todo.dart';

import 'add_edit_screen.dart';

class AddEditScreenController extends BlocController {

  AddEditScreenController(this.widgetState) : super();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AddEditScreenState widgetState;

  String task;
  String note;

  bool get isEditing => widgetState.widget.todo != null;

  String taskValidator(String value) {
    if (value.trim().isEmpty)
      return 'Todo task cannot be empty';
    return null;
  }

  void onTaskSaved(String value) {
    task = value;
  }

  void onNoteSaved(String value) {
    note = value;
  }

  void saveButtonPressed() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      final todoBloc = InheritedBloc.of<TodoController>(widgetState.context);

      if (isEditing) {
        todoBloc.updateTodo(
          widgetState.widget.todo,
          task: task,
          note: note,
        );
      } else {
        todoBloc.addTodo(Todo(task, note: note));
      }

      Navigator.pop(widgetState.context);
    }
  }

}