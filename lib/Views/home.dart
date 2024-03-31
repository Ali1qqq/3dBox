import 'package:ba3mall/Views/Container/CustomizableContainerView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Container/Container_view.dart';
import 'data.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shape's"),
      ),
      body: ListView.separated(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              Get.to(CustomizableContainerView(containerDataList: data[index]));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(15)
              ),
              child: Center(
                child: Text("Shape ${index+1}"),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 20,
          );
        },
        itemCount: data.length,
      ),
      bottomSheet: GestureDetector(
        onTap: () {
Get.to(const CustomizableContainerEdit());
        },
        child: Container(
          height: 50,
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.blueAccent),
          child: const Center(
              child: Text(
                "New Shape",
                style: TextStyle(
                    color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
              )),
        ),
      ),
    );

  }
}
