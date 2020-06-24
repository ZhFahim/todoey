import 'package:flutter/material.dart';
import 'package:todoey/widgets/task_tile.dart';
import 'package:provider/provider.dart';
import 'package:todoey/task_data.dart';

class TasksList extends StatefulWidget {
  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        return ListView.builder(
          padding: EdgeInsets.all(15.0),
          itemCount: taskData.taskCount,
          itemBuilder: (context, index) {
            final task = taskData.tasks[index];
            return TaskTile(
              taskTitle: task.name,
              isChecked: task.isDone,
              checkboxCallback: (checkboxState) {
                taskData.updateTask(task);
              },
              onLongPressCallback: () {
                taskData.deleteTask(task);
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Task deleted!',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    backgroundColor: Colors.lightBlue,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
