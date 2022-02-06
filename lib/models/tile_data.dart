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
