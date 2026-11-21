import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:express_bites/data/dtos/clima_dto.dart';
import 'package:express_bites/domain/entities/clima.dart';
import 'package:express_bites/domain/failures/falla.dart';
import 'package:express_bites/domain/repositories/clima_repository.dart';
import 'package:http/http.dart' as http;

class OpenMeteoClimaRepository implements ClimaRepository {
  OpenMeteoClimaRepository([http.Client? cliente])
      : _cliente = cliente ?? http.Client();

  final http.Client _cliente;

  // Coordenadas del campus (las mismas de la semana 07).
  static final _url = Uri.parse(
    'https://api.open-meteo.com/v1/forecast'
    '?latitude=6.17&longitude=-75.58&current=temperature_2m,precipitation',
  );

  @override
  Future<Clima> actual() async {
    try {
      final respuesta =
          await _cliente.get(_url).timeout(const Duration(seconds: 5));
      if (respuesta.statusCode != 200) {
        throw Falla('servidor-${respuesta.statusCode}');
      }
      return ClimaDto.desdeJson(
          jsonDecode(respuesta.body) as Map<String, dynamic>);
    } on Falla {
      rethrow;
    } on TimeoutException {
      throw const Falla('tiempo-agotado');
    } on SocketException {
      throw const Falla('sin-conexion');
    } on http.ClientException {
      throw const Falla('sin-conexion');
    } on FormatException {
      throw const Falla('respuesta-invalida');
    } on TypeError {
      throw const Falla('respuesta-invalida');
    } on Exception {
      throw const Falla('sin-conexion');
    }
  }
}
