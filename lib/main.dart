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
      size: 3,
      imageProvider: AssetImage("assets/5.jpg"),
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
