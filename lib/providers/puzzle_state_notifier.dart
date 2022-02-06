import 'dart:math' as math;
import 'package:fluent_demo/models/puzzle_state.dart';
import 'package:fluent_demo/models/tile_data.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final puzzleStateProvider =
    StateNotifierProvider<PuzzleStateNotifier, PuzzleState>(
  (ref) {
    return PuzzleStateNotifier(
      PuzzleState(
          puzzleSize: const Size(500, 500),
          size: 4,
          imageProvider: const AssetImage("assets/7.gif")
          // imageProvider: const NetworkImage(
          //     "https://pro2-bar-s3-cdn-cf1.myportfolio.com/eea16061-59a8-442a-9b65-0c684f52f904/2b4d7379-b5a1-4aa1-a8fc-768150f862a3_car_1x1.gif?h=8d4018e753547e55e5b67b73ef443099"),
          ),
    );
  },
);

class PuzzleStateNotifier extends StateNotifier<PuzzleState> {
  PuzzleStateNotifier(PuzzleState state) : super(state) {
    reset();
  }

  void swap(TileData t1, TileData t2, [bool isMove = false]) {
    TileData t;
    if ((!t1.isBlank && !t2.isBlank) || isMove) {
      t = t1.copyWith();
      t1.offset = t2.offset;
      t2.offset = t.offset;
    }
  }

  void setPuzzleSize(Size _size) {
    state = state.copyWith(
      puzzleSize: _size,
      tileSize: Size(
        _size.width / state.size,
        _size.width / state.size,
      ),
    );
  }

  bool checkSolved() {
    for (int i = 0; i < state.tiles.length; i++) {
      if (state.tiles[i].offset != state.tiles[i].initOffset) return false;
    }
    return true;
  }

  void reset() {
    state = state.copyWith(
      tileSize: Size(
        state.puzzleSize.width / state.size,
        state.puzzleSize.width / state.size,
      ),
    );
    state = state.copyWith(
      tiles: List.generate(
        state.size * state.size,
        (i) {
          final row = i ~/ state.size,
              col = (i % state.size),
              _dx = col * state.tileSize.width,
              _dy = row * state.tileSize.height,
              imgL = col / state.size,
              imgT = row / state.size;

          return TileData(
            key: ValueKey(i),
            size: state.tileSize,
            body: "${i + 1}",
            initOffset: Offset(_dx, _dy),
            offset: Offset(_dx, _dy),
            imageRect: Rect.fromLTRB(
              imgL,
              imgT,
              imgL + (1 / state.size),
              imgT + (1 / state.size),
            ),
            isBlank: (i) == (state.size * state.size - 1),
          );
        },
      ),
      moves: 0,
      solved: true,
    );
  }

  void shuffle() async {
    for (int i = 0; i < state.tiles.length * 10; i++) {
      TileData t1 = state.tiles[math.Random().nextInt(state.tiles.length)],
          t2 = state.tiles[math.Random().nextInt(state.tiles.length)];
      move(t1);
      move(t2);
    }
    state = state.copyWith(moves: 0);
  }

  void move(TileData tile) {
    TileData blankTile = state.tiles.firstWhere((t) => t.isBlank);

    if (((tile.offset.dx - blankTile.offset.dx).abs() == state.tileSize.width &&
            tile.offset.dy == blankTile.offset.dy) ||
        ((tile.offset.dy - blankTile.offset.dy).abs() ==
                state.tileSize.height &&
            tile.offset.dx == blankTile.offset.dx)) {
      swap(tile, blankTile, true);
      state = state.copyWith(solved: checkSolved(), moves: state.moves + 1);
    }
  }
}
