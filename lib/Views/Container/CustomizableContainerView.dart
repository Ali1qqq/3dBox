import 'dart:math';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'Container_view.dart';

class CustomizableContainerView extends StatefulWidget {
  const CustomizableContainerView({super.key, required this.containerDataList});

  @override
  State<CustomizableContainerView> createState() =>
      _CustomizableContainerViewState();
  final List<ContainerData> containerDataList;
}

class _CustomizableContainerViewState extends State<CustomizableContainerView>
    with TickerProviderStateMixin {
  double rz = 0.0;

  bool threeD = false;

  bool revers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onScaleUpdate: (ScaleUpdateDetails details) {
          {
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
                        ? widget.containerDataList
                            .map((data) {
                              return AnimatedPositioned(
                                duration:
                                    threeD ? Duration.zero : Durations.short2,
                                left: data.pLeft == 0 ? null : data.pLeft,
                                top: data.pTop == 0 ? null : data.pTop,
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
                              );
                            })
                            .toList()
                            .reversed
                            .toList()
                        : widget.containerDataList.map((data) {
                            return AnimatedPositioned(
                              duration:
                                  threeD ? Duration.zero : Durations.short2,
                              left: data.pLeft == 0 ? null : data.pLeft,
                              top: data.pTop == 0 ? null : data.pTop,
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
                                            topLeft:
                                                Radius.circular(data.rTopLeft),
                                            topRight:
                                                Radius.circular(data.rTopRight),
                                            bottomRight: Radius.circular(
                                                data.rBottomRight),
                                            bottomLeft: Radius.circular(
                                                data.rBottomLeft),
                                          )),
                                    ),
                                  ),
                                ],
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

                    widget.containerDataList
                        .sort((a, b) {
                        return  a.pTop!.compareTo(b.pTop!);
                    });

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
    );
  }
}
