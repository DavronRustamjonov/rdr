import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../data_sources/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _dataSource;
  AppSettings _current = const AppSettings();

  SettingsRepositoryImpl(this._dataSource);

  @override
  AppSettings get current => _current;

  @override
  Future<AppSettings> load() async {
    _current = await _dataSource.load();
    return _current;
  }

  @override
  Future<void> save(AppSettings settings) async {
    _current = settings;
    await _dataSource.save(settings);
  }
}
