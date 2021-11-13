import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:speech_app/app/data/models/movimientos_detalle.dart';
import 'package:speech_app/app/helpers/http_response.dart';

class MovimientosApi {
  final Dio _dio = Dio();
  final Logger _logger = Logger();

  String link = "";
  String url;
  String ip;
  String port;
  final String http = "http://";
  String urlmethod = "/api/Services/PostDetalle";

  Future<void> _init() async {
    link = "" + url != "" ? url : http + ip + ":" + port + urlmethod;
  }

  Future<HttpResponse> create(List<movimientos_detalles> model) async {
    _init();

    String data = jsonEncode(model.map((i) => i.toMap()).toList()).toString();

    try {
      final response = await _dio.post(
        link,
        options: Options(
          headers: {
            Headers.contentLengthHeader: model.length,
            Headers.contentTypeHeader: 'application/json'
          },
        ),
        data: data,
      );

      _logger.i(response.data);
      return HttpResponse.success(response.data);
    } catch (e) {
      _logger.e(e);
      int statusCode = -1;
      String message = "unknown error";
      dynamic data;

      if (e is DioError) {
        message = e.message;

        if (e.response != null) {
          statusCode = e.response.statusCode;
          message = e.response.statusMessage;
          data = e.response.data;
        }
      }
      return HttpResponse.fail(
          statusCode: statusCode, message: message, data: data);
    }
  }
}
