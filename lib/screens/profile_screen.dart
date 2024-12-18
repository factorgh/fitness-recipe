// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:fit_cibus/models/user.dart';
import 'package:fit_cibus/providers/user_provider.dart';
import 'package:fit_cibus/screens/update_profile_screen.dart';
import 'package:fit_cibus/services/auth_service.dart';
import 'package:fit_cibus/widgets/copy_to_clipboard.dart';
import 'package:fit_cibus/widgets/reusable_button.dart';
import 'package:fit_cibus/widgets/status_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class __ProfileHeaderState extends State<_ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: widget.imageUrl != null
                ? NetworkImage(widget.imageUrl!)
                : const AssetImage('assets/images/default_profile.png')
                    as ImageProvider,
            backgroundColor: Colors.grey.shade200,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: widget.onEdit,
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.redAccent,
                child: Icon(Icons.edit, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditProfileButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Reusablebutton(
      text: 'Update Profile',
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const UpdateProfileScreen(),
        ));
      },
    );
  }
}

class _InfoField extends StatelessWidget {
  final String label;
  final String value;

  const _InfoField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatefulWidget {
  final String? imageUrl;
  final VoidCallback onEdit;

  const _ProfileHeader({this.imageUrl, required this.onEdit});

  @override
  __ProfileHeaderState createState() => __ProfileHeaderState();
}

class _ProfileInfo extends StatelessWidget {
  final User user;

  const _ProfileInfo({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoField(label: 'Name', value: user.fullName),
        _InfoField(label: 'Email', value: user.email),
        _InfoField(label: 'Username', value: user.username),
      ],
    );
  }
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String? _imageUrl;
  AuthService authService = AuthService();

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('User data not found.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _ProfileHeader(
              imageUrl: user.imageUrl ?? _imageUrl,
              onEdit: _pickImage,
            ),
            const SizedBox(height: 20),
            _ProfileInfo(user: user),
            const SizedBox(height: 20),
            const StatusToggleButton(),
            const SizedBox(height: 20),
            _EditProfileButton(),
            const SizedBox(height: 50),
            CopyToClipboardWidget(
              textToCopy: user.code ?? 'No code available',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _imageUrl = pickedFile.path;
      });

      // Upload the image to Cloudinary and update user profile
      await _updateProfile(pickedFile);
    }
  }

  Future<void> _updateProfile(XFile imageFile) async {
    final cloudinary = CloudinaryPublic('daq5dsnqy', 'jqx9kpde');

    // Upload image to Cloudinary
    CloudinaryResponse uploadResult = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(imageFile.path, folder: 'voltican_fitness'),
    );

    final image = uploadResult.secureUrl;
    print('Image URL: $image');

    final userId = ref.read(userProvider)?.id;

    if (userId == null) {
      print('User ID is null, cannot update profile image.');
      return;
    }

    await authService.updateImage(
        context: context, imageUrl: image, id: userId);

    // Here you would typically update the user's profile with the new image URL.
    ref.read(userProvider.notifier).updateImageUrl(imageUrl: image);
  }
}
