import '../../../../core/usecases/usecase.dart';
import '../repositories/device_repository.dart';

class PingDevice extends UseCase<bool, NoParams> {
  final DeviceRepository _repository;
  PingDevice(this._repository);

  @override
  Future<bool> call(NoParams params) => _repository.ping();
}
