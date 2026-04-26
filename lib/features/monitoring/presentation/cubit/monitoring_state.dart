import 'package:equatable/equatable.dart';
import '../../../../core/enums/monitoring_status.dart';

sealed class MonitoringState extends Equatable {
  const MonitoringState();
}

class MonitoringInitial extends MonitoringState {
  const MonitoringInitial();
  @override
  List<Object?> get props => [];
}

class MonitoringIdle extends MonitoringState {
  const MonitoringIdle();
  @override
  List<Object?> get props => [];
}

class MonitoringActive extends MonitoringState {
  final double earScore;
  final MonitoringStatus status;

  const MonitoringActive({
    required this.earScore,
    required this.status,
  });

  MonitoringActive copyWith({double? earScore, MonitoringStatus? status}) =>
      MonitoringActive(
        earScore: earScore ?? this.earScore,
        status: status ?? this.status,
      );

  @override
  List<Object?> get props => [earScore, status];
}
