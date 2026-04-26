import '../../../../core/usecases/usecase.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

class SaveSettings extends UseCase<void, AppSettings> {
  final SettingsRepository _repository;
  SaveSettings(this._repository);

  @override
  Future<void> call(AppSettings params) => _repository.save(params);
}
