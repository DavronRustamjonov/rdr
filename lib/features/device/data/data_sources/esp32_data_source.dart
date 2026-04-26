import 'package:dio/dio.dart';

abstract class Esp32DataSource {
  Future<bool> ping();
  Future<bool> sendAction({required String mode, required int power});
}

class Esp32DataSourceImpl implements Esp32DataSource {
  final Dio _dio;
  final String Function() getIp;

  Esp32DataSourceImpl({required this.getIp})
      : _dio = Dio(BaseOptions(receiveTimeout: const Duration(milliseconds: 800)));

  @override
  Future<bool> ping() async {
    try {
      final res = await _dio.get('http://${getIp()}/ping');
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> sendAction({required String mode, required int power}) async {
    try {
      final res = await _dio.get(
        'http://${getIp()}/action',
        queryParameters: {'mode': mode, 'power': power},
        options: Options(receiveTimeout: const Duration(milliseconds: 500)),
      );
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
