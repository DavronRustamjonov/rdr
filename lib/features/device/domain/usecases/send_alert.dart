import 'package:equatable/equatable.dart';
import '../../../../core/enums/alert_mode.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/device_repository.dart';

class SendAlertParams extends Equatable {
  final AlertMode mode;
  final int intensity;
  const SendAlertParams({required this.mode, required this.intensity});
  @override
  List<Object?> get props => [mode, intensity];
}

class SendAlert extends UseCase<bool, SendAlertParams> {
  final DeviceRepository _repository;
  SendAlert(this._repository);

  @override
  Future<bool> call(SendAlertParams params) =>
      _repository.sendAlert(mode: params.mode, intensity: params.intensity);
}
