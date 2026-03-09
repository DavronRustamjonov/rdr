import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../services/esp32_service.dart';
import '../services/monitoring_service.dart';
import '../widgets/ear_bar.dart';
import '../widgets/eye_ring.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late MonitoringService _monitoringService;
  late Esp32Service _esp32Service;
  List<CameraDescription> _cameras = [];
  int _closedCount = 0;

  static const _bg = Color(0xFF050A14);
  static const _surface = Color(0xFF0D1626);
  static const _accent = Color(0xFF00D4FF);
  static const _success = Color(0xFF30D158);
  static const _warning = Color(0xFFFF6B35);
  static const _danger = Color(0xFFFF2D55);
  static const _border = Color(0xFF1E2D45);
  static const _textSec = Color(0xFF8899AA);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    final provider = context.read<AppProvider>();
    _esp32Service = Esp32Service(getIp: () => provider.esp32Ip);
    _monitoringService = MonitoringService();

    _monitoringService.onEarUpdate = (ear, isOpen) {
      if (!mounted) return;
      provider.setEarScore(ear);
      
      if (!isOpen) {
        _closedCount++;
        if (_closedCount == 1) {
          provider.setMonitoringStatus(MonitoringStatus.warning);
        } else if (_closedCount >= 2) {
          provider.setMonitoringStatus(MonitoringStatus.sleeping);
          _esp32Service.triggerAlert(
            alertMode: provider.alertMode.name,
            intensity: provider.intensity,
          );
          HapticFeedback.heavyImpact();
        }
      } else {
        _closedCount = 0;
        provider.setMonitoringStatus(MonitoringStatus.monitoring);
      }
    };
    
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
    } catch (e) {
      debugPrint("Error initializing cameras: $e");
    }
  }

  Future<void> _startMonitoring() async {
    if (_cameras.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("...")),
      );
      return;
    }

    final provider = context.read<AppProvider>();
    HapticFeedback.mediumImpact();
    
    await _monitoringService.initialize(_cameras);
    await _monitoringService.startMonitoring();
    
    provider.setIsMonitoring(true);
    provider.setMonitoringStatus(MonitoringStatus.monitoring);
  }

  Future<void> _stopMonitoring() async {
    final provider = context.read<AppProvider>();
    HapticFeedback.mediumImpact();
    
    await _monitoringService.stopMonitoring();
    provider.setIsMonitoring(false);
    provider.setMonitoringStatus(MonitoringStatus.idle);
    _closedCount = 0;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _monitoringService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final t = provider.t;
    final status = provider.monitoringStatus;
    final isMonitoring = provider.isMonitoring;
    final ear = provider.earScore;

    final statusColor = status == MonitoringStatus.sleeping
        ? _danger
        : status == MonitoringStatus.warning
            ? _warning
            : status == MonitoringStatus.monitoring
                ? _success
                : const Color(0xFF445566);

    final statusLabel = status == MonitoringStatus.sleeping
        ? t('asleep')
        : status == MonitoringStatus.warning
            ? t('drowsy')
            : status == MonitoringStatus.monitoring
                ? t('awake')
                : '—';

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(provider, t),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    EyeRing(
                      status: isMonitoring ? status : MonitoringStatus.idle,
                    ),
                    const SizedBox(height: 20),
                    _buildStatusBlock(statusLabel, statusColor, status, t, isMonitoring),
                    if (isMonitoring) ...[
                      const SizedBox(height: 20),
                      EarBar(value: ear, threshold: provider.earThreshold, t: t),
                    ],
                    const SizedBox(height: 28),
                    _buildMainButton(isMonitoring, t),
                    const SizedBox(height: 16),
                    _buildMonitorPill(isMonitoring, t),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppProvider provider, String Function(String) t) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'RDR',
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: _accent,
              letterSpacing: 6,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: provider.deviceConnected ? _success : _danger,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  provider.deviceConnected ? t('deviceConnected') : t('deviceDisconnected'),
                  style: const TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _textSec,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBlock(
    String label,
    Color color,
    MonitoringStatus status,
    String Function(String) t,
    bool isMonitoring,
  ) {
    return SizedBox(
      height: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isMonitoring ? label : '—',
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 4,
            ),
          ),
          if (isMonitoring && status == MonitoringStatus.sleeping)
            Text(
  t('warning'),
  textAlign: TextAlign.center,
  maxLines: 1, // Bu juda qisqa va muhim so'z bo'lgani uchun bir qatorda bo'lgani ma'qul
  overflow: TextOverflow.ellipsis,
  style: const TextStyle(
    fontFamily: 'Rajdhani',
    fontSize: 8, // 15 dan 14 ga tushirildi (8px lik xatoni yo'qotish uchun)
    fontWeight: FontWeight.w600, // Danger yozuvi qalinroq bo'lishi kerak
    color: _danger,
    letterSpacing: 1.2, // Rajdhani shriftida kengaytirilgan harflar zamonaviy ko'rinadi
  ),
),
          if (isMonitoring && status == MonitoringStatus.warning)
            Text(
  t('eyesClosed_warn'),
  textAlign: TextAlign.center, // Matnni markazga tekislaydi
  maxLines: 2, // Matn juda uzun bo'lsa, 2 qatordan oshmaydi
  overflow: TextOverflow.ellipsis, // Agar 2 qatordan ham oshsa, oxiriga "..." qo'yadi
  style: const TextStyle(
    fontFamily: 'Rajdhani',
    fontSize: 8, // 15 dan 14 ga biroz kichraytirildi (overflow oldini olish uchun)
    fontWeight: FontWeight.w500, // Matn yaxshiroq o'qilishi uchun qalinlik qo'shildi
    color: _warning,
    letterSpacing: 0.5,
    height: 1.2, // Qatorlar orasidagi masofa
  ),
),
        ],
      ),
    );
  }

  Widget _buildMainButton(bool isMonitoring, String Function(String) t) {
    return GestureDetector(
      onTap: isMonitoring ? _stopMonitoring : _startMonitoring,
      child: Container(
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isMonitoring ? _danger : _accent,
          ),
          gradient: LinearGradient(
            colors: isMonitoring
                ? [
                    _danger.withValues(alpha: 0.25), 
                    _danger.withValues(alpha: 0.08)
                  ]
                : [
                    _accent.withValues(alpha: 0.25), 
                    _accent.withValues(alpha: 0.08)
                  ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isMonitoring ? Icons.stop_circle_outlined : Icons.play_circle_outline,
              color: isMonitoring ? _danger : _accent,
              size: 26,
            ),
            const SizedBox(width: 10),
            Text(
              (isMonitoring ? t('stopMonitoring') : t('startMonitoring')).toUpperCase(),
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: isMonitoring ? _danger : _accent,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonitorPill(bool isMonitoring, String Function(String) t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isMonitoring ? _accent : _border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isMonitoring ? _accent : const Color(0xFF445566),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            isMonitoring ? t('monitoringActive') : t('monitoringIdle'),
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isMonitoring ? _accent : const Color(0xFF445566),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}