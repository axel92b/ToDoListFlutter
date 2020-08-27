import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list/models/todo_element.dart';

class User {
  List<ToDoElement> todoList = List<ToDoElement>();

  DocumentReference reference;

  User({this.reference, this.todoList});


}