import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/device_repository.dart';

class TestSignalParams extends Equatable {
  final int intensity;
  const TestSignalParams(this.intensity);
  @override
  List<Object?> get props => [intensity];
}

class TestSignal extends UseCase<bool, TestSignalParams> {
  final DeviceRepository _repository;
  TestSignal(this._repository);

  @override
  Future<bool> call(TestSignalParams params) =>
      _repository.testSignal(intensity: params.intensity);
}
