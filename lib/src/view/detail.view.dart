// ignore_for_file: use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailView extends StatelessWidget {
  firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  late Map<String, dynamic> _data;
  // late Stream<DocumentSnapshot> _item;

  @override
  Widget build(BuildContext context) {
    _data = Get.arguments as Map<String, dynamic>;
    final ref = _storage.ref().child(_data['image']);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 1 / 1,
                  child: FutureBuilder(
                    future: ref.getDownloadURL(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData == false) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Image.network(
                          snapshot.data,
                          fit: BoxFit.fitHeight,
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _data['name'],
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  "${_data['writer']} 안테나",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _data['description'],
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
