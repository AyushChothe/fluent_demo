import 'package:fluent_demo/models/tile_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final tileDataProvider = Provider<TileData?>((_) => null);
final rectProvider = Provider<Rect>((_) => Rect.zero);
