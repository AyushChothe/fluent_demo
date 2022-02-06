import 'package:fluent_demo/providers/all.dart';
import 'package:fluent_demo/widgets/tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PuzzlePage extends HookConsumerWidget {
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzleState = ref.watch(puzzleStateProvider);
    final puzzleStateNotifier = ref.read(puzzleStateProvider.notifier);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              puzzleState.imageProvider == null
                  ? const FlutterLogo(
                      size: 150,
                    )
                  : SizedBox(
                      height: 200,
                      width: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image(image: puzzleState.imageProvider!),
                      ),
                    ),
              Text(
                "${puzzleState.moves} Moves",
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
                  height: puzzleState.puzzleSize.height,
                  width: puzzleState.puzzleSize.width,
                  child: Stack(
                    children: puzzleState.tiles
                        .map(
                          (t) => ProviderScope(
                            overrides: [tileDataProvider.overrideWithValue(t)],
                            child: const TileWidget(),
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
                    onPressed: puzzleStateNotifier.shuffle,
                    child: const Text("Shuffle"),
                  ),
                  Chip(
                    label: Text(
                      puzzleState.solved
                          ? "Solved in ${puzzleState.moves}"
                          : "Unsolved",
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: puzzleStateNotifier.reset,
                    child: const Text("Reset"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
