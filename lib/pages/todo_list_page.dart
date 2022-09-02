import 'package:flutter/material.dart';
import 'package:todo_list/models/task.dart';
import 'package:todo_list/repositories/task_repository.dart';

import '../widgets/todo_list_item.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({Key? key}) : super(key: key);

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  final TextEditingController taskController = TextEditingController();
  final TaskRepository taskRepository = TaskRepository();

  List<Task> tasks = [];
  Task? deletedTask;
  int? deletedTaskPos;
  String? errorText;

  @override
  void initState() {
    super.initState();

    taskRepository.getTaskList().then((value) {
      setState(() {
        tasks = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: Text(
                  'Lista de Tarefas',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: taskController,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber),
                        ),
                        border: const OutlineInputBorder(),
                        hintText: 'Adicione uma tarefa aqui',
                        errorText: errorText,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.amber,
                        padding: const EdgeInsets.all(4)),
                    onPressed: () {
                      String text = taskController.text;

                      if(text.isEmpty){
                        setState(() {
                          errorText='O título da tarefa não pode ser vazio!';
                        });
                        return;
                      }

                      setState(() {
                        Task task = Task(
                          title: text,
                          dateTime: DateTime.now(),
                        );
                        tasks.add(task);
                        errorText = null;
                      });
                      taskController.clear();
                      taskRepository.saveTaskList(tasks);
                    },
                    child: const Icon(
                      Icons.add,
                      size: 50,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (Task task in tasks)
                      ToDoListItem(
                        task: task,
                        removeTask: removeTask,
                      )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child:
                        Text('Você possui ${tasks.length} tarefas pendentes'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: showDialogRemoveAllTask,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepOrange,
                    ),
                    child: const Text(
                      'Limpar Tudo',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void removeTask(Task task) {
    deletedTask = task;
    deletedTaskPos = tasks.indexOf(task);

    setState(() {
      tasks.remove(task);
    });
    taskRepository.saveTaskList(tasks);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa ${task.title} foi removida com sucesso!',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: Colors.amber,
          onPressed: () {
            setState(() {
              tasks.insert(deletedTaskPos!, deletedTask!);
            });
            taskRepository.saveTaskList(tasks);
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void showDialogRemoveAllTask() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar Tarefas'),
        content: const Text('Deseja remover todas as tarefas da sua lista?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(primary: Colors.red),
            child: const Text('Não, manter tarefas'),
          ),
          TextButton(
            onPressed: () {
              deleteAllTasks();
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(primary: Colors.green),
            child: const Text('Sim, limpar todas'),
          )
        ],
      ),
    );
  }

  void deleteAllTasks() {
    setState(() {
      tasks.clear();
    });
    taskRepository.saveTaskList(tasks);
  }
}
