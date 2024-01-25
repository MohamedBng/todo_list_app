import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'list_page.dart';

class TodoList {
  String title;
  DateTime dateAdded;
  List<Task> tasks;

  TodoList(
      {required this.title,
      required this.dateAdded,
      this.tasks = const []});

  Map<String, dynamic> toJson() => {
        'title': title,
        'dateAdded': dateAdded.toIso8601String(),
        'tasks': tasks.map((task) => task.toJson()).toList(),
      };

  factory TodoList.fromJson(Map<String, dynamic> json) => TodoList(
    title: json['title'],
    dateAdded: DateTime.parse(json['dateAdded']),
    tasks: json['tasks'] != null
      ? (json['tasks'] as List).map((taskJson) => Task.fromJson(taskJson)).toList()
      : [],
  );
}

class CreateListPage extends StatefulWidget {
  const CreateListPage({Key? key}) : super(key: key);

  @override
  _CreateListPageState createState() => _CreateListPageState();
}

class _CreateListPageState extends State<CreateListPage> {
  final TextEditingController _controller = TextEditingController();
  List<TodoList> todolists = [];

  @override
  void initState() {
    super.initState();
    _loadTodoLists();
  }

  void _loadTodoLists() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todoListsStr = prefs.getString('todoLists');
    if (todoListsStr != null) {
      setState(() {
        todolists = (jsonDecode(todoListsStr) as List)
            .map((e) => TodoList.fromJson(e))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 250,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Todo',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              setState(() {
                todolists.add(TodoList(
                    title: _controller.text, dateAdded: DateTime.now()));
                prefs.setString('todoLists',
                    jsonEncode(todolists.map((e) => e.toJson()).toList()));
                _controller.clear();
              });
            },
            child: Text('Add'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todolists.length,
              itemBuilder: (context, index) {
                var todolist = todolists[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ShowListPage(initialTasks: todolist.tasks),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(todolist.title),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TextFieldExampleApp extends StatelessWidget {
  const TextFieldExampleApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Todo List')),
        body: const Center(
          child: CreateListPage(),
        ),
      ),
    );
  }
}
