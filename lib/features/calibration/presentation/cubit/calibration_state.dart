import 'package:equatable/equatable.dart';

sealed class CalibrationState extends Equatable {
  const CalibrationState();
}

class CalibrationIdle extends CalibrationState {
  final double threshold;
  const CalibrationIdle(this.threshold);
  @override
  List<Object?> get props => [threshold];
}

class CalibrationInProgress extends CalibrationState {
  const CalibrationInProgress();
  @override
  List<Object?> get props => [];
}

class CalibrationDone extends CalibrationState {
  final double threshold;
  const CalibrationDone(this.threshold);
  @override
  List<Object?> get props => [threshold];
}
