import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

const _kBg = Color(0xFF1F1C1A);
const _kAccent = Color(0xFFD4A396);

void main() => runApp(const MakenaApp());

// ─────────────────────────────────────────────────────────────── App ──────────

class MakenaApp extends StatelessWidget {
  const MakenaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Makena',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: _kBg,
        colorScheme: const ColorScheme.dark(primary: _kAccent),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _kAccent,
            foregroundColor: Colors.white,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withValues(alpha:0.07),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _kAccent),
          ),
          labelStyle: const TextStyle(color: Colors.white54),
        ),
      ),
      home: const OnboardingScreen(),
    );
  }
}

// ─────────────────────────────────────────────────────── Data models ──────────

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String body;
  const _OnboardingPage(this.icon, this.title, this.body);
}

class _PaletteColor {
  final String name;
  final Color color;
  const _PaletteColor(this.name, this.color);
}

class _BodyShapeInfo {
  final IconData icon;
  final String description;
  final List<String> tips;
  const _BodyShapeInfo({required this.icon, required this.description, required this.tips});
}

class _SavedProfile {
  final String name;
  final double shoulder, bust, waist, hip;
  final String undertone;
  const _SavedProfile({
    required this.name,
    required this.shoulder,
    required this.bust,
    required this.waist,
    required this.hip,
    required this.undertone,
  });
}

// ─────────────────────────────────────────────────────── Constants ────────────

const _onboardingPages = [
  _OnboardingPage(
    Icons.camera_alt_outlined,
    'Discover Your Shape',
    'Use your camera or enter measurements to identify your unique body silhouette.',
  ),
  _OnboardingPage(
    Icons.palette_outlined,
    'Find Your Palette',
    'Choose your skin undertone and unlock the colours that naturally complement you.',
  ),
  _OnboardingPage(
    Icons.auto_awesome,
    'Style, Simplified',
    'Get curated style rules and colour palettes matched to your profile — every time.',
  ),
];

const _savedProfiles = [
  _SavedProfile(name: 'My Profile', shoulder: 96.5, bust: 92.0, waist: 66.4, hip: 98.2, undertone: 'Warm'),
  _SavedProfile(name: 'Summer 24', shoulder: 94.0, bust: 90.0, waist: 68.0, hip: 96.0, undertone: 'Cool'),
];

const _bodyShapeInfo = {
  'Hourglass': _BodyShapeInfo(
    icon: Icons.accessibility_new,
    description: 'Bust and hips are balanced with a clearly defined waist.',
    tips: [
      'Wrap dresses and fitted blazers celebrate your silhouette',
      'High-waist bottoms emphasise your natural curves',
      'Belt outerwear to showcase your waist definition',
      'Bodycon and form-fitting styles work beautifully',
    ],
  ),
  'Pear': _BodyShapeInfo(
    icon: Icons.person_outline,
    description: 'Your hips are wider than your shoulders and bust.',
    tips: [
      'A-line and flared skirts skim over hips elegantly',
      'Statement tops and structured shoulders balance proportions',
      'Wide necklines and off-shoulder styles draw the eye upward',
      'Avoid heavy fabric or pockets at the hip line',
    ],
  ),
  'Apple': _BodyShapeInfo(
    icon: Icons.radio_button_unchecked,
    description: 'Your bust and shoulders are broader with a less defined waist.',
    tips: [
      'Empire-waist and flowy fabrics create length and flow',
      'Deep V-necks and open necklines elongate the torso',
      'Monochromatic looks create a sleek vertical line',
      'Wrap styles with ruching add gentle definition',
    ],
  ),
  'Rectangle': _BodyShapeInfo(
    icon: Icons.crop_square,
    description: 'Your bust, waist, and hips are close in measurement.',
    tips: [
      'Ruffles, layers, and texture create the illusion of curves',
      'Peplum tops and skirts add shape at the waist',
      'Belts worn at the natural waist define your silhouette',
      'Bold prints at the hip or bust add visual dimension',
    ],
  ),
};

const Map<String, List<_PaletteColor>> _palettes = {
  'Cool': [
    _PaletteColor('Navy', Color(0xFF1A237E)),
    _PaletteColor('Lavender', Color(0xFFBA68C8)),
    _PaletteColor('Emerald', Color(0xFF00695C)),
    _PaletteColor('Rose', Color(0xFFE91E63)),
    _PaletteColor('Slate', Color(0xFF78909C)),
    _PaletteColor('Icy Pink', Color(0xFFF8BBD9)),
  ],
  'Warm': [
    _PaletteColor('Terracotta', Color(0xFFBF360C)),
    _PaletteColor('Gold', Color(0xFFF9A825)),
    _PaletteColor('Coral', Color(0xFFFF7043)),
    _PaletteColor('Olive', Color(0xFF827717)),
    _PaletteColor('Rust', Color(0xFFD84315)),
    _PaletteColor('Camel', Color(0xFFBCAAA4)),
  ],
  'Neutral': [
    _PaletteColor('Taupe', Color(0xFF8D6E63)),
    _PaletteColor('Blush', Color(0xFFD4A396)),
    _PaletteColor('Sage', Color(0xFF81C784)),
    _PaletteColor('Burgundy', Color(0xFF880E4F)),
    _PaletteColor('Sky Blue', Color(0xFF4FC3F7)),
    _PaletteColor('Cream', Color(0xFFFFF8E1)),
  ],
};

String _calculateBodyShape(double bust, double waist, double hip) {
  if (hip - bust > 5) return 'Pear';
  if (bust - hip > 5) return 'Apple';
  if (bust / waist >= 1.25 && hip / waist >= 1.25) return 'Hourglass';
  return 'Rectangle';
}

// ──────────────────────────────────────────────── OnboardingScreen ────────────

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _onboardingPages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MeasurementInputScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _onboardingPages.length,
                itemBuilder: (_, i) => _OnboardingPageView(page: _onboardingPages[i]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingPages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == i ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == i ? _kAccent : Colors.white24,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _next,
                      child: Text(
                        _currentPage == _onboardingPages.length - 1 ? 'Get Started' : 'Next',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageView extends StatelessWidget {
  final _OnboardingPage page;
  const _OnboardingPageView({required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: _kAccent.withValues(alpha:0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(page.icon, size: 64, color: _kAccent),
          ),
          const SizedBox(height: 40),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            page.body,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, color: Colors.white60, height: 1.6),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────── MeasurementInputScreen ───────────

class MeasurementInputScreen extends StatefulWidget {
  const MeasurementInputScreen({super.key});

  @override
  State<MeasurementInputScreen> createState() => _MeasurementInputScreenState();
}

class _MeasurementInputScreenState extends State<MeasurementInputScreen> {
  final _shoulderCtrl = TextEditingController();
  final _bustCtrl = TextEditingController();
  final _waistCtrl = TextEditingController();
  final _hipCtrl = TextEditingController();
  String _undertone = 'Warm';

  @override
  void dispose() {
    _shoulderCtrl.dispose();
    _bustCtrl.dispose();
    _waistCtrl.dispose();
    _hipCtrl.dispose();
    super.dispose();
  }

  void _loadProfile(_SavedProfile p) {
    setState(() {
      _shoulderCtrl.text = p.shoulder.toString();
      _bustCtrl.text = p.bust.toString();
      _waistCtrl.text = p.waist.toString();
      _hipCtrl.text = p.hip.toString();
      _undertone = p.undertone;
    });
  }

  void _openCamera() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => CameraSimulationView(
        onScanComplete: (shoulder, bust, waist, hip) => setState(() {
          _shoulderCtrl.text = shoulder.toStringAsFixed(1);
          _bustCtrl.text = bust.toStringAsFixed(1);
          _waistCtrl.text = waist.toStringAsFixed(1);
          _hipCtrl.text = hip.toStringAsFixed(1);
        }),
      ),
    ));
  }

  void _viewResults() {
    final shoulder = double.tryParse(_shoulderCtrl.text);
    final bust = double.tryParse(_bustCtrl.text);
    final waist = double.tryParse(_waistCtrl.text);
    final hip = double.tryParse(_hipCtrl.text);

    if (shoulder == null || bust == null || waist == null || hip == null || waist == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all four measurements before continuing.')),
      );
      return;
    }

    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ResultsScreen(
        shoulder: shoulder,
        bust: bust,
        waist: waist,
        hip: hip,
        undertone: _undertone,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Your Measurements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('SAVED PROFILES', style: TextStyle(color: Colors.white38, fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: _savedProfiles
                  .map((p) => ActionChip(
                        label: Text(p.name),
                        backgroundColor: Colors.white10,
                        labelStyle: const TextStyle(color: _kAccent),
                        onPressed: () => _loadProfile(p),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 28),
            const Text('BODY MEASUREMENTS (CM)', style: TextStyle(color: Colors.white38, fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _MeasurementField(controller: _shoulderCtrl, label: 'Shoulder'),
            const SizedBox(height: 12),
            _MeasurementField(controller: _bustCtrl, label: 'Bust'),
            const SizedBox(height: 12),
            _MeasurementField(controller: _waistCtrl, label: 'Waist'),
            const SizedBox(height: 12),
            _MeasurementField(controller: _hipCtrl, label: 'Hip'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _openCamera,
                icon: const Icon(Icons.camera_alt_outlined, color: _kAccent),
                label: const Text('Scan with Camera', style: TextStyle(color: _kAccent)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: _kAccent),
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Text('SKIN UNDERTONE', style: TextStyle(color: Colors.white38, fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: ['Cool', 'Warm', 'Neutral'].map((tone) {
                final selected = _undertone == tone;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () => setState(() => _undertone = tone),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selected ? _kAccent : Colors.white10,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          tone,
                          style: TextStyle(
                            color: selected ? Colors.white : Colors.white54,
                            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _viewResults,
                child: const Text('See My Results'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MeasurementField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  const _MeasurementField({required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(labelText: label, suffixText: 'cm'),
    );
  }
}

// ─────────────────────────────────────────────── Pose measurement helpers ────

class _BodyMeasurements {
  final double shoulder, bust, waist, hip;
  const _BodyMeasurements({required this.shoulder, required this.bust, required this.waist, required this.hip});
}

// Derives body circumferences (cm) from ML Kit pose landmarks.
//
// Shoulder and hip widths come from their respective landmarks. Waist is
// estimated at 73 % of hip width (average female proportion) and bust at
// 92 % of shoulder width, because ML Kit has no waist or bust landmark.
// Pixel widths are scaled to cm using the shoulder→ankle pixel distance as a
// height proxy (assumed 140 cm for an average 165 cm adult standing upright),
// then converted to circumferences with the ellipse approximation
// C ≈ 2.59 × width (body depth ≈ 62.5 % of frontal width).
_BodyMeasurements? _extractMeasurements(Pose pose) {
  final ls = pose.landmarks[PoseLandmarkType.leftShoulder];
  final rs = pose.landmarks[PoseLandmarkType.rightShoulder];
  final lh = pose.landmarks[PoseLandmarkType.leftHip];
  final rh = pose.landmarks[PoseLandmarkType.rightHip];
  final la = pose.landmarks[PoseLandmarkType.leftAnkle];
  final ra = pose.landmarks[PoseLandmarkType.rightAnkle];

  if (ls == null || rs == null || lh == null || rh == null || la == null || ra == null) {
    return null;
  }
  if (ls.likelihood < 0.5 || rs.likelihood < 0.5 ||
      lh.likelihood < 0.5 || rh.likelihood < 0.5) {
    return null;
  }

  final shoulderWidthPx = (rs.x - ls.x).abs();
  final hipWidthPx = (rh.x - lh.x).abs();

  final shoulderMidY = (ls.y + rs.y) / 2;
  final ankleMidY = (la.y + ra.y) / 2;
  final heightPx = ankleMidY - shoulderMidY;
  if (heightPx <= 0 || shoulderWidthPx <= 0 || hipWidthPx <= 0) return null;

  const shoulderToAnkleCm = 140.0;
  final pxPerCm = heightPx / shoulderToAnkleCm;

  final shoulderWidthCm = shoulderWidthPx / pxPerCm;
  final hipWidthCm = hipWidthPx / pxPerCm;
  final bustWidthCm = shoulderWidthCm * 0.92;
  final waistWidthCm = hipWidthCm * 0.73;

  const widthToCircumference = 2.59;
  return _BodyMeasurements(
    shoulder: shoulderWidthCm * widthToCircumference,
    bust: bustWidthCm * widthToCircumference,
    waist: waistWidthCm * widthToCircumference,
    hip: hipWidthCm * widthToCircumference,
  );
}

// ──────────────────────────────────────────────── CameraSimulationView ────────

class CameraSimulationView extends StatefulWidget {
  final Function(double, double, double, double) onScanComplete;
  const CameraSimulationView({super.key, required this.onScanComplete});

  @override
  State<CameraSimulationView> createState() => _CameraSimulationViewState();
}

class _CameraSimulationViewState extends State<CameraSimulationView> {
  CameraController? _cameraController;
  bool _isPermissionGranted = false;
  bool _isInitializing = true;
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    _requestHardwarePermissions();
  }

  Future<void> _requestHardwarePermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    if (statuses[Permission.camera]!.isGranted) {
      setState(() => _isPermissionGranted = true);
      _initializeLiveCamera();
    } else {
      setState(() => _isInitializing = false);
      _showPermissionDeniedSnackBar();
    }
  }

  Future<void> _initializeLiveCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.medium,
        enableAudio: true,
      );

      await _cameraController!.initialize();
    } catch (e) {
      debugPrint("Camera initialization error: $e");
    } finally {
      if (mounted) {
        setState(() => _isInitializing = false);
      }
    }
  }

  void _triggerCaptureSequence() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;

    setState(() => _isAnalyzing = true);

    final poseDetector = PoseDetector(
      options: PoseDetectorOptions(model: PoseDetectionModel.base),
    );

    try {
      final imageFile = await _cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(imageFile.path);
      final poses = await poseDetector.processImage(inputImage);

      if (!mounted) return;

      if (poses.isEmpty) {
        setState(() => _isAnalyzing = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No body detected. Stand back so your full body is visible.'),
        ));
        return;
      }

      final measurements = _extractMeasurements(poses.first);
      if (measurements == null) {
        setState(() => _isAnalyzing = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Could not read full pose. Ensure good lighting and full body is in frame.'),
        ));
        return;
      }

      widget.onScanComplete(measurements.shoulder, measurements.bust, measurements.waist, measurements.hip);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint("Capture error: $e");
      if (mounted) setState(() => _isAnalyzing = false);
    } finally {
      await poseDetector.close();
    }
  }

  void _showPermissionDeniedSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Camera permission denied. Please enable it in system settings.'),
        action: SnackBarAction(label: 'Settings', onPressed: () => openAppSettings()),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: _kAccent)),
      );
    }

    if (!_isPermissionGranted || _cameraController == null || !_cameraController!.value.isInitialized) {
      return Scaffold(
        backgroundColor: _kBg,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.videocam_off_outlined, size: 48, color: Colors.white30),
              const SizedBox(height: 16),
              const Text('Camera feed unavailable', style: TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _requestHardwarePermissions,
                child: const Text('Grant Access Permissions'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _cameraController!.value.previewSize!.height,
                height: _cameraController!.value.previewSize!.width,
                child: CameraPreview(_cameraController!),
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: SilhouetteOverlayPainter(progress: _isAnalyzing ? 1.0 : 0.0),
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text('STAND 2–3 M BACK · FULL BODY VISIBLE', style: TextStyle(color: Colors.white70, letterSpacing: 1.2, fontSize: 10)),
                      const Icon(Icons.mic, color: Colors.green, size: 20),
                    ],
                  ),
                ),
                if (_isAnalyzing)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    color: Colors.black87,
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Detecting pose & calculating measurements...', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                        SizedBox(height: 12),
                        LinearProgressIndicator(color: _kAccent, backgroundColor: Colors.white12),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!_isAnalyzing)
                        GestureDetector(
                          onTap: _triggerCaptureSequence,
                          child: Container(
                            height: 76,
                            width: 76,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            padding: const EdgeInsets.all(6),
                            child: Container(
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────── ResultsScreen ─────────

class ResultsScreen extends StatelessWidget {
  final double shoulder, bust, waist, hip;
  final String undertone;

  const ResultsScreen({
    super.key,
    required this.shoulder,
    required this.bust,
    required this.waist,
    required this.hip,
    required this.undertone,
  });

  @override
  Widget build(BuildContext context) {
    final shape = _calculateBodyShape(bust, waist, hip);
    final info = _bodyShapeInfo[shape]!;
    final palette = _palettes[undertone] ?? _palettes['Neutral']!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Your Style Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _kAccent.withValues(alpha:0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _kAccent.withValues(alpha:0.3)),
              ),
              child: Column(
                children: [
                  Icon(info.icon, size: 52, color: _kAccent),
                  const SizedBox(height: 12),
                  Text(
                    shape,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    info.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white60, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('STYLE TIPS', style: TextStyle(color: Colors.white38, fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            ...info.tips.map((tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Icon(Icons.circle, size: 5, color: _kAccent),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(tip, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5)),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 32),
            Text(
              '${undertone.toUpperCase()} UNDERTONE PALETTE',
              style: const TextStyle(color: Colors.white38, fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.4,
              ),
              itemCount: palette.length,
              itemBuilder: (_, i) {
                final swatch = palette[i];
                return Container(
                  decoration: BoxDecoration(
                    color: swatch.color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      swatch.name,
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────── SilhouetteOverlayPainter ────────

class SilhouetteOverlayPainter extends CustomPainter {
  final double progress;
  const SilhouetteOverlayPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final guidePaint = Paint()
      ..color = _kAccent.withValues(alpha:0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Head
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy - size.height * 0.28), width: 58, height: 68),
      guidePaint,
    );

    // Torso silhouette
    final shoulderY = cy - size.height * 0.17;
    final waistY = cy + size.height * 0.04;
    final hipY = cy + size.height * 0.17;

    final torso = Path()
      ..moveTo(cx - 85, shoulderY)
      ..cubicTo(cx - 80, waistY - 20, cx - 65, waistY, cx - 55, waistY)
      ..cubicTo(cx - 68, waistY + 10, cx - 80, hipY, cx - 88, hipY)
      ..lineTo(cx + 88, hipY)
      ..cubicTo(cx + 80, hipY, cx + 68, waistY + 10, cx + 55, waistY)
      ..cubicTo(cx + 65, waistY, cx + 80, waistY - 20, cx + 85, shoulderY)
      ..close();
    canvas.drawPath(torso, guidePaint);

    // Corner guides
    final cornerPaint = Paint()
      ..color = Colors.white.withValues(alpha:0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    _drawCorner(canvas, cornerPaint, Offset(24, 52), 1, 1);
    _drawCorner(canvas, cornerPaint, Offset(size.width - 24, 52), -1, 1);
    _drawCorner(canvas, cornerPaint, Offset(24, size.height - 52), 1, -1);
    _drawCorner(canvas, cornerPaint, Offset(size.width - 24, size.height - 52), -1, -1);

    // Scanning line when analyzing
    if (progress > 0) {
      final scanY = (cy - size.height * 0.28) + size.height * 0.5 * progress;
      canvas.drawLine(
        Offset(0, scanY),
        Offset(size.width, scanY),
        Paint()
          ..color = _kAccent.withValues(alpha:0.5)
          ..strokeWidth = 1.5,
      );
    }
  }

  void _drawCorner(Canvas canvas, Paint paint, Offset origin, double xDir, double yDir) {
    const len = 22.0;
    canvas.drawLine(origin, origin + Offset(xDir * len, 0), paint);
    canvas.drawLine(origin, origin + Offset(0, yDir * len), paint);
  }

  @override
  bool shouldRepaint(SilhouetteOverlayPainter old) => old.progress != progress;
}
