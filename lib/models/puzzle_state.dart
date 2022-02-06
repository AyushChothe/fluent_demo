import 'package:fluent_demo/models/tile_data.dart';
import 'package:flutter/material.dart';

class PuzzleState {
  final int size;
  final Size puzzleSize;
  final ImageProvider? imageProvider;
  final List<TileData> tiles;
  final Size tileSize;
  final bool solved;
  final int moves;

  PuzzleState({
    required this.size,
    required this.puzzleSize,
    this.tiles = const [],
    this.tileSize = Size.zero,
    this.imageProvider,
    this.solved = false,
    this.moves = 0,
  });

  PuzzleState copyWith({
    int? size,
    Size? puzzleSize,
    ImageProvider? imageProvider,
    List<TileData>? tiles,
    Size? tileSize,
    bool? solved,
    int? moves,
  }) =>
      PuzzleState(
        size: size ?? this.size,
        puzzleSize: puzzleSize ?? this.puzzleSize,
        imageProvider: imageProvider ?? this.imageProvider,
        tiles: tiles ?? this.tiles,
        tileSize: tileSize ?? this.tileSize,
        solved: solved ?? this.solved,
        moves: moves ?? this.moves,
      );
}
