import 'package:bookfx/bookfx.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

/// 自定义
class CustomWidget extends StatefulWidget {
  const CustomWidget({Key? key}) : super(key: key);

  @override
  State<CustomWidget> createState() => _CustomWidgetState();
}

class _CustomWidgetState extends State<CustomWidget> {
  BookController bookController = BookController();

  List rives = [
    'assets/fish1.riv',
    'assets/fish2.riv',
    'assets/fish3.riv',
    'assets/fish4.riv',
    'assets/fish5.riv',
    'assets/fish6.riv',
    'assets/fish7.riv',
    'assets/fish8.riv',
  ];

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      color: Colors.white,
      child: BookFx(
          size: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height),
          pageCount: rives.length,
          currentPage: (index) {
            return RiveAnimation.asset(
              rives[index],
              //onInit: _onRiveInit,
            );
          },
          lastCallBack: (index) {
            setState(() {});
          },
          nextCallBack: (index) {
            setState(() {});
          },
          nextPage: (index) {
            return RiveAnimation.asset(
              rives[index],
              //onInit: _onRiveInit,
            );
          },
          controller: bookController),
    );
  }
}
