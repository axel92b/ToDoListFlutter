import 'package:cloud_firestore/cloud_firestore.dart';

class ToDoElement {
  String text;
  bool checked;
  DocumentReference reference;

  ToDoElement(this.text, {this.reference, this.checked});

}