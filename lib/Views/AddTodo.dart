import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodo extends StatefulWidget {
  final Map? todo;

  const AddTodo({super.key, this.todo});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController discriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];

      titleController.text = title;
      discriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        centerTitle: true,
        title: Text(isEdit ? 'Edit' : 'Add Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            TextField(
              controller: discriptionController,
              maxLines: 8,
              minLines: 4,
              decoration: const InputDecoration(
                hintText: 'Discription',
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  isEdit ? updata() : submitData();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple),
                child: Text(
                  isEdit ? 'Update' : 'Submit',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> updata() async {
    final todo = widget.todo;
    final id = todo?['_id'];

    final title = titleController.text;
    final discription = discriptionController.text;
    final bodyOfPost = {
      "title": title,
      "description": discription,
      "is_completed": false
    };
    final response = await http.put(
        Uri.parse('https://api.nstack.in/v1/todos/$id'),
        body: jsonEncode(bodyOfPost),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      showMessage(message: 'Updation Successfully');
    } else {
      showMessage(message: 'Updation Failed');
    }
  }

  void submitData() async {
    final title = titleController.text;
    final discription = discriptionController.text;
    final bodyOfPost = {
      "title": title,
      "description": discription,
      "is_completed": false
    };
    final response = await http.post(
        Uri.parse('https://api.nstack.in/v1/todos'),
        body: jsonEncode(bodyOfPost),
        headers: {"Content-Type": "application/json"});
    if (response.statusCode == 201) {
      titleController.text = '';
      discriptionController.text = '';
      showMessage(message: 'Submit Successfully');
    } else {
      showMessage(message: 'Failed');
    }
  }

  void showMessage({required message}) {
    final snackBar = SnackBar(
        duration: const Duration(milliseconds: 1000), content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
