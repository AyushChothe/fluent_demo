import 'package:fluent_demo/puzzle.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Puzzle App",
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const PuzzleScreen(
      puzzleSize: Size(500, 500),
      size: 4,
      imageProvider: AssetImage("assets/7.gif"),
      // imageProvider: NetworkImage(
      //     "https://pro2-bar-s3-cdn-cf1.myportfolio.com/eea16061-59a8-442a-9b65-0c684f52f904/2b4d7379-b5a1-4aa1-a8fc-768150f862a3_car_1x1.gif?h=8d4018e753547e55e5b67b73ef443099"),
    );

    // imageProvider: NetworkImage(
    //     "http://www.wonderplanets.de/Mond/2006/Mosaik_110906_half.jpg"),

    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text("Image Crop Example"),
    //   ),
    //   body: const AspectRatio(
    //     aspectRatio: 1,
    //     child: SizedBox.expand(
    //       child: PartImagePainter(
    //         imageUrl:
    //             "https://raw.githubusercontent.com/VGVentures/slide_puzzle/release/assets/images/dashatar/gallery/blue.png",
    //         rect: Rect.fromLTRB(0.2, 0.2, 0.75, 0.75),
    //       ),
    //     ),
    //   ),
    // );
  }
}
