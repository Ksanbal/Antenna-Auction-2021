import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteView extends StatelessWidget {
  late Map<String, dynamic> _data;
  TextEditingController _pwController = TextEditingController();
  final _pwFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _data = Get.arguments as Map<String, dynamic>;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height / 4,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: Get.back,
                icon: Icon(
                  Icons.close,
                  color: Color(0xffecb142),
                ),
                iconSize: 30,
              ),
            ),
            Form(
              key: _pwFormKey,
              child: TextFormField(
                controller: _pwController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "비밀번호를 입력해주세요.";
                  }

                  if (value != _data['password']) {
                    return "비밀번호가 틀립니다.";
                  }

                  return null;
                },
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.vpn_key,
                    color: Color(0xffecb142),
                  ),
                  hintText: "비밀번호",
                  hintStyle: TextStyle(fontSize: 20),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xffecb142),
                      width: 2,
                    ),
                  ),
                ),
                cursorColor: const Color(0xffecb142),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                if (_pwFormKey.currentState!.validate()) {
                  FirebaseFirestore.instance
                      .collection('items')
                      .doc(_data['id'])
                      .delete();

                  for (dynamic image in _data['image']) {
                    FirebaseStorage.instance.ref().child(image).delete();
                  }

                  Get.back();
                  Get.back();
                }
              },
              icon: Icon(
                Icons.delete_outline,
                color: Colors.white,
              ),
              label: const Text(
                "삭제하기",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: const Color(0xffecb142),
                fixedSize: const Size(200, 40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
