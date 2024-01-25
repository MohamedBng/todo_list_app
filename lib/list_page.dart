import 'package:flutter/material.dart';

class Task {
  String title;
  bool isDone;
  DateTime dateAdded;

  Task({required this.title, this.isDone = false, required this.dateAdded});

  Map<String, dynamic> toJson() => {
        'title': title,
        'isDone': isDone,
        'dateAdded': dateAdded.toIso8601String(),
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        title: json['title'],
        isDone: json['isDone'],
        dateAdded: DateTime.parse(json['dateAdded']),
      );
}

class ShowListPage extends StatefulWidget {
  final List<Task> initialTasks;

  const ShowListPage({Key? key, required this.initialTasks}) : super(key: key);

  @override
  _ShowListPageState createState() => _ShowListPageState();
}

class _ShowListPageState extends State<ShowListPage> {
  final TextEditingController _controller = TextEditingController();
  late List<Task> tasks;

  @override
  void initState() {
    super.initState();
    tasks = widget.initialTasks;
  }

  void sortTasks() {
    tasks.sort((a, b) {
      if (!a.isDone && b.isDone) {
        return -1;
      } else if (a.isDone && !b.isDone) {
        return 1;
      } else {
        return b.dateAdded.compareTo(a.dateAdded);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task List')),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 250,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Task',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                tasks.add(Task(title: _controller.text, dateAdded: DateTime.now()));
                _controller.clear();
                sortTasks();
              });
            },
            child: const Text('Add'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                var task = tasks[index];
                return CheckboxListTile(
                  value: task.isDone,
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  onChanged: (bool? value) {
                    setState(() {
                      task.isDone = value!;
                      sortTasks();
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
