import 'package:equatable/equatable.dart';
import '../../../../core/enums/monitoring_status.dart';

class MonitoringResult extends Equatable {
  final double ear;
  final bool isEyeOpen;
  final MonitoringStatus status;

  const MonitoringResult({
    required this.ear,
    required this.isEyeOpen,
    required this.status,
  });

  @override
  List<Object?> get props => [ear, isEyeOpen, status];
}
