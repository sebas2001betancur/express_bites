import 'package:express_bites/domain/entities/clima.dart';

abstract interface class ClimaRepository {
  Future<Clima> actual();
}
