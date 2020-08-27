import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/main.dart';
import 'package:todo_list/models/todo_element.dart';

class ListPage extends StatefulWidget {
  @override
  State createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  var id = FirebaseAuth.instance.currentUser.uid;
  StreamSubscription subscription;
  var listOfTodos = List<ToDoElement>();

  @override
  void initState() {
    super.initState();
    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(id)
    //     .collection('lists')
    //     .doc('first list')
    //     .collection('elements')
    //     .get()
    //     .then((value) {
    //   var list = value.docs.map((DocumentSnapshot document) {
    //     return ToDoElement(document.data()['text'].toString(),
    //         checked: false, reference: document.reference);
    //   }).toList();
    //   setState(() {
    //     listOfTodos = list;
    //   });
    // });

    subscription = FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('lists')
        .doc('first list')
        .collection('elements')
        .snapshots()
        .listen((event) {
      var list = event.docs.map((DocumentSnapshot document) {
        return ToDoElement(document.data()['text'].toString(),
            checked: false, reference: document.reference);
      }).toList();
      setState(() {
        listOfTodos = list;
      });
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //var id = FirebaseAuth.instance.currentUser.uid;
    var reference = FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('lists')
        .doc('first list')
        .collection('elements');

    return Scaffold(
      appBar: AppBar(
        title: Text('Logged in'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.whatshot,
                color: Colors.white,
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (Route<dynamic> route) => route is MyApp);
              })
        ],
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: reference.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return new ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                return ListRow(document.data()['text'], false);
              }).toList(),
            );
          },
        ),
        // child: ListView.builder(
        //   padding: const EdgeInsets.all(16),
        //   itemCount: listOfTodos.length * 2,
        //   itemBuilder: (BuildContext _context, int i) {
        //     if (i.isOdd) {
        //       return Divider();
        //     }
        //
        //     final int index = i ~/ 2;
        //
        //     return ListRow(listOfTodos[index].text,listOfTodos[index].checked);
        //     // old variant
        //     // return ListTile(
        //     //   title: Text(listOfTodos[index].text,
        //     //       style: _getStyle(listOfTodos[index].checked)),
        //     //   leading: Checkbox(
        //     //     value: listOfTodos[index].checked,
        //     //     onChanged: (value) {
        //     //       setState(() {
        //     //         listOfTodos[index].checked = value;
        //     //       });
        //     //     },
        //     //   ),
        //     // );
        //   },
        // ),
      ),
    );
  }

  TextStyle _getStyle(bool checked) {
    if (checked) {
      return TextStyle(decoration: TextDecoration.lineThrough, fontSize: 18);
    }
    return TextStyle(fontSize: 18);
  }
}

class ListRow extends StatefulWidget {
  String text;
  bool checked;

  ListRow(this.text, this.checked);

  @override
  State createState() => _listRowState(text, checked);
}

class _listRowState extends State<ListRow> {
  String text;

  bool checked;


  _listRowState(this.text, this.checked);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(text,
          style: _getStyle(checked)),
      leading: Checkbox(
        value: checked,
        onChanged: (value) {
          setState(() {
            checked = value;
          });
        },
      ),
    );
  }

  TextStyle _getStyle(bool checked) {
    if (checked) {
      return TextStyle(decoration: TextDecoration.lineThrough, fontSize: 18);
    }
    return TextStyle(fontSize: 18);
  }
}