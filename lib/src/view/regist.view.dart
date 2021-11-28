// ignore_for_file: use_key_in_widget_constructors
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RegistView extends StatefulWidget {
  const RegistView({Key? key}) : super(key: key);

  @override
  _RegistViewState createState() => _RegistViewState();
}

class _RegistViewState extends State<RegistView> {
  final picker = ImagePicker();
  XFile? image;
  String? image_name;
  String? image_url;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _writerController = TextEditingController();
  TextEditingController _desController = TextEditingController();
  final _nameFormKey = GlobalKey<FormState>();
  final _writerFormKey = GlobalKey<FormState>();
  final _desFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width - 10,
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
                  child: (image_url == null)
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              width: 1,
                              color: const Color(0xffecb142),
                            ),
                          ),
                          child: IconButton(
                            onPressed: () async {
                              image = await picker.pickImage(
                                  source: ImageSource.gallery);
                              Uint8List bytes = await image!.readAsBytes();
                              image_name = "${DateTime.now()}.png";
                              Reference ref = FirebaseStorage.instance
                                  .ref()
                                  .child(image_name!);
                              UploadTask uploadTask = ref.putData(bytes,
                                  SettableMetadata(contentType: 'image/png'));
                              TaskSnapshot taskSnapshot = await uploadTask
                                  .whenComplete(() => print('done'))
                                  .catchError((error) => print("error...:("));
                              image_url =
                                  await taskSnapshot.ref.getDownloadURL();
                              setState(() {});
                            },
                            icon: Icon(Icons.camera_alt_outlined),
                          ))
                      : Image.network(image_url!, fit: BoxFit.fitHeight),
                ),
                const SizedBox(height: 10),
                Form(
                  key: _nameFormKey,
                  child: TextFormField(
                    controller: _nameController,
                    validator: (value) => emptyValidator(value),
                    style: const TextStyle(fontSize: 20),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.backpack,
                        color: Color(0xffecb142),
                      ),
                      hintText: "애장품의 이름",
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
                const SizedBox(height: 10),
                Form(
                  key: _writerFormKey,
                  child: TextFormField(
                    controller: _writerController,
                    validator: (value) => emptyValidator(value),
                    style: const TextStyle(fontSize: 20),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: Color(0xffecb142),
                      ),
                      hintText: "안테나의 이름",
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
                const SizedBox(height: 10),
                Form(
                  key: _desFormKey,
                  child: TextFormField(
                    controller: _desController,
                    validator: (value) => emptyValidator(value),
                    maxLines: 5,
                    maxLength: 200,
                    style: const TextStyle(fontSize: 20),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.description,
                        color: Color(0xffecb142),
                      ),
                      hintText: "안테나의 애장품을 설명해주세요!",
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
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _nameFormKey.currentState!.validate();
                    _writerFormKey.currentState!.validate();
                    _desFormKey.currentState!.validate();
                    if (_nameFormKey.currentState!.validate() &&
                        _writerFormKey.currentState!.validate() &&
                        _desFormKey.currentState!.validate() &&
                        image_url != null) {
                      FirebaseFirestore.instance.collection('items').add({
                        "name": _nameController.text,
                        "writer": _writerController.text,
                        "description": _desController.text,
                        "image": image_name,
                      });
                      Get.back();
                    }
                  },
                  child: const Text(
                    "애장품 등록하기!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
        ),
      ),
    );
  }
}

emptyValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "꼭 써주세요!!";
  }

  return null;
}
