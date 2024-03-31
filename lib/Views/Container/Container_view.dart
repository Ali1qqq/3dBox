import 'dart:math';

import 'package:ba3mall/Views/home.dart';
import 'package:flutter/material.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';

import '../data.dart';

class CustomizableContainerEdit extends StatefulWidget {
  const CustomizableContainerEdit({super.key});

  @override
  State<CustomizableContainerEdit> createState() =>
      _CustomizableContainerEditState();
}

class _CustomizableContainerEditState extends State<CustomizableContainerEdit>
    with TickerProviderStateMixin {
  double rz = 0.0;

  List<ContainerData> containerDataList = [
    ContainerData(
      offSet: 1,
      depth: 50,
      width: 100,
      height: 100,
      color: Colors.greenAccent,
      rTopRight: 0,
      rTopLeft: 0,
      rBottomRight: 0,
      rBottomLeft: 0,
      angle: 0,
      pLeft: (Get.width / 2) - 50,
      pTop: (Get.height / 2) - 50,
    ),
  ]; // Initial container data
  int selectedIndex = 0;
  PageController scrollController = PageController(
    initialPage: 0,
  );
  late AnimationController animationController =
      BottomSheet.createAnimationController(this);

  bool threeD = false;

  bool bottom = false;
  bool revers = false;

  TextEditingController depthController = TextEditingController();
  TextEditingController offSetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onScaleUpdate: (ScaleUpdateDetails details) {
          if (!threeD) {
            // Panning
            if (details.rotation == 0.0) {
              //Moving in Horizontal
              if (containerDataList[selectedIndex].pTop != null) {
                {
                  containerDataList[selectedIndex].pTop =
                      containerDataList[selectedIndex].pTop! +
                          details.focalPointDelta.dy;
                }
              } else {
                containerDataList[selectedIndex].pTop =
                    details.focalPointDelta.dy;
              }
              setState(() {});
              //Moving in Vertical
              if (containerDataList[selectedIndex].pLeft != null) {
                {
                  containerDataList[selectedIndex].pLeft =
                      containerDataList[selectedIndex].pLeft! +
                          details.focalPointDelta.dx;
                }
              } else {
                containerDataList[selectedIndex].pLeft =
                    details.focalPointDelta.dx;
              }

              setState(() {});
            }
            // Scaling
            // Update scale based on focal point and scale factor
            // Your scaling logic here
            else {
              //bigger
              if (details.scale > 1) {
                containerDataList[selectedIndex].height += details.scale * 2;
                containerDataList[selectedIndex].width += details.scale * 2;
              }
              //smaller
              else {
                containerDataList[selectedIndex].height -= details.scale * 5;
                containerDataList[selectedIndex].width -= details.scale * 5;
                if (containerDataList[selectedIndex].height < 10) {
                  containerDataList[selectedIndex].height = 10;
                }
                if (containerDataList[selectedIndex].width < 10) {
                  containerDataList[selectedIndex].width = 10;
                }
              }
              setState(() {});
            }
          } else {
            rz += details.focalPointDelta.dx * 0.01;

            setState(() {
              rz %= pi * 2;
            });

            if (rz > 1.0 && rz < 5.0) {
              revers = true;
            } else {
              revers = false;
            }
            setState(() {});
          }
        },
        child: Container(
          clipBehavior: Clip.none,
          height: Get.height,
          width: Get.width,
          color: Colors.white,
          child: Stack(
            //main Screen
            children: [
              // map
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(threeD ? -1.150 : 0)
                  ..forward
                  ..rotateZ(rz),
                child: Container(
                  color: threeD ? Colors.grey : Colors.transparent,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: revers
                        ? containerDataList
                            .map((data) {
                              return AnimatedPositioned(
                                duration:
                                    threeD ? Duration.zero : Durations.short2,
                                left: data.pLeft == 0 ? null : data.pLeft,
                                top: data.pTop == 0 ? null : data.pTop,
                                child: GestureDetector(
                                  //select Shep
                                  onTap: () {
                                    selectedIndex =
                                        containerDataList.indexOf(data);
                                    depthController.text =
                                        containerDataList[selectedIndex]
                                            .depth
                                            .toString();
                                    offSetController.text =
                                        containerDataList[selectedIndex]
                                            .offSet
                                            .toString();
                                    _displayBottomSheet(context);

                                    setState(() {});
                                  },
                                  onLongPress: () {},
                                  child: Stack(
                                    children: [
                                      //back
                                      if (data.offSet <= 0 && threeD)
                                        Transform(
                                          transform: Matrix4.identity()
                                            ..translate(-data.height / 2,
                                                -data.width / 2, 0),
                                          child: AnimatedContainer(
                                            duration: threeD
                                                ? Duration.zero
                                                : Durations.short2,
                                            width: data.width * 2,
                                            height: data.height * 2,
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(
                                                      data.rTopLeft),
                                                  topRight: Radius.circular(
                                                      data.rTopRight),
                                                  bottomRight: Radius.circular(
                                                      data.rBottomRight),
                                                  bottomLeft: Radius.circular(
                                                      data.rBottomLeft),
                                                )),
                                          ),
                                        ),
                                      //wall
                                      ...List.generate(
                                          (data.depth + data.offSet).ceil(),
                                          (i) {
                                        double darkenAmount = 0.3;
                                        Color darkerColor = Color.fromARGB(
                                          data.color.alpha,
                                          (data.color.red * (1 - darkenAmount))
                                              .round(),
                                          (data.color.green *
                                                  (1 - darkenAmount))
                                              .round(),
                                          (data.color.blue * (1 - darkenAmount))
                                              .round(),
                                        );
                                        return Transform(
                                          //back
                                          transform: Matrix4.identity()
                                            ..translate(0.0, 0.0, -i * 1),
                                          child: AnimatedContainer(
                                            duration: threeD
                                                ? Duration.zero
                                                : Durations.short2,
                                            width: data.width,
                                            height: data.height,
                                            decoration: BoxDecoration(
                                                color: i < data.offSet
                                                    ? Colors.transparent
                                                    : darkerColor,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(
                                                      data.rTopLeft),
                                                  topRight: Radius.circular(
                                                      data.rTopRight),
                                                  bottomRight: Radius.circular(
                                                      data.rBottomRight),
                                                  bottomLeft: Radius.circular(
                                                      data.rBottomLeft),
                                                )),
                                          ),
                                        );
                                      }),
                                      //front
                                      Transform(
                                        transform: Matrix4.identity()
                                          ..translate(
                                              0.0,
                                              0.0,
                                              -(data.depth + data.offSet) *
                                                  1.0),
                                        child: AnimatedContainer(
                                          duration: threeD
                                              ? Duration.zero
                                              : Durations.short2,
                                          width: data.width,
                                          height: data.height,
                                          decoration: BoxDecoration(
                                              color: data.color,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                    data.rTopLeft),
                                                topRight: Radius.circular(
                                                    data.rTopRight),
                                                bottomRight: Radius.circular(
                                                    data.rBottomRight),
                                                bottomLeft: Radius.circular(
                                                    data.rBottomLeft),
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })
                            .toList()
                            .reversed
                            .toList()
                        : containerDataList.map((data) {
                            return AnimatedPositioned(
                              duration:
                                  threeD ? Duration.zero : Durations.short2,
                              left: data.pLeft == 0 ? null : data.pLeft,
                              top: data.pTop == 0 ? null : data.pTop,
                              child: GestureDetector(
                                //select Shep

                                onTap: () {
                                  selectedIndex =
                                      containerDataList.indexOf(data);
                                  depthController.text =
                                      containerDataList[selectedIndex]
                                          .depth
                                          .toString();
                                  offSetController.text =
                                      containerDataList[selectedIndex]
                                          .offSet
                                          .toString();

                                  setState(() {});
                                },
                                onLongPress: () {
                                  selectedIndex =
                                      containerDataList.indexOf(data);
                                  depthController.text =
                                      containerDataList[selectedIndex]
                                          .depth
                                          .toString();
                                  offSetController.text =
                                      containerDataList[selectedIndex]
                                          .offSet
                                          .toString();

                                  setState(() {});
                                  _displayBottomSheet(context);
                                },
                                child: Stack(
                                  children: [
                                    //back
                                    if (data.offSet <= 0 && threeD)
                                      Transform(
                                        transform: Matrix4.identity()
                                          ..translate(-data.height / 2,
                                              -data.width / 2, 0),
                                        child: AnimatedContainer(
                                          duration: threeD
                                              ? Duration.zero
                                              : Durations.short2,
                                          width: data.width * 2,
                                          height: data.height * 2,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                    data.rTopLeft),
                                                topRight: Radius.circular(
                                                    data.rTopRight),
                                                bottomRight: Radius.circular(
                                                    data.rBottomRight),
                                                bottomLeft: Radius.circular(
                                                    data.rBottomLeft),
                                              )),
                                        ),
                                      ),
                                    //wall
                                    ...List.generate(
                                        (data.depth + data.offSet).ceil(), (i) {
                                      double darkenAmount = 0.3;
                                      Color darkerColor = Color.fromARGB(
                                        data.color.alpha,
                                        (data.color.red * (1 - darkenAmount))
                                            .round(),
                                        (data.color.green * (1 - darkenAmount))
                                            .round(),
                                        (data.color.blue * (1 - darkenAmount))
                                            .round(),
                                      );
                                      return Transform(
                                        //back
                                        transform: Matrix4.identity()
                                          ..translate(0.0, 0.0, -i * 1),
                                        child: AnimatedContainer(
                                          duration: threeD
                                              ? Duration.zero
                                              : Durations.short2,
                                          width: data.width,
                                          height: data.height,
                                          decoration: BoxDecoration(
                                              color: i < data.offSet
                                                  ? Colors.transparent
                                                  : darkerColor,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                    data.rTopLeft),
                                                topRight: Radius.circular(
                                                    data.rTopRight),
                                                bottomRight: Radius.circular(
                                                    data.rBottomRight),
                                                bottomLeft: Radius.circular(
                                                    data.rBottomLeft),
                                              )),
                                        ),
                                      );
                                    }),
                                    //front
                                    Transform(
                                      transform: Matrix4.identity()
                                        ..translate(0.0, 0.0,
                                            -(data.depth + data.offSet) * 1.0),
                                      child: AnimatedContainer(
                                        duration: threeD
                                            ? Duration.zero
                                            : Durations.short2,
                                        width: data.width,
                                        height: data.height,
                                        decoration: BoxDecoration(
                                            color: data.color,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  data.rTopLeft),
                                              topRight: Radius.circular(
                                                  data.rTopRight),
                                              bottomRight: Radius.circular(
                                                  data.rBottomRight),
                                              bottomLeft: Radius.circular(
                                                  data.rBottomLeft),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                  ),
                ),
              ),
              //3d container
              Align(
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onTap: () {
                    threeD = !threeD;

                    containerDataList
                        .sort((a, b) => a.pTop!.compareTo(b.pTop!));

                    rz = 0;
                    setState(() {});
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 60),
                    height: 30,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: threeD
                            ? Colors.green.withOpacity(0.5)
                            : Colors.green.withOpacity(0.1)),
                    child: const Center(
                        child: Text(
                      "3D",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 150,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                containerDataList.add(
                  ContainerData(
                    offSet: 1,
                    depth: 50,
                    width: 100,
                    height: 100,
                    color: Colors.greenAccent,
                    rTopRight: 0,
                    rTopLeft: 0,
                    rBottomRight: 0,
                    rBottomLeft: 0,
                    angle: 0,
                    pLeft: (Get.width / 2) - 50,
                    pTop: (Get.height / 2) - 50,
                  ),
                );
                setState(() {
                  selectedIndex = containerDataList.length - 1;
                  // scrollController.animateToPage(
                  //     containerDataList.length - 1,
                  //     duration: Durations.extralong2,
                  //     curve: Curves.linear);
                });
              },
              child: Container(
                height: 50,
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 50),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blueAccent),
                child: const Center(
                    child: Text(
                  "Add Shape",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700),
                )),
              ),
            ),
            GestureDetector(
              onTap: () {
                data.add(containerDataList);
                setState(() {});
                Get.offAll(const Home());
              },
              child: Container(
                height: 50,
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 50),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.greenAccent),
                child: const Center(
                    child: Text(
                  "Save Shape",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _displayBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isDismissible: true,
      showDragHandle: true,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      barrierColor: Colors.transparent,
      builder: (context) {
        return Container(
          clipBehavior: Clip.none,
          color: Colors.white,
          height: Get.height * 0.5,
          child: PageView.builder(
            controller: scrollController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: containerDataList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListView(
                padding: const EdgeInsets.only(bottom: 25),
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                if (selectedIndex > 0) {
                                  selectedIndex--;
                                  scrollController.animateToPage(selectedIndex,
                                      duration: threeD
                                          ? Duration.zero
                                          : Durations.extralong1,
                                      curve: Curves.ease);
                                  setState(() {});
                                }
                              },
                              icon: const Icon(Icons.arrow_back_ios)),
                          const Spacer(),
                          Text(selectedIndex.toString()),
                          const Spacer(),
                          IconButton(
                              onPressed: () {
                                if (selectedIndex <
                                    containerDataList.length - 1) {
                                  selectedIndex++;

                                  scrollController.animateToPage(selectedIndex,
                                      duration: threeD
                                          ? Duration.zero
                                          : Durations.extralong1,
                                      curve: Curves.ease);
                                  setState(() {});
                                }
                              },
                              icon: const Icon(Icons.arrow_forward_ios)),
                        ],
                      ),
                    ),
                  ),
                  ColorPicker(
                    pickerColor: containerDataList[selectedIndex].color,
                    colorPickerWidth: 150,
                    displayThumbColor: false,
                    colorHistory: const [Colors.black],
                    enableAlpha: true,
                    hexInputBar: true,
                    portraitOnly: false,
                    labelTypes: const [],
                    paletteType: PaletteType.hueWheel,
                    onColorChanged: (Color value) {
                      setState(() {
                        containerDataList[selectedIndex].color = value;
                      });
                    },
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text("Top Left Angle"),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            containerDataList[selectedIndex].rTopLeft - 1 >= 0
                                ? setState(() {
                                    containerDataList[selectedIndex].rTopLeft--;
                                  })
                                : null;
                          },
                          icon: const Icon(Icons.remove)),
                      IconButton(
                          onPressed: () {
                            containerDataList[selectedIndex].rTopLeft + 1 <= 100
                                ? setState(() {
                                    containerDataList[selectedIndex].rTopLeft++;
                                  })
                                : null;
                          },
                          icon: const Icon(Icons.add)),
                    ],
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text("Top Right Angle"),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            containerDataList[selectedIndex].rTopRight - 1 >= 0
                                ? setState(() {
                                    containerDataList[selectedIndex]
                                        .rTopRight--;
                                  })
                                : null;
                          },
                          icon: const Icon(Icons.remove)),
                      IconButton(
                          onPressed: () {
                            containerDataList[selectedIndex].rTopRight + 1 <=
                                    100
                                ? setState(() {
                                    containerDataList[selectedIndex]
                                        .rTopRight++;
                                  })
                                : null;
                          },
                          icon: const Icon(Icons.add)),
                    ],
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text("Bottom Left Angle"),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          containerDataList[selectedIndex].rBottomLeft - 1 >= 0
                              ? setState(() {
                                  containerDataList[selectedIndex]
                                      .rBottomLeft--;
                                })
                              : null;
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      IconButton(
                          onPressed: () {
                            containerDataList[selectedIndex].rBottomLeft + 1 <=
                                    100
                                ? setState(() {
                                    containerDataList[selectedIndex]
                                        .rBottomLeft++;
                                  })
                                : null;
                          },
                          icon: const Icon(Icons.add)),
                    ],
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text("Bottom Right Angle"),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            containerDataList[selectedIndex].rBottomRight - 1 >=
                                    0
                                ? setState(() {
                                    containerDataList[selectedIndex]
                                        .rBottomRight--;
                                  })
                                : null;
                          },
                          icon: const Icon(Icons.remove)),
                      IconButton(
                          onPressed: () {
                            containerDataList[selectedIndex].rBottomRight + 1 <=
                                    100
                                ? setState(() {
                                    containerDataList[selectedIndex]
                                        .rBottomRight++;
                                  })
                                : null;
                          },
                          icon: const Icon(Icons.add)),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      const Text("Depth"),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextField(
                          controller: depthController,
                          onSubmitted: (value) {
                            containerDataList[selectedIndex].depth =
                                int.parse(value);
                          },
                          decoration:
                              const InputDecoration(hintText: "Default 10"),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      const Text("OffSet"),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextField(
                          controller: offSetController,
                          decoration:
                              const InputDecoration(hintText: "Default 10"),
                          onSubmitted: (value) {
                            containerDataList[selectedIndex].offSet =
                                int.parse(value);
                            setState(() {});
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      containerDataList.removeAt(selectedIndex);
                      Get.back();
                      setState(() {});
                    },
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 50),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.redAccent),
                      child: const Center(
                          child: Text(
                        "Remove Shape",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700),
                      )),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class ContainerData {
  double width, rTopLeft, rTopRight, rBottomRight, rBottomLeft, angle;
  double height;
  double? pLeft;
  double? pTop;
  double? pRight;
  double? pBottom;
  int depth, offSet;
  Color color;

  ContainerData({
    required this.width,
    required this.height,
    required this.color,
    required this.depth,
    required this.offSet,
    this.pLeft,
    this.pTop,
    this.pRight,
    this.pBottom,
    required this.rBottomLeft,
    required this.rBottomRight,
    required this.rTopLeft,
    required this.rTopRight,
    required this.angle,
  });
}
