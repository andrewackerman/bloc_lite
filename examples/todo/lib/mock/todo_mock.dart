import 'package:bloc_lite_todo/bloc/todo_controller.dart';
import 'package:bloc_lite_todo/model/todo.dart';

final data = TodoState()
  ..todos = [
    Todo('Buy food for da kitty', note: 'With the chickeny bits!'),
    Todo('Find a Red Sea dive trip', note: 'Echo vs MY Dream'),
    Todo('Book flights to Egypt', complete: true),
    Todo('Decide on accomodation'),
  ];
