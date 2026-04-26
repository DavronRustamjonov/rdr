import '../../../../core/usecases/usecase.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

class GetSettings extends UseCase<AppSettings, NoParams> {
  final SettingsRepository _repository;
  GetSettings(this._repository);

  @override
  Future<AppSettings> call(NoParams params) => _repository.load();
}
