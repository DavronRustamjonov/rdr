import 'package:equatable/equatable.dart';
import '../../domain/entities/alarm_config.dart';

sealed class AlarmState extends Equatable {
  const AlarmState();
}

class AlarmInitial extends AlarmState {
  const AlarmInitial();
  @override
  List<Object?> get props => [];
}

class AlarmReady extends AlarmState {
  final AlarmConfig config;
  const AlarmReady(this.config);

  AlarmReady copyWith({AlarmConfig? config}) =>
      AlarmReady(config ?? this.config);

  @override
  List<Object?> get props => [config];
}

class AlarmScheduled extends AlarmState {
  final AlarmConfig config;
  const AlarmScheduled(this.config);
  @override
  List<Object?> get props => [config];
}

class AlarmFired extends AlarmState {
  final AlarmConfig config;
  const AlarmFired(this.config);
  @override
  List<Object?> get props => [config];
}
