import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../domain/usecases/auto_calibrate.dart';
import '../../domain/usecases/set_threshold.dart';
import 'calibration_state.dart';

class CalibrationCubit extends Cubit<CalibrationState> {
  final AutoCalibrate _autoCalibrate;
  final SetThreshold _setThreshold;
  final SettingsCubit _settingsCubit;

  CalibrationCubit({
    required AutoCalibrate autoCalibrate,
    required SetThreshold setThreshold,
    required SettingsCubit settingsCubit,
  })  : _autoCalibrate = autoCalibrate,
        _setThreshold = setThreshold,
        _settingsCubit = settingsCubit,
        super(CalibrationIdle(settingsCubit.state.earThreshold));

  Future<void> startAutoCalibration() async {
    emit(const CalibrationInProgress());
    final threshold = await _autoCalibrate(const NoParams());
    await _settingsCubit.setEarThreshold(threshold);
    emit(CalibrationDone(threshold));
  }

  Future<void> setManualThreshold(double value) async {
    await _setThreshold(value);
    await _settingsCubit.setEarThreshold(value);
    emit(CalibrationIdle(value));
  }

  void resetToIdle() {
    emit(CalibrationIdle(_settingsCubit.state.earThreshold));
  }
}
