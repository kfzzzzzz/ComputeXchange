import 'package:compute_xchange/AnimiBookTest/bookTest.dart';
import 'package:compute_xchange/ScaffoldRoute.dart';
import 'package:compute_xchange/textToImage/bloc/text_to_image_bloc.dart';
import 'package:compute_xchange/textToImage/textToImagePage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const CustomWidget(),
    );
  }
}
