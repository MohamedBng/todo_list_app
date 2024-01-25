import 'package:flutter/material.dart';
import 'create_list_page.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Todo List')),
        body: Center(
          child: CreateListPage(),
        ),
      ),
    )
  );
}
