import 'package:flutter/material.dart';
class ExtractionHubScreen extends StatefulWidget {
  const ExtractionHubScreen({super.key});
  @override
  State<ExtractionHubScreen> createState() => _ExtractionHubScreenState();
}

class _ExtractionHubScreenState extends State<ExtractionHubScreen>
    with SingleTickerProviderStateMixin {
  bool _noiseEnabled = false;
  int _audioTab = 0;
  int _videoTab = 0;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  static const _bg      = Color(0xFF0B1120);
  static const _surface = Color(0xFF111827);
  static const _border  = Color(0xFF1C2A3A);
  static const _blue    = Color(0xFF2979FF);
  static const _cyan    = Color(0xFF29C6F7);
  static const _segBg   = Color(0xFF0D1520);
  static const _segSel  = Color(0xFF1A2640);
  static const _grey    = Color(0xFF5A6A7A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(children: [
          _topBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _summaryCard(),
                  const SizedBox(height: 12),
                  _noiseCard(),
                  const SizedBox(height: 20),
                  _label('Extract Audio'),
                  const SizedBox(height: 10),
                  _audioCard(),
                  const SizedBox(height: 20),
                  _label('Export Video'),
                  const SizedBox(height: 10),
                  _videoCard(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  // TOP BAR
  Widget _topBar() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    child: Row(children: [
      IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      const Expanded(
        child: Text('Extraction Hub',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
      ),
      TextButton(
        onPressed: () {},
        child: const Text('Discard',
            style: TextStyle(color: Color(0xFFE05050), fontSize: 15, fontWeight: FontWeight.w500)),
      ),
    ]),
  );

  // SUMMARY CARD
  Widget _summaryCard() => Container(
    decoration: BoxDecoration(
      color: _surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: _border),
    ),
    clipBehavior: Clip.hardEdge,
    child: Column(children: [
      // thumbnail
      Container(
        height: 175,
        color: const Color(0xFF0A121E),
        child: Center(child: _phoneMockup()),
      ),
      // info
      Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: const [
                Text('Screen Recording_001',
                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                SizedBox(width: 6),
                Icon(Icons.info_outline, size: 16, color: _grey),
              ]),
              const SizedBox(height: 4),
              const Text('Today at 2:45 PM', style: TextStyle(color: _grey, fontSize: 12.5)),
              const Text('05:24  |  142 MB', style: TextStyle(color: _grey, fontSize: 12.5)),
            ]),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: _blue,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 0,
            ),
            child: const Text('Preview',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14.5)),
          ),
        ]),
      ),
    ]),
  );

  Widget _phoneMockup() => Container(
    width: 132,
    height: 155,
    decoration: BoxDecoration(
      color: const Color(0xFF182030),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFF243040), width: 2),
    ),
    clipBehavior: Clip.hardEdge,
    child: Column(children: [
      Container(
        height: 20,
        color: const Color(0xFF141E2E),
        alignment: Alignment.center,
        child: const Text('Notifications', style: TextStyle(color: Color(0xFF3A4A58), fontSize: 8)),
      ),
      Expanded(
        child: Container(
          color: const Color(0xFFAABDB6),
          padding: const EdgeInsets.all(9),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _bar(double.infinity, 7, Colors.white, 0.75),
            const SizedBox(height: 5),
            _bar(75, 5.5, Colors.white, 0.55),
            const SizedBox(height: 3),
            _bar(55, 5.5, Colors.white, 0.55),
            const SizedBox(height: 10),
            Row(children: [
              _bar(28, 4, const Color(0xFFE09030), 1),
              Container(width: 8, height: 8,
                  decoration: const BoxDecoration(color: Color(0xFFE09030), shape: BoxShape.circle)),
              Expanded(child: _bar(double.infinity, 4, Colors.white, 0.4)),
            ]),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.88),
                    borderRadius: BorderRadius.circular(12)),
                child: const Text('tap now',
                    style: TextStyle(color: Color(0xFF111111), fontSize: 7, fontWeight: FontWeight.w700)),
              ),
            ),
          ]),
        ),
      ),
    ]),
  );

  Widget _bar(double w, double h, Color c, double o) => Container(
    width: w, height: h,
    decoration: BoxDecoration(color: c.withOpacity(o), borderRadius: BorderRadius.circular(3)),
  );

  // NOISE CARD
  Widget _noiseCard() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    decoration: BoxDecoration(
      color: _surface,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: _border),
    ),
    child: Row(children: [
      Container(
        width: 46, height: 46,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF0B1E38),
          border: Border.all(color: _blue.withOpacity(0.55), width: 1.5),
        ),
        child: const Icon(Icons.graphic_eq, color: _blue, size: 22),
      ),
      const SizedBox(width: 13),
      const Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Remove Background Noise',
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
          SizedBox(height: 2),
          Text('AI-powered reduction for clarity', style: TextStyle(color: _grey, fontSize: 12)),
        ]),
      ),
      Switch(
        value: _noiseEnabled,
        onChanged: (v) => setState(() => _noiseEnabled = v),
        activeColor: Colors.white,
        activeTrackColor: _blue,
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: const Color(0xFF253040),
      ),
    ]),
  );

  // SECTION LABEL
  Widget _label(String t) => Text(t,
      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700));

  // AUDIO CARD
  Widget _audioCard() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: _surface,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: _border),
    ),
    child: Column(children: [
      _tabs(['MP3', 'WAV'], _audioTab, (i) => setState(() => _audioTab = i)),
      const SizedBox(height: 14),
      _progressRow('Transcoding...', 0.68, _blue),
      const SizedBox(height: 14),
      _btn(Icons.download_rounded, 'Save Audio to Library', _blue, Colors.white),
    ]),
  );

  // VIDEO CARD
  Widget _videoCard() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: _surface,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: _border),
    ),
    child: Column(children: [
      _tabs(['MP4 (H.264)', 'MKV'], _videoTab, (i) => setState(() => _videoTab = i)),
      const SizedBox(height: 14),
      _progressRow('Ready to Export', 0.0, _cyan),
      const SizedBox(height: 14),
      _btn(Icons.video_file_outlined, 'Export High Quality',
          const Color(0xFF182030), Colors.white70, border: _border),
    ]),
  );

  // segmented tabs
  Widget _tabs(List<String> labels, int sel, ValueChanged<int> onTap) => Container(
    height: 44,
    decoration: BoxDecoration(color: _segBg, borderRadius: BorderRadius.circular(12)),
    child: Row(
      children: List.generate(labels.length, (i) {
        final active = i == sel;
        return Expanded(
          child: GestureDetector(
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.all(4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? _segSel : Colors.transparent,
                borderRadius: BorderRadius.circular(9),
                border: active ? Border.all(color: _blue.withOpacity(0.35)) : null,
              ),
              child: Text(labels[i],
                  style: TextStyle(
                      color: active ? Colors.white : _grey,
                      fontSize: 13.5,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w400)),
            ),
          ),
        );
      }),
    ),
  );

  // progress bar
  Widget _progressRow(String label, double val, Color color) => Column(children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(color: _grey, fontSize: 12.5)),
      Text('${(val * 100).toInt()}%',
          style: TextStyle(
              color: val > 0 ? Colors.white : _grey,
              fontSize: 12.5,
              fontWeight: FontWeight.w600)),
    ]),
    const SizedBox(height: 7),
    ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: LinearProgressIndicator(
        value: val, minHeight: 5,
        backgroundColor: const Color(0xFF182030),
        valueColor: AlwaysStoppedAnimation(color),
      ),
    ),
  ]);

  // action button
  Widget _btn(IconData icon, String label, Color bg, Color textColor,
      {Color border = Colors.transparent}) =>
      SizedBox(
        width: double.infinity, height: 50,
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(icon, size: 18, color: textColor),
          label: Text(label,
              style: TextStyle(color: textColor, fontSize: 14.5, fontWeight: FontWeight.w600)),
          style: ElevatedButton.styleFrom(
            backgroundColor: bg, elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
              side: BorderSide(color: border),
            ),
          ),
        ),
      );
}