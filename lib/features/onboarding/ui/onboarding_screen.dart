import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:madsm/constants/constants.dart';
import 'package:madsm/features/common/ui/widgets/common_cached_image.dart';
import 'package:madsm/utils/supabase_storage_helper.dart';

import '../../../extensions/build_context_extension.dart';
import '../../../features/common/ui/widgets/common_text_form_field.dart';
import '../../../features/common/ui/widgets/primary_button.dart';
import '../../../features/profile/ui/view_models/profile_view_model.dart';
import '../../../routing/routes.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isButtonEnabled = false;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateButtonState);
    _nameController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    final isEnabled = _nameController.text.trim().isNotEmpty;
    if (isEnabled != _isButtonEnabled) {
      setState(() {
        _isButtonEnabled = isEnabled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  final imagePicker = ImagePicker();
                  final image = await imagePicker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    final userId = ref.read(profileViewModelProvider).value?.profile?.id ?? 'Unknown_user';
                    final path = '$userId/images/${DateTime.now().millisecondsSinceEpoch}';
                    final url = await SupabaseStorageHelper.instance.uploadFile(
                      Constants.avatarsBucket,
                      path,
                      File(image.path),
                    );
                    await ref.read(profileViewModelProvider.notifier).updateProfile(
                          avatar: url,
                        );
                    setState(() {
                      imageUrl = url;
                    });
                  }
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  child: imageUrl == null
                      ? const Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Colors.grey,
                        )
                      : CommonCachedImage(
                          imageUrl: imageUrl ?? '',
                        ),
                ),
              ),
              const SizedBox(height: 24),
              CommonTextFormField(
                label: 'Your Name',
                controller: _nameController,
              ),
              const Spacer(),
              PrimaryButton(
                text: 'Continue',
                onPressed: () => _saveNameAndContinue(context),
                isEnable: _isButtonEnabled,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveNameAndContinue(BuildContext context) async {
    try {
      await ref.read(profileViewModelProvider.notifier).updateProfile(
            name: _nameController.text.trim(),
          );
      if (context.mounted) {
        context.pushReplacement(Routes.home);
      }
    } catch (error) {
      if (context.mounted) {
        context.showErrorSnackBar('Failed to save profile');
      }
    }
  }
}
