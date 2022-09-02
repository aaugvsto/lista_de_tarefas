import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/models/task.dart';

class ToDoListItem extends StatelessWidget {
  const ToDoListItem({Key? key, required this.task, required this.removeTask}) : super(key: key);

  final Task task;
  final Function(Task) removeTask;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.symmetric(vertical: 6),
      child: Slidable(
        endActionPane:  ActionPane(
          motion: const StretchMotion(),
          extentRatio: 0.20,
          children: [
            SlidableAction(
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(4)),
              foregroundColor: Colors.white,
              onPressed: (context) {
                removeTask(task);
              },
              backgroundColor: Colors.deepOrange,
              icon: Icons.delete,
            )
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.amber[100], borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                DateFormat('dd/MM/yyyy - HH:mm').format(task.dateTime),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                task.title,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
