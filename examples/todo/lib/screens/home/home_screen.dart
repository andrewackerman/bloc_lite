import 'package:flutter/material.dart';
import 'package:bloc_lite_flutter/bloc_lite_flutter.dart';
import 'package:bloc_lite_todo/model/enums.dart';
import 'package:bloc_lite_todo/screens/home/home_screen_controller.dart';
import 'package:bloc_lite_todo/bloc/todo_controller.dart';

import 'widgets/extra_actions_button.dart';
import 'widgets/filter_button.dart';
import 'widgets/stats_counter.dart';
import 'widgets/todo_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  State createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  HomeScreenController controller;

  @override
  void initState() {
    controller = HomeScreenController(this);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext cxt) {
    return InheritedBloc(
      bloc: controller,
      child: BlocBuilder(
        controller: controller,
        builder: (_, __) =>
        BlocBuilder<TodoController>.inherited(
              context: cxt,
              builder: (_, todoBloc) => Scaffold(
                    appBar: AppBar(
                      title: Text('Simple Bloc Example'),
                      actions: [
                        FilterButton(
                          isActive: controller.activeTab == AppTab.todos,
                          activeFilter: controller.activeFilter,
                          onSelected: (visibility) =>
                              controller.updateVisibility(todoBloc, visibility),
                        ),
                        ExtraActionsButton(
                          allComplete: todoBloc.state.allComplete,
                          hasCompletedTodos: todoBloc.state.hasCompletedTodos,
                          onSelected: (action) =>
                              controller.handleExtraAction(todoBloc, action),
                        ),
                      ],
                    ),
                    body: SafeArea(
                      child: controller.activeTab == AppTab.todos
                          ? TodoList(
                              onTodoItemTapped: controller.onTodoItemTapped,
                              onTodoItemDismissed: (todo) => controller
                                  .onTodoItemDismissed(todoBloc, todo),
                              onTodoItemCheckboxChanged: (todo, value) =>
                                  controller.onTodoItemCheckboxChanged(
                                      todoBloc, todo, value),
                            )
                          : StatsCounter(),
                    ),
                    floatingActionButton: FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: () => Navigator.pushNamed(cxt, '/addTodo'),
                    ),
                    bottomNavigationBar: BottomNavigationBar(
                      currentIndex:
                          controller.activeTab == AppTab.todos ? 0 : 1,
                      onTap: controller.onTabTap,
                      items: [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.list),
                          title: Text('Todos'),
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.show_chart),
                          title: Text('Stats'),
                        ),
                      ],
                    ),
                  ),
            ),
      ),
    );
  }
}
