import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company'),
      ),
      body: const NoteList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("add"),
                      const Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'Name: ',
                          textAlign: TextAlign.start,
                        ),
                      ),
                      TextField(
                        controller: _namaController,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          'alamat:',
                          textAlign: TextAlign.start,
                        ),
                      ),
                      TextField(
                        controller: _alamatController,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          'balance:',
                          textAlign: TextAlign.start,
                        ),
                      ),
                      TextField(
                        controller: _balanceController,
                      )
                    ],
                  ),
                  actions: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("cancel")),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Map<String, dynamic> notes = {};
                          notes['nama'] = _namaController.text;
                          notes['alamat'] = _alamatController.text;
                          notes['balance'] = _balanceController.text;

                          FirebaseFirestore.instance
                              .collection('notes')
                              .add(notes)
                              .whenComplete(() {
                            _namaController.clear();
                            _alamatController.clear();
                            _balanceController.clear();
                            Navigator.of(context).pop();
                          });
                        },
                        child: const Text("Save"))
                  ],
                );
              });
        },
        tooltip: 'Add Notes',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NoteList extends StatelessWidget {
  const NoteList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('company').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            return ListView(
              padding: const EdgeInsets.only(bottom: 80),
              children: snapshot.data!.docs.map((document) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  child: Card(
                      child: ListTile(
                    onTap: () {},
                    title: Text(document['nama']),
                    subtitle: Text(document['alamat']),
                    trailing: InkWell(
                      onTap: () {
                        FirebaseFirestore.instance
                            .collection('notes')
                            .doc(document.id)
                            .delete();
                      },
                      child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Icon(Icons.delete)),
                    ),
                  )),
                );
              }).toList(),
            );
        }
      },
    );
  }
}
