import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../services/esp32_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const _bg = Color(0xFF050A14);
  static const _surface = Color(0xFF0D1626);
  static const _surfaceElevated = Color(0xFF162035);
  static const _accent = Color(0xFF00D4FF);
  static const _success = Color(0xFF30D158);
  static const _danger = Color(0xFFFF2D55);
  static const _border = Color(0xFF1E2D45);
  static const _textSec = Color(0xFF8899AA);
  static const _textDim = Color(0xFF445566);

  late TextEditingController _ipController;
  String _pingStatus = 'idle'; // idle | pinging | ok | fail
  String _testStatus = 'idle'; // idle | sending | ok | fail

  @override
  void initState() {
    super.initState();
    final provider = context.read<AppProvider>();
    _ipController = TextEditingController(text: provider.esp32Ip);
  }

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }

  Future<void> _ping() async {
    final provider = context.read<AppProvider>();
    HapticFeedback.lightImpact();
    setState(() => _pingStatus = 'pinging');
    final esp32 = Esp32Service(getIp: () => _ipController.text);
    final ok = await esp32.ping();
    provider.setDeviceConnected(ok);
    setState(() => _pingStatus = ok ? 'ok' : 'fail');
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) setState(() => _pingStatus = 'idle');
  }

  Future<void> _testSignal() async {
    final provider = context.read<AppProvider>();
    HapticFeedback.mediumImpact();
    setState(() => _testStatus = 'sending');
    final esp32 = Esp32Service(getIp: () => _ipController.text);
    final ok = await esp32.testSignal(intensity: provider.intensity);
    if (ok) {
      HapticFeedback.heavyImpact();
    } else {
      HapticFeedback.vibrate();
    }
    setState(() => _testStatus = ok ? 'ok' : 'fail');
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) setState(() => _testStatus = 'idle');
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final t = provider.t;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          children: [
            Text(
              t('settings').toUpperCase(),
              style: const TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 20),

            // Language
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _cardTitle(t('language')),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _langChip('uz', 'UZ', provider),
                      const SizedBox(width: 10),
                      _langChip('en', 'EN', provider),
                      const SizedBox(width: 10),
                      _langChip('ru', 'RU', provider),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ESP32 IP
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _cardTitle(t('esp32Ip')),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _ipController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: const TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: _surfaceElevated,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: _border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: _border),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: _accent),
                            ),
                            hintText: '192.168.4.1',
                            hintStyle: const TextStyle(color: _textDim),
                          ),
                          onChanged: (v) => provider.setEsp32Ip(v),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _pingStatus == 'pinging' ? null : _ping,
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: _surfaceElevated,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _border),
                          ),
                          child: Icon(
                            _pingStatus == 'ok' ? Icons.check_circle : _pingStatus == 'fail' ? Icons.cancel : Icons.wifi,
                            color: _pingStatus == 'ok' ? _success : _pingStatus == 'fail' ? _danger : _accent,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_pingStatus == 'ok') ...[
                    const SizedBox(height: 8),
                    Text(t('deviceConnected'), style: const TextStyle(fontFamily: 'Rajdhani', fontSize: 13, color: _success, letterSpacing: 0.5)),
                  ] else if (_pingStatus == 'fail') ...[
                    const SizedBox(height: 8),
                    Text(t('deviceDisconnected'), style: const TextStyle(fontFamily: 'Rajdhani', fontSize: 13, color: _danger, letterSpacing: 0.5)),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Signal intensity + test
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _cardTitle(t('intensity')),
                      const Spacer(),
                      Text(
                        '${provider.intensity}',
                        style: const TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: _accent,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: List.generate(5, (i) {
                      final level = i + 1;
                      final sel = provider.intensity == level;
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: i < 4 ? 8 : 0),
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              provider.setIntensity(level);
                            },
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: sel ? _accent : _border),
                                // FIXED: .withValues() instead of .withOpacity()
                                color: sel ? _accent.withValues(alpha: 0.2) : _surfaceElevated,
                              ),
                              child: Center(
                                child: Text(
                                  '$level',
                                  style: TextStyle(
                                    fontFamily: 'Rajdhani',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: sel ? _accent : _textDim,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _testStatus == 'sending' ? null : _testSignal,
                    child: Opacity(
                      opacity: _testStatus == 'sending' ? 0.5 : 1.0,
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _testStatus == 'ok' ? _success : _testStatus == 'fail' ? _danger : _accent,
                          ),
                          gradient: LinearGradient(
                            colors: _testStatus == 'ok'
                                // FIXED: .withValues() instead of .withOpacity()
                                ? [_success.withValues(alpha: 0.3), _success.withValues(alpha: 0.1)]
                                : _testStatus == 'fail'
                                    ? [_danger.withValues(alpha: 0.3), _danger.withValues(alpha: 0.1)]
                                    : [_accent.withValues(alpha: 0.3), _accent.withValues(alpha: 0.1)],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _testStatus == 'ok' ? Icons.check_circle : _testStatus == 'fail' ? Icons.cancel : Icons.send,
                              color: _testStatus == 'ok' ? _success : _testStatus == 'fail' ? _danger : _accent,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _testStatus == 'ok'
                                  ? t('signalSent')
                                  : _testStatus == 'fail'
                                      ? t('signalFailed')
                                      : _testStatus == 'sending'
                                          ? t('connecting')
                                          : t('testSignal').toUpperCase(),
                              style: TextStyle(
                                fontFamily: 'Rajdhani',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: _testStatus == 'ok' ? _success : _testStatus == 'fail' ? _danger : _accent,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // About Card - FIXED: Added 'const' to constructor
            _buildCard(
              child: const Column(
                children: [
                  Text(
                    'RDR',
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 52,
                      fontWeight: FontWeight.w700,
                      color: _accent,
                      letterSpacing: 10,
                    ),
                  ),
                  Text(
                    'Real-time Drowsiness Response',
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 13,
                      color: _textSec,
                      letterSpacing: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'v1.0.0',
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 12,
                      color: _textDim,
                      letterSpacing: 1,
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

  Widget _buildCard({required Widget child}) => Container(
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _border),
        ),
        padding: const EdgeInsets.all(20),
        child: child,
      );

  Widget _cardTitle(String label) => Row(
        children: [
          const Icon(Icons.settings_outlined, color: _accent, size: 16),
          const SizedBox(width: 8),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _textSec,
              letterSpacing: 2,
            ),
          ),
        ],
      );

  Widget _langChip(String lang, String label, AppProvider provider) {
    final sel = provider.language == lang;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        provider.setLanguage(lang);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: sel ? _accent : _border),
          // FIXED: .withValues() instead of .withOpacity()
          color: sel ? _accent.withValues(alpha: 0.2) : _surface,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: sel ? _accent : _textDim,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}