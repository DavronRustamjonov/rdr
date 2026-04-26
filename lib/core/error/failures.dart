import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);
  @override
  List<Object?> get props => [message];
}

class DeviceFailure extends Failure {
  const DeviceFailure([super.message = 'Device unreachable']);
}

class CameraFailure extends Failure {
  const CameraFailure([super.message = 'Camera error']);
}

class StorageFailure extends Failure {
  const StorageFailure([super.message = 'Storage error']);
}
