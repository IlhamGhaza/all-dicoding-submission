import 'package:flutter/foundation.dart'; 
import 'dart:io' show Platform; 

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_food_recog/core/utils/permission.dart';

class CameraProvider extends ChangeNotifier {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isProcessing = false;
  String? _lastCapturedImagePath;

  CameraController? get controller => _controller;
  bool get isInitialized => _isInitialized;
  bool get isProcessing => _isProcessing;
  String? get lastCapturedImagePath => _lastCapturedImagePath;

  Future<void> initializeCamera() async {
    try {
      _isProcessing = true;
      notifyListeners();

      
      final hasPermission = await checkCameraPermission();
      if (!hasPermission) {
        throw Exception('Camera permission not granted');
      }

      
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        throw Exception('No cameras available');
      }

      
      _controller = CameraController(
        _cameras![0],
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing camera: $e');
      _isInitialized = false;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<String?> captureImage() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return null;
    }

    try {
      _isProcessing = true;
      notifyListeners();

      final XFile image = await _controller!.takePicture();
      _lastCapturedImagePath = image.path;
      return image.path;
    } catch (e) {
      debugPrint('Error capturing image: $e');
      return null;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<String?> pickImageFromGallery() async {
    try {
      _isProcessing = true;
      notifyListeners();

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        _lastCapturedImagePath = image.path;
        return image.path;
      }
      return null;
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<String?> cropImage(String imagePath) async {
    try {
      _isProcessing = true;
      notifyListeners();

      
      if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
        debugPrint(
          "Image Cropper is not supported on this platform. Skipping.",
        );
        _lastCapturedImagePath = imagePath;
        return imagePath;
      }

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imagePath,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.green,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
            ],
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
            ],
          ),
        ],
      );

      if (croppedFile != null) {
        _lastCapturedImagePath = croppedFile.path;
        return croppedFile.path;
      }
      return null;
    } catch (e) {
      debugPrint('Error cropping image: $e');
      return null;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
