import 'dart:io';

import 'package:client/core/theme/app_colors.dart';
import 'package:client/core/utils/audio_picker.dart';
import 'package:client/core/utils/image_picker.dart';
import 'package:client/core/utils/show_snack_bar.dart';
import 'package:client/core/widgets/custom_text_field.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view/widgets/audio_wave.dart';
import 'package:client/features/home/view_model/home_view_model.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<UploadSongPage> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final _artistController = TextEditingController();
  final _songNameController = TextEditingController();
  Color selectedColor = AppColors.cardColor;
  final ImagePicker _imagePicker = ImagePicker();
  final AudioPicker _audioPicker = AudioPicker();
  File? _selectedImage;
  File? _selectedAudio;
  final _formKey = GlobalKey<FormState>();

  void _pickImage() async {
    final pickedImage = await _imagePicker.pickFile();
    if (pickedImage != null) {
      setState(() {
        _selectedImage = pickedImage;
      });
    }
  }

  void _pickAudio() async {
    final pickedAudio = await _audioPicker.pickFile();
    if (pickedAudio != null) {
      setState(() {
        _selectedAudio = pickedAudio;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _artistController.dispose();
    _songNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(homeViewModelProvider.select((val) => val?.isLoading == true));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Song'),
        actions: [
          IconButton(
            onPressed: () async {
              if (_formKey.currentState!.validate() &&
                  _selectedImage != null &&
                  _selectedAudio != null) {
                ref.read(homeViewModelProvider.notifier).uploadSong(
                      selectedThumbnail: _selectedImage!,
                      selectedAudio: _selectedAudio!,
                      songName: _songNameController.text.trim(),
                      artist: _artistController.text.trim(),
                      selectedColor: selectedColor,
                    );
              } else {
                showSnackBack(context, 'Missing required fields',
                    isError: true);
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: isLoading == true
          ? const Loader()
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: _selectedImage != null
                            ? SizedBox(
                                width: double.infinity,
                                height: 150,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : DottedBorder(
                                color: AppColors.borderColor,
                                borderType: BorderType.RRect,
                                strokeCap: StrokeCap.round,
                                radius: const Radius.circular(10),
                                dashPattern: const [10, 4],
                                child: const SizedBox(
                                  height: 160,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.folder_open, size: 40),
                                      SizedBox(height: 16),
                                      Text(
                                        'Select the thumbnail for your song',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 40),
                      _selectedAudio != null
                          ? AudioWave(path: _selectedAudio!.path)
                          : CustomTextField(
                              readOnly: true,
                              textEditingController: null,
                              hintText: 'Pick Song',
                              onTap: _pickAudio,
                            ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        textEditingController: _artistController,
                        hintText: 'Artist',
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        textEditingController: _songNameController,
                        hintText: 'Song Name',
                      ),
                      const SizedBox(height: 20),
                      ColorPicker(
                        pickersEnabled: const {ColorPickerType.wheel: true},
                        onColorChanged: (color) {
                          setState(() {
                            selectedColor = color;
                          });
                        },
                        color: selectedColor,
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
