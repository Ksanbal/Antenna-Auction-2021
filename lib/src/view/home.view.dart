import 'package:antenna_auction_2021/main.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("안테나의 애장품"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text("추가하기"),
        icon: Icon(Icons.add),
      ),
    );
  }
}
