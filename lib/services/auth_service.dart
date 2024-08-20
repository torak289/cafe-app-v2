import 'dart:async';
import 'package:cafeapp_v2/data_models/user_model.dart';
import 'package:cafeapp_v2/enum/app_states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService with ChangeNotifier {
  //Restructure???
  late SupabaseClient _client;
  AppState _appState = AppState.Uninitialized;

  AppState get appState => _appState;

  final StreamController<UserModel> _user = StreamController<UserModel>();

  StreamController<UserModel> get user => _user;

  AuthService() {
    _client = Supabase.instance.client;
    _client.auth.onAuthStateChange.listen(_onAuthStateChanged);
  }

  Future<AuthState> _onAuthStateChanged(AuthState data) async {
    final AuthChangeEvent event = data.event;
    final Session? session = data.session;
    //debugPrint('Event: $event, Session: $session');

    if (session != null) {
      _user.sink.add(userFromSupabase(session.user));
    }

    switch (event) {
      case AuthChangeEvent.initialSession:
        _appState = AppState.Uninitialized;
        _client.auth.refreshSession();

      case AuthChangeEvent.signedIn:
        _appState = AppState.Authenticated;

      case AuthChangeEvent.signedOut:
        _appState = AppState.Unauthenticated;
      case AuthChangeEvent.passwordRecovery:
      // handle password recovery
      case AuthChangeEvent.tokenRefreshed:
        if (session != null) { //TODO: Make this work on app launch/relaunch
          if (session.user.aud == "authenticated") {
            _appState = AppState.Authenticated;
          } else {
            _appState = AppState.Uninitialized;
          }
        } else {
          _appState = AppState.Uninitialized;
        }

      // handle token refreshed
      case AuthChangeEvent.userUpdated:
      // handle user updated
      case AuthChangeEvent.userDeleted:
        _appState = AppState.Uninitialized;

      case AuthChangeEvent.mfaChallengeVerified:
      // handle mfa challenge verified
    }
    debugPrint('App State: $_appState');
    notifyListeners();
    return data;
  }

  Future<void> emailRegister(String email, String password) async {
    try {
      _appState = AppState.Registering;
      notifyListeners();
      await _client.auth.signUp(email: email, password: password);
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<String> emailLogin(String email, String password) async {
    try {
      _appState = AppState.Authenticating;
      notifyListeners();
      await _client.auth
          .signInWithPassword(email: email.trim(), password: password.trim());
      if (/* TODO: check email verified */ true) {
        _appState = AppState.Authenticated;
      } else {
        _appState = AppState.Unverified;
      }
      return "Success";
    } catch (e) {
      debugPrint("Error: $e");
      _appState = AppState.Unauthenticated;
      notifyListeners();
      return e.toString();
    }
  }

  Future signOut() async {
    await _client.auth.signOut();
    return Future.delayed(const Duration(microseconds: 1));
  }

  UserModel userFromSupabase(User? user) {
    if (user == null) {
      return UserModel(uid: '-1', email: 'null');
    } else {
      return UserModel(uid: user.id, email: user.email);
    }
  }
}
