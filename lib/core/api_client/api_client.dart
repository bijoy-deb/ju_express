import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';


import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import '../../config/app_config.dart';
import '../../src/utils/global.dart';
import '../error/error_message.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

enum Method { POST, GET, PUT, DELETE, PATCH }

class ApiClient {
  var client = http.Client();
  String url = AppConfig.shared.baseURL;

  Map<String, String> header1() => {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      };
  Map<String, String> header2() => {
        "Accept": "application/json",
        "Content-Type": "application/json",
        //"Authorization": "Bearer ${accessToken.$}"
      };

  void close() {
    client.close();
  }

  Future<void> request({
    String url = "",
    Method method = Method.GET,
    Map<String, String>? header,
    var body,
    required Function(http.Response response) onSuccess,
    required Function(ErrorMessage error) onError,
  }) async {
    if (url.isEmpty) {
      url = this.url;
    }
    header ??= header1();
    try {
      http.Response? response;
      if (method == Method.POST) {
        client.close();
        client = http.Client();
        response =
            await client.post(Uri.parse(url), body: body, headers: header);
      } else if (method == Method.DELETE) {
        response = await client.delete(Uri.parse(url), headers: header);
      } else if (method == Method.PATCH) {
        response =
            await client.patch(Uri.parse(url), headers: header, body: body);
      } else {
        response = await client.get(Uri.parse(url), headers: header);
      }
      showData(
          url: url,
          response: response.body,
          body: body,
          method: method,
          statusCode: response.statusCode,
          header: header);
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        onSuccess(response);
      } else {
        log("response ${response.body}");

        onError(ErrorMessage(
            message:
                AppLocalizations.of(Globals.context!)!.something_went_wrong,
            errorType: ErrorType.ERROR));
      }
    } on TimeoutException {
      log("TimeoutException");
      client.close();

      onError(ErrorMessage(
          errorType: ErrorType.TIMEOUT,
          message: AppLocalizations.of(Globals.context!)!.connection_timeout));
    } on SocketException {
      log("SocketException");
      client.close();
      onError(ErrorMessage(
          errorType: ErrorType.NO_INTERNET,
          message: AppLocalizations.of(Globals.context!)!.no_internet));
    } catch (e) {
      client.close();
      log("Error: $e");
      onError(ErrorMessage(
          errorType: ErrorType.ERROR,
          message:
              AppLocalizations.of(Globals.context!)!.something_went_wrong));
    }
  }

  Future requestWithFile(
      {required String url,
      Map<String, String>? body,
      List<String>? fileKey,
      Map<String, String>? header,
      List<File>? files,
      Method method = Method.POST,
      required Function onSuccess,
      required Function onError,
      bool enableShowError = true,
      bool withAuthorization = true}) async {
    header ??= header1();
    var result;
    var uri = Uri.parse(url);
    http.MultipartRequest? request;
    if (method == Method.POST) {
      request = http.MultipartRequest("POST", uri)
        ..fields.addAll(body!)
        ..headers.addAll(withAuthorization ? header : header2());
    } else if (method == Method.PATCH) {
      request = http.MultipartRequest("PATCH", uri)
        ..fields.addAll(body!)
        ..headers.addAll(withAuthorization ? header : header2());
    } else if (method == Method.PATCH) {
      request = http.MultipartRequest("PATCH", uri)
        ..headers.addAll(withAuthorization ? header : header2())
        ..fields.addAll(body!);
    }

    for (int i = 0; i < fileKey!.length; i++) {
      var stream = http.ByteStream(files![i].openRead().cast());
      var length = await files[i].length();
      var multipartFile = http.MultipartFile(fileKey[i], stream, length,
          filename: basename(files[i].path));
      request!.files.add(multipartFile);
    }
    http.StreamedResponse? response;
    try {
      response = await request!.send();
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        await response.stream.transform(utf8.decoder).listen((value) {
          result = value;
        });
        showData(
            body: body,
            method: method,
            response: result,
            statusCode: response.statusCode,
            url: url,
            header: withAuthorization ? header : header2());
        var data = json.decode(result);
        onSuccess(data);
      } else {
        log("response ${result.body}");

        onError(ErrorMessage(
            message:
                AppLocalizations.of(Globals.context!)!.something_went_wrong,
            errorType: ErrorType.ERROR));
      }
    } on TimeoutException {
      log("TimeoutException");
      client.close();

      onError(ErrorMessage(
          errorType: ErrorType.TIMEOUT,
          message: AppLocalizations.of(Globals.context!)!.connection_timeout));
    } on SocketException {
      log("SocketException");
      client.close();
      onError(ErrorMessage(
          errorType: ErrorType.NO_INTERNET,
          message: AppLocalizations.of(Globals.context!)!.no_internet));
    } catch (e) {
      client.close();
      log("Error: $e");
      onError(ErrorMessage(
          errorType: ErrorType.ERROR,
          message:
              AppLocalizations.of(Globals.context!)!.something_went_wrong));
    }
  }

  void showData(
      {required String url,
      var body,
      required Map<String, dynamic> header,
      required String response,
      required int statusCode,
      required Method method}) {
    if (kDebugMode) {
      log("URL = $url");
      log("Body = $body");
      log("Header = $header");
      log("Method = $method");
      log("statusCode = $statusCode");
      log("Response = $response");
    }
  }
}
