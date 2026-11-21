import 'package:express_bites/domain/entities/clima.dart';

abstract final class ClimaDto {
  static Clima desdeJson(Map<String, dynamic> json) {
    final actual = json['current'] as Map<String, dynamic>;
    return Clima(
      temperatura: (actual['temperature_2m'] as num).toDouble(),
      lluvia: (actual['precipitation'] as num).toDouble(),
    );
  }
}
