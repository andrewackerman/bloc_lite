import 'package:flutter/material.dart';
import 'package:bloc_lite_todo/model/todo.dart';

import 'add_edit_screen_controller.dart';

class AddEditScreen extends StatefulWidget {
  final Todo todo;

  AddEditScreen({
    this.todo,
  });

  @override
  State createState() => AddEditScreenState();
}

class AddEditScreenState extends State<AddEditScreen> {
  AddEditScreenController controller;

  @override
  void initState() {
    controller = AddEditScreenController(this);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext cxt) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.isEditing ? 'Edit Todo' : 'Add Todo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          autovalidate: false,
          onWillPop: () => Future(() => true),
          child: ListView(
            children: [
              TextFormField(
                initialValue: widget.todo == null ? '' : widget.todo.task,
                autofocus: controller.isEditing ? false : true,
                style: Theme.of(cxt).textTheme.headline,
                decoration: InputDecoration(
                  hintText: 'New Todo',
                ),
                validator: controller.taskValidator,
                onSaved: controller.onTaskSaved,
              ),
              TextFormField(
                  initialValue: widget.todo == null ? '' : widget.todo.note,
                  maxLines: 10,
                  style: Theme.of(cxt).textTheme.subhead,
                  decoration: InputDecoration(
                    hintText: 'Todo Note',
                  ),
                  onSaved: controller.onNoteSaved)
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: controller.isEditing ? 'Save Changes' : 'Add Todo',
        child: Icon(controller.isEditing ? Icons.check : Icons.add),
        onPressed: controller.saveButtonPressed,
      ),
    );
  }
}
