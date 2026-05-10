import 'package:flutter/material.dart';

const kBg = Color(0xFF0D0F14);
const kCard = Color(0xFF161A23);
const kCardBorder = Color(0xFF1E2330);
const kBlue = Color(0xFF4A9EFF);
const kBlueLight = Color(0xFF6BB3FF);
const kGreen = Color(0xFF2DD4BF);
const kRed = Color(0xFFFF6B6B);
const kTextPrimary = Color(0xFFFFFFFF);
const kTextSecondary = Color(0xFF8A93A8);
const kTextMuted = Color(0xFF4E5668);
const kStableBadge = Color(0xFF1A3A2A);
const kStableText = Color(0xFF2DD4BF);
const kHevcBadge = Color(0xFF1A2E4A);
const kHevcText = Color(0xFF4A9EFF);

// ─── Screen ───────────────────────────────────────────────────────────────────

class PerformanceAnalyticsScreen extends StatefulWidget {
  const PerformanceAnalyticsScreen({super.key});

  @override
  State<PerformanceAnalyticsScreen> createState() =>
      _PerformanceAnalyticsScreenState();
}

class _PerformanceAnalyticsScreenState extends State<PerformanceAnalyticsScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 2; // Insights tab active
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: FadeTransition(
        opacity: _fadeIn,
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEncodingCard(),
                      const SizedBox(height: 12),
                      _buildMetricsRow(),
                      const SizedBox(height: 12),
                      _buildStorageCard(),
                      const SizedBox(height: 12),
                      _buildHevcNote(),
                      const SizedBox(height: 20),
                      _buildExportButton(),
                      const SizedBox(height: 16),
                      _buildSessionId(),
                    ],
                  ),
                ),
              ),
              _buildBottomNav(),
            ],
          ),
        ),
      ),
    );
  }

  // ─── App Bar ────────────────────────────────────────────────────────────────

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _iconBtn(Icons.chevron_left),
          const Expanded(
            child: Column(
              children: [
                Text(
                  'Performance Analytics',
                  style: TextStyle(
                    color: kTextPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _LiveDot(),
                    SizedBox(width: 6),
                    Text(
                      'LIVE MONITORING',
                      style: TextStyle(
                        color: kBlue,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _iconBtn(Icons.ios_share_outlined),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kCardBorder),
      ),
      child: Icon(icon, color: kTextSecondary, size: 18),
    );
  }

  // ─── Encoding Card ──────────────────────────────────────────────────────────

  Widget _buildEncodingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Real-time Encoding Performance',
                style: TextStyle(
                  color: kTextSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              _badge('STABLE', kStableBadge, kStableText),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Text(
                '5,420',
                style: TextStyle(
                  color: kTextPrimary,
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: 6),
              Text('kbps', style: TextStyle(color: kTextMuted, fontSize: 12)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: kGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '+2.4%',
                  style: TextStyle(
                    color: kGreen,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 80,
            child: CustomPaint(
              painter: _WaveChartPainter(),
              size: const Size(double.infinity, 80),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['5M', '4M', '3M', '2M', '1M', 'NOW']
                .map(
                  (t) => Text(
                    t,
                    style: const TextStyle(color: kTextMuted, fontSize: 9),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  // ─── Metrics Row ────────────────────────────────────────────────────────────

  Widget _buildMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: _metricCard(
            label: 'CPU USAGE',
            value: '42%',
            sub: '↑ High Load',
            subColor: kRed,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _metricCard(
            label: 'MEMORY',
            value: '256',
            valueSuffix: 'MB',
            sub: '✓ Optimal',
            subColor: kGreen,
          ),
        ),
      ],
    );
  }

  Widget _metricCard({
    required String label,
    required String value,
    String? valueSuffix,
    required String sub,
    required Color subColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: kTextMuted,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: kTextPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                ),
              ),
              if (valueSuffix != null) ...[
                const SizedBox(width: 3),
                Text(
                  valueSuffix,
                  style: const TextStyle(color: kTextMuted, fontSize: 11),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Text(
            sub,
            style: TextStyle(
              color: subColor,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Storage Card ───────────────────────────────────────────────────────────

  Widget _buildStorageCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Storage Efficiency',
                style: TextStyle(
                  color: kTextSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              _badge('HEVC Optimized', kHevcBadge, kHevcText),
            ],
          ),
          const SizedBox(height: 20),
          // Bar comparison
          Stack(
            alignment: Alignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // MP4 bar
                  Expanded(
                    flex: 55,
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2F3D),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'MP4',
                          style: TextStyle(
                            color: kTextSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Text(
                          '124 MB',
                          style: TextStyle(color: kTextMuted, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // HEVC bar (shorter — 30% less)
                  Expanded(
                    flex: 45,
                    child: Column(
                      children: [
                        Container(
                          height: 70,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [kBlueLight, kBlue],
                            ),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'HEVC',
                          style: TextStyle(
                            color: kBlue,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Text(
                          '86.8 MB',
                          style: TextStyle(color: kTextMuted, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // -30% badge floating between bars
              Positioned(
                bottom: 42,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: kBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: kGreen.withOpacity(0.5)),
                    ),
                    child: const Text(
                      '🔽 -30%',
                      style: TextStyle(
                        color: kGreen,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── HEVC Note ──────────────────────────────────────────────────────────────

  Widget _buildHevcNote() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: RichText(
        text: const TextSpan(
          style: TextStyle(fontSize: 11, color: kTextMuted, height: 1.5),
          children: [
            TextSpan(
              text: 'HEVC (High Efficiency Video Coding) ',
              style: TextStyle(color: kTextSecondary),
            ),
            TextSpan(
              text:
                  'provides comparable video quality at approximately half the bitrate.',
            ),
          ],
        ),
      ),
    );
  }

  // ─── Export Button ──────────────────────────────────────────────────────────

  Widget _buildExportButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2979FF), Color(0xFF1565C0)],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: kBlue.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextButton.icon(
          onPressed: () {},
          icon: const Icon(
            Icons.download_rounded,
            color: kTextPrimary,
            size: 18,
          ),
          label: const Text(
            'Export Performance Logs',
            style: TextStyle(
              color: kTextPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  // ─── Session ID ─────────────────────────────────────────────────────────────

  Widget _buildSessionId() {
    return Center(
      child: Text(
        'SESSION ID: FLTK-REC-9023',
        style: TextStyle(color: kTextMuted, fontSize: 10, letterSpacing: 1.2),
      ),
    );
  }

  // ─── Bottom Nav ─────────────────────────────────────────────────────────────

  Widget _buildBottomNav() {
    final items = [
      _NavItem(icon: Icons.home_outlined, label: 'Home'),
      _NavItem(icon: Icons.video_library_outlined, label: 'Library'),
      _NavItem(icon: Icons.bar_chart_rounded, label: 'Insights'),
      _NavItem(icon: Icons.settings_outlined, label: 'Settings'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: kCard,
        border: Border(top: BorderSide(color: kCardBorder)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final active = i == _currentIndex;
          return GestureDetector(
            onTap: () => setState(() => _currentIndex = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: active ? kBlue.withOpacity(0.12) : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    items[i].icon,
                    color: active ? kBlue : kTextMuted,
                    size: 20,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    items[i].label,
                    style: TextStyle(
                      color: active ? kBlue : kTextMuted,
                      fontSize: 10,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: kCard,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: kCardBorder),
    );
  }

  Widget _badge(String label, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ─── Live Dot ─────────────────────────────────────────────────────────────────

class _LiveDot extends StatefulWidget {
  const _LiveDot();

  @override
  State<_LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<_LiveDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _scale = Tween(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(color: kBlue, shape: BoxShape.circle),
      ),
    );
  }
}

// ─── Wave Chart Painter ───────────────────────────────────────────────────────

class _WaveChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final points = _generatePoints(size);

    // Gradient fill
    final fillPath = Path()..moveTo(0, size.height);
    for (final p in points) {
      fillPath.lineTo(p.dx, p.dy);
    }
    fillPath
      ..lineTo(size.width, size.height)
      ..close();

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [kBlue.withOpacity(0.25), kBlue.withOpacity(0.0)],
    );
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = gradient.createShader(
          Rect.fromLTWH(0, 0, size.width, size.height),
        ),
    );

    // Line
    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final curr = points[i];
      final cx = (prev.dx + curr.dx) / 2;
      linePath.cubicTo(cx, prev.dy, cx, curr.dy, curr.dx, curr.dy);
    }

    canvas.drawPath(
      linePath,
      Paint()
        ..color = kBlue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );

    // Dot at the last point
    final last = points.last;
    canvas.drawCircle(last, 4, Paint()..color = kBlue);
    canvas.drawCircle(
      last,
      4,
      Paint()
        ..color = kBg
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  List<Offset> _generatePoints(Size size) {
    // Rough data mimicking the screenshot wave
    final rawY = [0.75, 0.80, 0.65, 0.70, 0.50, 0.30, 0.45, 0.20, 0.35, 0.15];
    final count = rawY.length;
    return List.generate(count, (i) {
      final x = size.width * i / (count - 1);
      final y = size.height * rawY[i];
      return Offset(x, y);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Nav Item Model ──────────────────────────────────────────────────────────

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
