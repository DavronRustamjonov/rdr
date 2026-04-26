import 'package:equatable/equatable.dart';

class AlarmConfig extends Equatable {
  final int? hour;
  final int? minute;
  final bool enabled;

  const AlarmConfig({
    this.hour,
    this.minute,
    this.enabled = false,
  });

  bool get hasTime => hour != null && minute != null;

  AlarmConfig copyWith({
    int? hour,
    int? minute,
    bool? enabled,
  }) =>
      AlarmConfig(
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
        enabled: enabled ?? this.enabled,
      );

  @override
  List<Object?> get props => [hour, minute, enabled];
}
