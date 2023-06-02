import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:bookfx/bookfx.dart';

class SimpleStateMachine extends StatefulWidget {
  const SimpleStateMachine({Key? key}) : super(key: key);

  @override
  _SimpleStateMachineState createState() => _SimpleStateMachineState();
}

class _SimpleStateMachineState extends State<SimpleStateMachine> {
  //SMITrigger? _boolExampleInput;
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

  // void _onRiveInit(Artboard artboard) {
  //   final controller =
  //       StateMachineController.fromArtboard(artboard, 'State Machine 1');
  //   artboard.addController(controller!);
  // }

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: BookFx(
          size: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height),
          pageCount: rives.length,
          currentPage: (index) {
            print("${index}");
            return RiveAnimation.asset(
              rives[index],
              //'assets/fish3.riv',
              // onInit: _onRiveInit,
            );
          },
          lastCallBack: (index) {
            print("KFZTEST:lastCallBackprint('lastCallBack $index');");
            if (index == 0) {
              return;
            }
            setState(() {});
          },
          nextCallBack: (index) {
            setState(() {});
            print("KFZTEST:nextCallBackprint('next $index');");
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
