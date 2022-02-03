import 'dart:math' as math;
import 'dart:ui';
import 'package:fluent_demo/partImage.dart';
import 'package:flutter/material.dart';

class TileData {
  String body;
  Offset offset, initOffset;
  Rect imageRect;

  bool isBlank;
  Size size;

  Key? key;

  TileData copyWith({
    String? body,
    Offset? offset,
    Offset? initOffset,
    Rect? imageRect,
    bool? isBlank,
    Size? size,
    Key? key,
  }) =>
      TileData(
        body: body ?? this.body,
        offset: offset ?? this.offset,
        initOffset: initOffset ?? this.initOffset,
        imageRect: imageRect ?? this.imageRect,
        isBlank: isBlank ?? this.isBlank,
        size: size ?? this.size,
        key: key ?? this.key,
      );

  TileData({
    required this.body,
    required this.offset,
    required this.initOffset,
    required this.imageRect,
    required this.size,
    this.isBlank = false,
    this.key,
  });
}

class TileWidget extends StatelessWidget {
  final TileData tileData;
  final ImageProvider? imageProvider;
  final void Function()? onTap;

  const TileWidget({
    Key? key,
    this.imageProvider,
    required this.tileData,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned.fromRect(
      rect: Rect.fromLTRB(
        tileData.offset.dy,
        tileData.offset.dx,
        tileData.offset.dy + tileData.size.width,
        tileData.offset.dx + tileData.size.height,
      ),
      duration: const Duration(milliseconds: 500),
      child: tileData.isBlank
          ? const SizedBox.expand()
          : GestureDetector(
              onTap: onTap,
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    margin: const EdgeInsets.all(2.0),
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: tileData.initOffset == tileData.offset
                          ? Colors.blue[700]
                          : Colors.lightBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          tileData.body,
                          style: const TextStyle(fontSize: 50),
                        ),
                      ),
                    ),
                  ),
                  if (imageProvider != null)
                    Positioned.fill(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        margin: const EdgeInsets.all(1.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ImageFiltered(
                            imageFilter: tileData.initOffset == tileData.offset
                                ? ImageFilter.blur()
                                : ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                            child: PartImagePainter(
                              imageProvider: imageProvider!,
                              rect: tileData.imageRect,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

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
      if (tiles[i].offset !=
          Offset(
            i ~/ widget.size * tileSize.width,
            (i % widget.size) * tileSize.height,
          )) return false;
    }
    return true;
  }

  void reset() {
    moves = 0;
    solved = true;
    tiles = List.generate(
      widget.size * widget.size,
      (i) {
        // print((i % widget.size).toInt() / widget.size);
        final row = i ~/ widget.size,
            col = (i % widget.size),
            _dx = row * tileSize.width,
            _dy = col * tileSize.height,
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

  void shuffle() {
    setState(() {
      for (int i = 0; i < tiles.length * 10; i++) {
        TileData t1 = tiles[math.Random().nextInt(tiles.length)],
            t2 = tiles[math.Random().nextInt(tiles.length)];
        move(t1);
        move(t2);
      }
      moves = 0;
    });
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
                          tileData: t,
                          onTap: () => move(t),
                          imageProvider: widget.imageProvider,
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
