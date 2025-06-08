import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_food_recog/core/providers/camera_provider.dart';
import 'package:flutter_food_recog/core/routes/app_router.dart';
import 'package:flutter_food_recog/core/utils/snackbar_utils.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Food Recognition')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.restaurant, size: 100, color: Colors.teal),
            const SizedBox(height: 24),
            const Text(
              'Food Recognition App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Take a photo or select an image to identify food',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: () => _navigateToCamera(context),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take Photo'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _selectFromGallery(context),
              icon: const Icon(Icons.photo_library),
              label: const Text('Select from Gallery'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToCamera(BuildContext context) async {
    final cameraProvider = context.read<CameraProvider>();

    try {
      await cameraProvider.initializeCamera();
      if (!context.mounted) return;

      Navigator.pushNamed(context, AppRouter.camera);
    } catch (e) {
      if (!context.mounted) return;
      SnackbarUtils(
        text: 'Failed to initialize camera: $e',
        backgroundColor: Colors.red,
      ).showErrorSnackBar(context);
    }
  }

  Future<void> _selectFromGallery(BuildContext context) async {
    final cameraProvider = context.read<CameraProvider>();
    // final foodRecognitionProvider = context.read<FoodRecognitionProvider>(); // Not used directly here anymore

    try {
      final imagePath = await cameraProvider.pickImageFromGallery();
      if (imagePath == null || !context.mounted) return;

      final croppedPath = await cameraProvider.cropImage(imagePath);
      if (croppedPath == null || !context.mounted) return;
      
      if (!context.mounted) return;
      Navigator.pushNamed(
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
