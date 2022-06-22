import 'package:rte_app/blocs/auth/auth_event.dart';
import 'package:rte_app/common/widgets/errors.dart';
import 'package:rte_app/common/constants.dart';
import 'package:rte_app/models/user.dart';
import 'package:rte_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthResponse {
  String? message;
  bool? error;
  int? status;
  String? token;
  Map<String, dynamic>? collections;

  AuthResponse({
    this.message,
    this.collections,
    this.status,
    this.error,
    this.token,
  });

  factory AuthResponse.fromMap(Map<String, dynamic> map) {
    var model = AuthResponse();
    if(map.containsKey('status') && map['status'] == 200) {
      return model
          ..status = map['status']
          ..message = map['message']
          ..error = false
          ..token = map['token']
          ..collections = map['body'];
    }

    model.status = map['status'];
    model.message = map['message'];
    model.error = true;
    return model;
  }

}

class AuthService extends ApiService {

  AuthService({String? token}) : super(
    endpoint: dev_endpoint,
    token: token,
  );

  test () async {
    try {
      var response = await loginPost('/api/login', {
        'email': 'test@email.com',
        'password': 'password',
      });
      return AuthResponse.fromMap(response);
    } catch (e) {
      print('catch err');
      print(e);
    }
  }

  Future<AuthResponse> login (AuthLogin text) async {
    try {
      var response = await loginPost('/api/user/login', {
        'email': text.email,
        'password': text.password,
      });
      return AuthResponse.fromMap(response);
    } on ApiResponseError catch (e) {
      return AuthResponse(status: 401, error: true, message: e.message);
    } catch (e) {
      return AuthResponse(status: 401, error: true, message: 'Something went wrong');
    }
  }


  Future<AuthResponse> register(AuthRegister text) async {
    try {
      var response = await loginPost('/api/user/register', {
        'first_name': text.firstName,
        'last_name': text.lastName,
        'middle_name': text.middleName,
        'email_address': text.email,
        'password': text.password,
        'password_confirmation': text.confirmPassword,
      });
      return AuthResponse.fromMap(response);
    } on ApiResponseError catch (e) {
      return AuthResponse(status: 401, error: true, message: e.message);
    } catch (e) {
      return AuthResponse(status: 401, error: true, message: 'Something went wrong');
    }
  }

  Future<AuthResponse> updateUser(event, User? user) async {
    try {
      var response = await post('/api/user/update-user', {
        'key': user!.id.toString(),
        'full_name': event.fullName,
        'email': event.email,
        'user_type': 'Individual',
      });
      response['data'] = response['data'][0];
      return AuthResponse.fromMap(response);
    } on ApiResponseError catch(error) {
      return AuthResponse(status: 401, error: true, message: error.message);
    } catch (error) {
      return AuthResponse(status: 401, error: true, message: 'Something went wrong');
    }
  }

  Future<AuthResponse> viewedUser(int id) async {
    try {
      var response = await get('/api/user/get-user/${id}');
      return AuthResponse.fromMap(response);
    } on ApiResponseError catch(error) {
      return AuthResponse(status: 401, error: true, message: error.message);
    } catch (error) {
      return AuthResponse(status: 401, error: true, message: 'Something went wrong');
    }
  }

  Future<AuthResponse> viewedAuthor(int id) async {
    try {
      var response = await get('/api/user/get-author/${id}');
      return AuthResponse.fromMap(response);
    } on ApiResponseError catch(error) {
      return AuthResponse(status: 401, error: true, message: error.message);
    } catch (error) {
      return AuthResponse(status: 401, error: true, message: 'Something went wrong');
    }
  }

  Future logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var response = await delete('/api/logout');
      prefs.setString('token', "");
    } catch(error) {
      print(error);
    }
  }
}