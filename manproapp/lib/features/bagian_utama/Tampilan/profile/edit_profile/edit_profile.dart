import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:manpro/common/widgets/background_app.dart';
import 'package:manpro/utils/constants/image_string.dart';
import 'package:manpro/features/bagian_utama/controllers/profileController.dart';

class EditProfile extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditProfile({
    super.key,
    required this.userData,
  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _isDirty = false;
  late final TextEditingController namaLengkapController;
  late final TextEditingController usernameController;
  late final TextEditingController emailController;
  late final TextEditingController kotaAsalController;
  late final TextEditingController noTelponController;

  @override
  void initState() {
    super.initState();
    namaLengkapController =
        TextEditingController(text: widget.userData['nama_lengkap']);
    usernameController =
        TextEditingController(text: widget.userData['username']);
    emailController = TextEditingController(text: widget.userData['email']);
    kotaAsalController =
        TextEditingController(text: widget.userData['kota_asal']);
    noTelponController =
        TextEditingController(text: widget.userData['no_telpon']);

    // Listen for changes to mark form as dirty
    namaLengkapController.addListener(_markDirty);
    usernameController.addListener(_markDirty);
    emailController.addListener(_markDirty);
    kotaAsalController.addListener(_markDirty);
    noTelponController.addListener(_markDirty);
  }

  void _markDirty() {
    if (!_isDirty) {
      setState(() => _isDirty = true);
    }
  }

  @override
  void dispose() {
    namaLengkapController.dispose();
    usernameController.dispose();
    emailController.dispose();
    kotaAsalController.dispose();
    noTelponController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => isLoading = true);

      final controller = Get.find<ProfileController>();
      await controller.updateProfile(
        namaLengkap: namaLengkapController.text,
        username: usernameController.text,
        email: emailController.text,
        kotaAsal: kotaAsalController.text,
        noTelpon: noTelponController.text,
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      print('Error updating profile: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal memperbarui profil: ${e.toString()}',
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'NunitoSans',
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(20),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (!_isDirty) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Discard Changes?',
          style: TextStyle(
            fontFamily: 'NunitoSans',
            fontWeight: FontWeight.w700,
          ),
        ),
        content: const Text(
          'You have unsaved changes. Do you want to discard them?',
          style: TextStyle(
            fontFamily: 'NunitoSans',
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'NunitoSans',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Discard',
              style: TextStyle(
                fontFamily: 'NunitoSans',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          children: [
            const BackgroundAPP(),
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () async {
                            if (await _onWillPop()) {
                              if (!mounted) return;
                              Navigator.pop(context);
                            }
                          },
                          icon: const ImageIcon(
                            AssetImage(YPKImages.icon_back_button),
                            size: 32.0,
                            semanticLabel: 'Back',
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        const Text(
                          'Edit Profile',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            fontSize: 24.0,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              buildTextField(
                                controller: namaLengkapController,
                                label: 'Nama Lengkap',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Nama lengkap tidak boleh kosong';
                                  }
                                  if (value.length < 3) {
                                    return 'Nama lengkap minimal 3 karakter';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              buildTextField(
                                controller: usernameController,
                                label: 'Username',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Username tidak boleh kosong';
                                  }
                                  if (value.length < 3) {
                                    return 'Username minimal 3 karakter';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              buildTextField(
                                controller: emailController,
                                label: 'Email',
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email tidak boleh kosong';
                                  }
                                  if (!RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                      .hasMatch(value)) {
                                    return 'Email tidak valid';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              buildTextField(
                                controller: kotaAsalController,
                                label: 'Kota Asal',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Kota asal tidak boleh kosong';
                                  }
                                  if (value.length < 3) {
                                    return 'Kota asal minimal 3 karakter';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              buildTextField(
                                controller: noTelponController,
                                label: 'No Telpon',
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(13),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Nomor telepon tidak boleh kosong';
                                  }
                                  if (!value.startsWith('08')) {
                                    return 'Nomor telepon harus dimulai dengan 08';
                                  }
                                  if (value.length < 2) {
                                    return 'Nomor telepon minimal 10 digit';
                                  }
                                  if (value.length > 13) {
                                    return 'Nomor telepon maksimal 13 digit';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: isLoading ? null : _handleSave,
                                child: isLoading
                                    ? const CircularProgressIndicator()
                                    : const Text(
                                        'Save',
                                        style: TextStyle(
                                          fontFamily: 'NunitoSans',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: const TextStyle(
        fontFamily: 'NunitoSans',
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontFamily: 'NunitoSans',
          fontWeight: FontWeight.w700,
        ),
        border: const OutlineInputBorder(),
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 12.0,
          fontFamily: 'NunitoSans',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
