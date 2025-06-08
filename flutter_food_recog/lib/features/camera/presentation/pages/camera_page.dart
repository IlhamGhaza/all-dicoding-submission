import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter_food_recog/core/providers/camera_provider.dart';
import 'package:flutter_food_recog/core/routes/app_router.dart';
import 'package:flutter_food_recog/core/utils/snackbar_utils.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  @override
  Widget build(BuildContext context) {
    final cameraProvider = context.watch<CameraProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Take Photo')),
      body: Stack(
        children: [
          if (cameraProvider.isInitialized)
            CameraPreview(cameraProvider.controller!)
          else
            const Center(child: CircularProgressIndicator()),
          if (cameraProvider.isProcessing) // Show loading only for camera operations
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _captureAndProcess(context),
        child: const Icon(Icons.camera),
      ),
    );
  }

  Future<void> _captureAndProcess(BuildContext context) async {
    final cameraProvider = context.read<CameraProvider>();
    // final foodRecognitionProvider = context.read<FoodRecognitionProvider>(); // Not used directly here anymore

    try {
      final imagePath = await cameraProvider.captureImage();
      if (imagePath == null || !context.mounted) return;

      final croppedPath = await cameraProvider.cropImage(imagePath);
      if (croppedPath == null || !context.mounted) return;
      
      if (!context.mounted) return;
      Navigator.pushReplacementNamed(
        context,
        AppRouter.result,
        arguments: croppedPath,
      );
    } catch (e) {
      if (!context.mounted) return;
      SnackbarUtils(
        text: 'Error processing image: $e',
        backgroundColor: Colors.red,
      ).showErrorSnackBar(context);
    }
  }
}
