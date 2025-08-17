import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/state/api_state.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../providers/story_provider.dart';
import '../../../routes/app_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/utils/permission.dart';
import '../../../widget/loading_shimmer.dart';

class AddStoryPage extends StatefulWidget {
  const AddStoryPage({super.key});

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _imagePicker = ImagePicker();
  File? _selectedImage;
  LatLng? _selectedLocation;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleImageSelection(ImageSource source) async {
    bool permissionGranted = false;
    try {
      if (source == ImageSource.camera) {
        permissionGranted = await checkCameraPermission();
      } else {
        permissionGranted = await checkAndroidExternalStoragePermission();
      }

      if (!permissionGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Permission not granted to access ${source == ImageSource.camera ? "camera" : "gallery"}.')),
          );
        }
        return;
      }

      final pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(l10n.selectImageSourceCamera),
                onTap: () {
                  context.pop();
                  _handleImageSelection(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(l10n.selectImageSourceGallery),
                onTap: () {
                  context.pop();
                  _handleImageSelection(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectLocation() async {
    final result = await context.push<LatLng>(AppRouter.selectLocationPath);
    if (result != null) {
      setState(() {
        _selectedLocation = result;
      });
    }
  }

  void _uploadStory() {
    if (_formKey.currentState!.validate() && _selectedImage != null) {
      context.read<StoryProvider>().addStory(
            _descriptionController.text.trim(),
            _selectedImage!,
            lat: _selectedLocation?.latitude,
            lon: _selectedLocation?.longitude,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addStory),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            context.read<StoryProvider>().resetAddStoryState();
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _showImageSourceDialog,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 48,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.selectImage,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: l10n.description,
                  alignLabelWithHint: true,
                  hintText: 'Tell your story...',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value.trim().length < 10) {
                    return 'Description must be at least 10 characters';
                  }
                  return null;
                },
              ),
              if (AppConfig.isPaidFlavor) ...[
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  icon: const Icon(Icons.map_outlined),
                  label: Text(_selectedLocation == null
                      ? l10n.selectLocationOnMap
                      : l10n.changeLocation),
                  onPressed: _selectLocation,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                if (_selectedLocation != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '${l10n.currentLocation}: Lat: ${_selectedLocation!.latitude.toStringAsFixed(4)}, Lon: ${_selectedLocation!.longitude.toStringAsFixed(4)}',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
              const SizedBox(height: 32),
              Consumer<StoryProvider>(
                builder: (context, storyProvider, child) {
                  if (storyProvider.addStoryState is ApiSuccess) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.storyUploadSuccess),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                        );
                        storyProvider.resetAddStoryState();
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/');
                        }
                      }
                    });
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LoadingShimmer(
                        isLoading: storyProvider.addStoryState is ApiLoading,
                        child: ElevatedButton(
                          onPressed:
                              (storyProvider.addStoryState is ApiLoading ||
                                      _selectedImage == null)
                                  ? null
                                  : _uploadStory,
                          child: storyProvider.addStoryState is ApiLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(l10n.uploadStory),
                        ),
                      ),
                      if (_selectedImage == null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Please select an image first',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      if (storyProvider.addStoryState is ApiError) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            (storyProvider.addStoryState as ApiError).message,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onErrorContainer,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
