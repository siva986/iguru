import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:iguru/const/apis.dart';

enum Api {
  post(api: "POST"),
  get(api: "GET"),
  delete(api: "DELETE"),
  put(api: "PUT");

  final String api;
  const Api({required this.api});
}

class ApiHelper {
  String endpoint;
  Map<String, dynamic>? parms;
  bool? enableLog = true;
  bool? showToast = true;

  ApiHelper(
    this.endpoint, {
    this.parms = const {},
    this.enableLog,
    this.showToast,
  });
  Future post() {
    return request(api: Api.post);
  }

  Future get() {
    return request(api: Api.get);
  }

  Future delete() {
    return request(api: Api.delete);
  }

  Future put() {
    return request(api: Api.put);
  }

  Future request({required Api api}) {
    String url = baseUrl;

    url = url + endpoint;
    log('${api.api}  >>>>>>   ${(url)}');
    http.Request request = http.Request(api.api, Uri.parse(url));

    log('parms>>>>>>  ${jsonEncode(parms)}');

    request.body = jsonEncode(parms);
    return request.send().then((value) {
      return value.stream.bytesToString().then((byte) {
        log('>>>>>> StatusCode ${value.statusCode}');
        log('>>>>>> Responce $byte');
        switch (value.statusCode) {
          case 200 || 201:
            return jsonDecode(byte);
          default:
            return Future.error(
              {
                "status": value.statusCode,
                "error": jsonDecode(byte)?['error'] ?? "error",
              },
            );
        }
      });
    }).onError((error, stackTrace) {
      return AppException.handleException(error, showToast: showToast ?? true);
    });
  }
}

class AppException extends ApiHelper {
  static Future handleException(error, {bool showToast = true}) {
    log("Throw>>>>>>  $error");
    if (error is SocketException) {
      Future.error("No Internet Connection");
    } else if (error is http.ClientException) {
      Future.error("No Internet Connection");
    } else if (error['status'] == 404 && {'jwt expired', 'unauthorized Token', 'invalid signature'}.contains(error['error'])) {
      Future.error("JWT expired");
    } else {
      Future.error(error);
    }

    return Future.error(error);
  }

  AppException(super.endpoint);
}
