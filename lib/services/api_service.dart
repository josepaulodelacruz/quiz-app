import 'dart:async';
import 'dart:convert';

import 'package:rte_app/common/utils.dart';
import 'package:rte_app/common/widgets/errors.dart';
import 'package:rte_app/main.dart';
import 'package:rte_app/models/cookie.dart';
import 'package:rte_app/blocs/cookie/cookie_bloc.dart';
import 'package:sensitive_http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ApiService {
  AppUtil _appUtil = AppUtil();
  String? token;
  final String endpoint;

  ApiService({
    required this.endpoint,
    this.token,
  });

  Future<Map<String, dynamic>> get(
      String resources,
      String rte_token,
      [Map<String, dynamic>? body]
      ) async {
    try {
      String uri = '$endpoint$resources';

      var headers = {
        'Accept': 'application/json',
        'Cookie': rte_token,
      };

      var result = await http.get(
        Uri.parse(uri),
        headers: headers,
      );
      var response = jsonDecode(result.body);

      print(response);

      if(result.statusCode >= 200 && result.statusCode < 400) {
        return response;
      } else {
        String message;
        if (response["message"].runtimeType == String) {
          message = response["message"];
        } else {
          message = response['message']['reasons'];
        }
        // throw ApiResponseError(code: 400, message: message);
        return {'message': message};
      }
    } catch (e) {
      print('api_service');
      print(e);
      return {'code': 400, 'message': e};
    }
  }

  Future<Map<String, dynamic>> post(
      String resource,
      [Map<String, String>? body]
      ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String uri = '$endpoint$resource';

      var headers = {
        'Accept': 'application/json',
        'Cookie': getIt<CookieBloc>().state.cookie!.session.toString(),
      };

      var authBody = {};

      var requestBody = {...authBody};
      if(body != null) {
        requestBody = {...requestBody, ...body};
      }

      var result = await http.post(
        Uri.parse(uri),
        headers: headers,
        body: requestBody,
      ).timeout(
          Duration(seconds: 15),
          onTimeout: () {
            throw TimeoutException("The connection has timed out, Please try again!");
          }
      );

      var response = jsonDecode(result.body);

      print('response ${response}');

      var cookie = prefs.getString('token');

      if(cookie == null || cookie == "") {
        cookie = result.headers['set-cookie'];
        prefs.setString('token', cookie.toString());
        response['token'] = cookie;
      }


      if (result.statusCode >= 200 && result.statusCode < 400) {
        response['status'] = 200;
        response['error'] = false;
        response['message'] = response['message'];
        return response;
      } else {
        String message;
        Map<String, dynamic> errorResponse = {};
        if (response["message"].runtimeType == String) {
          errorResponse['status'] = response['status'];
          errorResponse['error'] = response['error'];
          errorResponse['message'] = response['message'];
          return errorResponse;
        } else {
          message = response['message']["reason"];
        }
        throw ApiResponseError(code: response["code"], message: message);
      }
    } catch (e) {
      return {'code': 400, 'message': e};
    }
  }

  Future<Map<String, dynamic>> loginPost(
      String resource,
      [Map<String, String>? body]
  ) async {
    return await loginRaw(resource, body);
  }

  Future<Map<String, dynamic>> loginRaw(
      String resource,
      [Map<String, String>? body]
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String uri = '$endpoint$resource';

      var headers = {
        'Accept': 'application/json',
        'Cookie': "",
      };

      var authBody = {};

      var requestBody = {...authBody};
      if(body != null) {
        requestBody = {...requestBody, ...body};
      }

      var result = await http.post(
        Uri.parse(uri),
        headers: headers,
        body: requestBody,
      ).timeout(
          Duration(seconds: 15),
          onTimeout: () {
            throw TimeoutException("The connection has timed out, Please try again!");
          }
      );

      var response = jsonDecode(result.body);
      print(response);

      var cookie = prefs.getString('token');

      if(cookie == null || cookie == "") {
        cookie = result.headers['set-cookie'];
        prefs.setString('token', cookie.toString());
        response['token'] = cookie;
      }


      if (result.statusCode >= 200 && result.statusCode < 400) {
        response['status'] = 200;
        response['error'] = false;
        response['message'] = response['message'];
        return response;
      } else {
        String message;
        Map<String, dynamic> errorResponse = {};
        if (response["message"].runtimeType == String) {
          errorResponse['status'] = response['status'];
          errorResponse['error'] = response['error'];
          errorResponse['message'] = response['message'];
          return errorResponse;
        } else {
          message = response['message']["reason"];
        }
        throw ApiResponseError(code: response["code"], message: message);
      }
    } catch (e) {
      return {'code': 400, 'message': e};
    }
  }

  Future<Map<String, dynamic>> delete(String resource, [Map<String, String>? body]) async {
    try {
      String uri = '$endpoint$resource';
      var result = await http.delete(
        Uri.parse(uri),
        headers: {
          'Accept': 'application/json',
          'Cookie': getIt<CookieBloc>().state.cookie!.session.toString(),
        }
      );
      var response = jsonDecode(result.body);
      return response;
    } catch (error) {
      return {'code': 400, 'message': error};
    }
  }

}