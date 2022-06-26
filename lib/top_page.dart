import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TopPage extends StatelessWidget {
  TopPage({Key? key}) : super(key: key);

  var uuid = const Uuid();

  Future _addToFirestore() async {
    await FirebaseFirestore.instance.collection('users').add({
      'name': 'TEST USER',
      'userId': uuid.v4(),
    });
  }

  Future _updateToFireStore() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc('q4ZB9S9JmiyG8LdvbeJ1')
        .set({
      'name': 'TEST USER',
      'userId': uuid.v4(),
    });
  }

  Future _deleteFromFirestore() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc('q4ZB9S9JmiyG8LdvbeJ1')
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('トップページ'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                children: const <Widget>[
                  ElevatedButton(onPressed: null, child: Text('Create')),
                  ElevatedButton(onPressed: null, child: Text('Update')),
                  ElevatedButton(onPressed: null, child: Text('Delete')),
                ],
              ),
              Expanded(
                child: FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance.collection('users').get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                    if (snapshot.hasData) {
                      final List<DocumentSnapshot> documents =
                          snapshot.data!.docs;
                      return ListView(
                          children: documents
                              .map((doc) => Card(
                                    child: ListTile(
                                      title: Text(doc['name']),
                                      subtitle: Text(doc['userId']),
                                    ),
                                  ))
                              .toList());
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
