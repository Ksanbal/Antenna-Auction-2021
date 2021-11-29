// ignore_for_file: use_key_in_widget_constructors

import 'package:antenna_auction_2021/src/view/delete.view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailView extends StatelessWidget {
  firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  late Map<String, dynamic> _data;
  final PageController _pageController = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    _data = Get.arguments as Map<String, dynamic>;
    // final ref = _storage.ref().child(_data['image']);
    List<dynamic> image_list = _data['image'];

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
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: Get.back,
                    icon: const Icon(
                      Icons.close,
                      color: Color(0xffecb142),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PageView(
                          controller: _pageController,
                          children: image_list.map(
                            (e) {
                              final ref = _storage.ref().child(e);
                              return FutureBuilder(
                                future: ref.getDownloadURL(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData == false) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    return Image.network(
                                      snapshot.data,
                                      fit: BoxFit.cover,
                                    );
                                  }
                                },
                              );
                            },
                          ).toList()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            color: Color(0xffecb142),
                            size: 20,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xffecb142),
                            size: 20,
                          ),
                        ],
                      ),
                    ],
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
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () => Get.dialog(
                      DeleteView(),
                      arguments: _data,
                    ),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Color(0xffecb142),
                    ),
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
