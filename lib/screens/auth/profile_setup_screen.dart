import 'package:flutter/material.dart';
import '../../utils/ui_utils.dart';
import '../../services/storage_service.dart';
import '../../models/user_profile.dart';
import '../../main.dart'; // To access OnboardingScreen

class ProfileSetupScreen extends StatefulWidget {
  final String email;
  const ProfileSetupScreen({super.key, required this.email});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  String? _gender;
  final _heightCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  bool _isLoading = false;

  final List<String> _genderOptions = ['Female', 'Male', 'Non-binary', 'Prefer not to say'];

  void _saveProfile() async {
    final heightText = _heightCtrl.text.trim();
    final ageText = _ageCtrl.text.trim();

    if (_gender == null || heightText.isEmpty || ageText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields.')),
      );
      return;
    }

    final height = int.tryParse(heightText);
    final age = int.tryParse(ageText);

    if (height == null || age == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Height and age must be valid numbers.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final profile = UserProfile(
      email: widget.email,
      gender: _gender,
      height: height,
      age: age,
    );

    await StorageService.saveUserProfile(profile);

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GlassContainer(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Tell us about yourself',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text('GENDER', style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1.2)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _genderOptions.map((g) {
                        final isSelected = _gender == g;
                        return ChoiceChip(
                          label: Text(g),
                          selected: isSelected,
                          onSelected: (val) => setState(() => _gender = g),
                          selectedColor: const Color(0xFFD4A396),
                          backgroundColor: Colors.white10,
                          labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.white70),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _heightCtrl,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Height',
                        suffixText: 'cm',
                        prefixIcon: Icon(Icons.height, color: Colors.white54),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _ageCtrl,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        prefixIcon: Icon(Icons.cake, color: Colors.white54),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4A396),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
