import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:network/Screens/media_extraction_hub.dart';
import 'package:network/Utils/routeNames.dart';

class CaptureVideoScreen extends StatefulWidget {
  const CaptureVideoScreen({super.key});

  @override
  State<CaptureVideoScreen> createState() => _CaptureVideoScreenState();
}

class _CaptureVideoScreenState extends State<CaptureVideoScreen>
    with SingleTickerProviderStateMixin {
  // ── Colors ──────────────────────────────────────────────────────────────────
  static const Color _red = Color(0xFFE53935);
  static const Color _blue = Color(0xFF3D3DF5);
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _dark = Color(0xFF1A1A1A);
  static const Color _cardBg = Color(0xCC1C1C2E);

  int _selectedZoom = 1; // 0 = 0.5x, 1 = 1x, 2 = 2x
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _blinkAnimation = Tween<double>(begin: 1.0, end: 0.2).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Camera preview placeholder ──────────────────────────────────────
          _cameraPreview(),

          // ── Top bar ─────────────────────────────────────────────────────────
          Positioned(top: 52, left: 16, right: 16, child: _topBar()),

          // ── Right side controls ─────────────────────────────────────────────
          Positioned(right: 0, top: 0, bottom: 0, child: _sideControls()),

          // ── Stream info card ────────────────────────────────────────────────
          Positioned(bottom: 210, left: 16, child: _streamInfoCard()),

          // ── Bottom controls ─────────────────────────────────────────────────
          Positioned(bottom: 0, left: 0, right: 0, child: _bottomControls()),
        ],
      ),
    );
  }

  // ── Camera preview ─────────────────────────────────────────────────────────

  Widget _cameraPreview() {
    return Container(
      color: const Color(0xFF0A0F1A),
      child: const Center(
        child: Icon(Icons.landscape, color: Color(0xFF111E2A), size: 200),
      ),
    );
  }

  // ── Top bar ────────────────────────────────────────────────────────────────

  Widget _topBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          // Blinking red dot
          FadeTransition(
            opacity: _blinkAnimation,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: _red,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'REC',
            style: TextStyle(
              color: _red,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            '00 : 12 : 45',
            style: TextStyle(
              color: _white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const Spacer(),
          // Battery indicator
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: Row(
              children: [
                Container(
                  width: 22,
                  height: 11,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.white.withOpacity(0.5), width: 1.2),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(1.5),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.84,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  '84%',
                  style: TextStyle(
                    color: _white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Side controls ──────────────────────────────────────────────────────────

  Widget _sideControls() {
    return Center(
      child: Container(
        width: 62,
        padding: const EdgeInsets.symmetric(vertical: 12),
        margin: const EdgeInsets.only(right: 0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22),
            bottomLeft: Radius.circular(22),
          ),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _sideBtn(Icons.flash_on_outlined, active: false),
            const SizedBox(height: 18),
            _sideBtn(Icons.cameraswitch_outlined, active: false),
            const SizedBox(height: 18),
            _sideBtnActive(), // grid / active blue
            const SizedBox(height: 18),
            _sideBtn(Icons.tune, active: false),
          ],
        ),
      ),
    );
  }

  Widget _sideBtn(IconData icon, {required bool active}) {
    return SizedBox(
      width: 42,
      height: 42,
      child: Icon(icon, color: Colors.white.withOpacity(0.85), size: 22),
    );
  }

  Widget _sideBtnActive() {
    return Container(
      width: 42,
      height: 42,
      decoration: const BoxDecoration(
        color: _blue,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.grid_on_rounded, color: _white, size: 22),
    );
  }

  // ── Stream info card ───────────────────────────────────────────────────────

  Widget _streamInfoCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 20, 14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded, color: _blue, size: 15),
              const SizedBox(width: 6),
              Text(
                'ACTIVE STREAM',
                style: TextStyle(
                  color: _blue,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            '1080p | 60fps | HEVC',
            style: TextStyle(
              color: _white,
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 110,
            height: 3,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.55,
              child: Container(
                decoration: BoxDecoration(
                  color: _blue,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom controls ────────────────────────────────────────────────────────

  Widget _bottomControls() {
    return Container(
      padding: const EdgeInsets.only(bottom: 36, top: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.85),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pause | Stop | Snapshot
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _circleBtn(Icons.pause_rounded, size: 52, bg: _dark),
              const SizedBox(width: 24),
              _stopBtn(),
              const SizedBox(width: 24),
              _circleBtn(Icons.camera_alt_outlined, size: 52, bg: _dark),
            ],
          ),
          const SizedBox(height: 22),
          // Zoom selector
          _zoomSelector(),
          const SizedBox(height: 16),
          // Home indicator line
          Center(
            child: Container(
              width: 120,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon,
      {required double size, required Color bg}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: _white, size: size * 0.45),
    );
  }

  Widget _stopBtn() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateColor.transparent
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ExtractionHubScreen(),));
      },
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: _red,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: _red.withOpacity(0.45),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.25), width: 2),
        ),
        child: const Icon(Icons.stop_rounded, color: _white, size: 32),
      ),
    );
  }

  Widget _zoomSelector() {
    final zooms = ['0.5x', '1x', '2x'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(zooms.length, (i) {
        final isSelected = _selectedZoom == i;
        return GestureDetector(
          onTap: () => setState(() => _selectedZoom = i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? _blue : Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? _blue
                    : Colors.white.withOpacity(0.15),
              ),
            ),
            child: Text(
              zooms[i],
              style: TextStyle(
                color: _white,
                fontSize: 13,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
        );
      }),
    );
  }
}
