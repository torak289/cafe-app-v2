import 'package:cafeapp_v2/data_models/user_model.dart';
import 'package:cafeapp_v2/enum/app_states.dart';

class AuthService {
  AppState _appState = AppState.Uninitialized;

  Future<String?> login(String email, String password) async {
    try {
      //TODO: Do Login
    } catch (error) {
      return error.toString();
    }
  }

  Future<UserModel?> register(String email, String password) async {
    try {
      //TODO: Do Register
    } catch (error) {}
  }

  logout() async {
    try {
      //TODO: Do Logout
    } catch (error) {
      return error.toString();
    }
  }
}
