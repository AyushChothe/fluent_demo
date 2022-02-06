import 'dart:math' as math;
import 'package:fluent_demo/models/tile_data.dart';
import 'package:fluent_demo/widgets/tile_widget.dart';
import 'package:flutter/material.dart';

class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({
    Key? key,
    this.size = 4,
    this.imageProvider,
    required this.puzzleSize,
  }) : super(key: key);

  final int size;
  final Size puzzleSize;
  final ImageProvider? imageProvider;

  @override
  _PuzzleScreenState createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  late List<TileData> tiles;
  late Size tileSize;
  late bool solved;
  late int moves;

  void swap(TileData t1, TileData t2, [bool isMove = false]) {
    TileData t;
    if ((!t1.isBlank && !t2.isBlank) || isMove) {
      t = t1.copyWith();
      t1.offset = t2.offset;
      t2.offset = t.offset;
    }
  }

  bool checkSolved() {
    for (int i = 0; i < tiles.length; i++) {
      if (tiles[i].offset != tiles[i].initOffset) return false;
    }
    return true;
  }

  void reset() {
    moves = 0;
    solved = true;
    tiles = List.generate(
      widget.size * widget.size,
      (i) {
        final col = i ~/ widget.size,
            row = (i % widget.size),
            _dx = col * tileSize.width,
            _dy = row * tileSize.height,
            imgL = col / widget.size,
            imgT = row / widget.size;

        return TileData(
          key: ValueKey(i),
          size: tileSize,
          body: "${i + 1}",
          initOffset: Offset(_dx, _dy),
          offset: Offset(_dx, _dy),
          imageRect: Rect.fromLTRB(
            imgL,
            imgT,
            imgL + (1 / widget.size),
            imgT + (1 / widget.size),
          ),
          isBlank: (i) == (widget.size * widget.size - 1),
        );
      },
    );
  }

  void shuffle() async {
    // setState(() {
    //   for (TileData t in tiles) {
    //     t.offset = Offset(10, (widget.puzzleSize.height - tileSize.height) / 2);
    //   }
    // });

    // await Future.delayed(const Duration(seconds: 1));

    // reset();

    setState(() {
      for (int i = 0; i < tiles.length * 10; i++) {
        TileData t1 = tiles[math.Random().nextInt(tiles.length)],
            t2 = tiles[math.Random().nextInt(tiles.length)];
        move(t1);
        move(t2);
      }
    });
    moves = 0;
  }

  void move(TileData tile) {
    TileData blankTile = tiles.firstWhere((t) => t.isBlank);

    if (((tile.offset.dx - blankTile.offset.dx).abs() == tileSize.width &&
            tile.offset.dy == blankTile.offset.dy) ||
        ((tile.offset.dy - blankTile.offset.dy).abs() == tileSize.height &&
            tile.offset.dx == blankTile.offset.dx)) {
      setState(() {
        swap(tile, blankTile, true);
        moves++;
        solved = checkSolved();
      });
    }
  }

  @override
  void initState() {
    super.initState();

    tileSize = Size(widget.puzzleSize.width / widget.size,
        widget.puzzleSize.width / widget.size);

    reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.imageProvider == null
                ? const FlutterLogo(
                    size: 150,
                  )
                : SizedBox(
                    height: 200,
                    width: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image(image: widget.imageProvider!),
                    ),
                  ),
            Text(
              "$moves Moves",
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(2),
              child: SizedBox(
                height: widget.puzzleSize.height,
                width: widget.puzzleSize.width,
                child: Stack(
                  children: tiles
                      .map(
                        (t) => TileWidget(
                          key: t.key,
                          // tileData: t,
                          // onTap: () => move(t),
                          // imageProvider: widget.imageProvider,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: shuffle,
                  child: const Text("Shuffle"),
                ),
                Chip(
                  label: Text(
                    solved ? "Solved in $moves" : "Unsolved",
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => setState(() {
                    reset();
                  }),
                  child: const Text("Reset"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
