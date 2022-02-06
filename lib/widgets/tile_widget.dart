import 'dart:ui';

import 'package:fluent_demo/partImage.dart';
import 'package:fluent_demo/providers/all.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TileWidget extends ConsumerWidget {
  const TileWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tileData = ref.watch(tileDataProvider)!;
    final puzzleState = ref.watch(puzzleStateProvider);
    final puzzleStateNotifier = ref.read(puzzleStateProvider.notifier);

    return AnimatedPositioned.fromRect(
      key: tileData.key,
      rect: Rect.fromLTRB(
        tileData.offset.dx,
        tileData.offset.dy,
        tileData.offset.dx + tileData.size.height,
        tileData.offset.dy + tileData.size.width,
      ),
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      child: tileData.isBlank
          ? const SizedBox.expand()
          : GestureDetector(
              onTap: () => puzzleStateNotifier.move(tileData),
              child: Stack(
                children: [
                  if (puzzleState.imageProvider != null)
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
                                : ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                            child: ProviderScope(
                              overrides: [
                                rectProvider
                                    .overrideWithValue(tileData.imageRect)
                              ],
                              child: const PartImagePainter(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    margin: const EdgeInsets.all(2.0),
                    height: double.infinity,
                    width: double.infinity,
                    decoration: puzzleState.imageProvider != null
                        ? null
                        : BoxDecoration(
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
                          style: TextStyle(
                            fontSize: 50,
                            color: Colors.white.withOpacity(
                              tileData.initOffset == tileData.offset
                                  ? 0.0
                                  : 0.5,
                            ),
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
