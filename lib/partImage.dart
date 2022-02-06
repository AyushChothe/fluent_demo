import 'dart:ui' as ui;
import 'package:fluent_demo/providers/all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PartImagePainter extends HookConsumerWidget {
  const PartImagePainter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gifCtrl = useStreamController<ui.Image>();
    final imageProvider = ref.watch(puzzleStateProvider).imageProvider!;
    final rect = ref.read(rectProvider);

    useEffect(() {
      imageProvider
          .resolve(const ImageConfiguration())
          .addListener(ImageStreamListener((ImageInfo info, bool _) {
        if (!gifCtrl.isClosed) {
          gifCtrl.sink.add(info.image);
        }
      }));
      return null;
    }, []);
    
    return StreamBuilder(
        stream: gifCtrl.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // If the Future is complete, display the preview.
            return paintImage(snapshot.data, rect);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget paintImage(image, rect) {
    return CustomPaint(
      painter: ImagePainter(image, rect),
      child: SizedBox(
        width: rect.width,
        height: rect.height,
      ),
    );
  }
}

class ImagePainter extends CustomPainter {
  ui.Image resImage;

  Rect rectCrop;

  ImagePainter(this.resImage, this.rectCrop);

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Size imageSize =
        Size(resImage.width.toDouble(), resImage.height.toDouble());
    FittedSizes sizes = applyBoxFit(BoxFit.fitWidth, imageSize, size);

    Rect inputSubRect = Rect.fromLTRB(
        rectCrop.left * imageSize.width,
        rectCrop.top * imageSize.height,
        rectCrop.right * imageSize.width,
        rectCrop.bottom * imageSize.height);
    final Rect outputSubRect =
        Alignment.center.inscribe(sizes.destination, rect);

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 4;
    canvas.drawRect(rect, paint);
    canvas.drawImageRect(resImage, inputSubRect, outputSubRect, Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
