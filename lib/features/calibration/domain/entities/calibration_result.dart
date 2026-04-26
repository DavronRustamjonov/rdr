import 'package:equatable/equatable.dart';

class CalibrationResult extends Equatable {
  final double threshold;
  const CalibrationResult(this.threshold);
  @override
  List<Object?> get props => [threshold];
}
