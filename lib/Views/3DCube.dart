import 'dart:math';

import 'package:flutter/material.dart';

class ThreeDCube extends StatefulWidget {
  const ThreeDCube({super.key});

  @override
  State<ThreeDCube> createState() => _ThreeDCubeState();
}

class _ThreeDCubeState extends State<ThreeDCube> {
  double _rx = 0.0, _ry = 0.0, _rz = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        _rx += details.delta.dx * 0.01;
        _ry += details.delta.dy * 0.01;
        setState(() {
          _rx %= pi * 2;
          _ry %= pi * 2;
        });
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(_rx)
                ..rotateY(_ry)
                ..rotateZ(_rz),
              child: const Center(child: Cube()),
            ),
            const SizedBox(
              height: 32,
            ),
            Slider(
                value: _ry,
                min: pi * -2,
                max: pi * 2,
                onChanged: (value) => setState(() => _ry = value)),
            Slider(
                value: _rx,
                min: pi * -2,
                max: pi * 2,
                onChanged: (value) => setState(() => _rx = value)),
            Slider(
                value: _rz,
                min: pi * -2,
                max: pi * 2,
                onChanged: (value) => setState(() => _rz = value)),
          ],
        ),
      ),
    );
  }
}

class Cube extends StatelessWidget {
  const Cube({super.key});

  @override
  Widget build(BuildContext context) {
    double height = 100, width = 200;

    return Stack(
      children: [
        Transform(
          //top
          transform: Matrix4.identity()
            ..translate(0.0,height>width? -width / 2.0: (height-width )/ 2.0, 0.0)
            ..rotateX(-pi / 2),
          alignment: Alignment.center,
          child: Container(
            height: width,
            width: width,
            color: Colors.black,
          ),
        ),
        Transform(
          //bottom
          transform: Matrix4.identity()
            ..translate(0.0,height>width? width / 2.0: height-width / 2.0, 0.0)
            ..rotateX(pi / 2),
          alignment: Alignment.center,
          child: Container(
            height: width,
            width: width,
            color: Colors.black,
          ),
        ),
        Transform(
          //back
          transform: Matrix4.identity()..translate(0.0, 0.0, width / 2),
          child: Container(
            color: Colors.black,
            height: height,
            width: width,
          ),
        ),
        Transform(
          //left
          transform: Matrix4.identity()
            ..translate(-width / 2.0, 0.0, 0.0)
            ..rotateY(-pi / 2),
          alignment: Alignment.center,
          child: Container(
            height: height,
            width: width,
            color: Colors.black,
          ),
        ),
        Transform(
          //right
          transform: Matrix4.identity()
            ..translate(width / 2, 0.0, 0.0)
            ..rotateY(-pi / 2),
          alignment: Alignment.center,
          child: Container(
            height: height,
            width: width,
            color: Colors.black,
          ),
        ),
        Transform(
          //front
          transform: Matrix4.identity()..translate(0.0, 0.0, -width / 2.0),
          child: Container(
            color: Colors.black,
            height: height,
            width: width,
          ),
        ),
      ],
    );
  }
}


