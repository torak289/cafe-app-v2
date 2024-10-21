import 'dart:async';
import 'package:cafeapp_v2/data_models/user_model.dart';
import 'package:cafeapp_v2/enum/app_states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService with ChangeNotifier {
  //Restructure???
  //TODO: Fix app idle & JWT expired
  late SupabaseClient _client;
  AppState _appState = AppState.Uninitialized;

  AppState get appState => _appState;

  final StreamController<UserModel> _user = StreamController<UserModel>();

  late bool isAnon = true;
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
      //This feels like it's in the wrong place and needs moving...
      _user.sink.add(userFromSupabase(session.user));
    }

    switch (event) {
      case AuthChangeEvent.initialSession:
        try {
          _client.auth.refreshSession();
        } catch (e) {
          //Not actually sure I need anon users...
          /*if (_client.auth.currentSession == null) {
            try {
              await _client.auth.signInAnonymously();
              isAnon = true;
            } catch (e) {
              debugPrint(e.toString());
            }
          }*/
        }
      case AuthChangeEvent.signedIn:
        _appState = AppState.Authenticated;
      case AuthChangeEvent.signedOut:
        _appState = AppState.Unauthenticated;
      case AuthChangeEvent.passwordRecovery:
      // handle password recovery
      case AuthChangeEvent.tokenRefreshed:
        // handle token refreshed
        if (session != null) {
          //TODO: Make this work on app launch/relaunch
          if (session.user.aud == "authenticated") {
            _appState = AppState.Authenticated;
          } else {
            //TODO: Implement First launch check...
            _appState = AppState.Uninitialized;
          }
        } else {
          _appState = AppState.Uninitialized;
        }
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

  Future<void> googleSSO() async {}

  Future<String> emailLogin(String email, String password) async {
    try {
      _appState = AppState.Authenticating;
      notifyListeners();
      await _client.auth
          .signInWithPassword(email: email.trim(), password: password.trim());
      _client.auth.startAutoRefresh(); //IDK if this is actually working...
      _appState = AppState.Authenticated;
      return "Success";
    } on AuthException catch (e) {
      debugPrint("Error: ${e.message}");
      _appState = AppState.Unauthenticated;
      notifyListeners();
      return e.message;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future signOut() async {
    await _client.auth.signOut();
    _client.auth.stopAutoRefresh(); //IDK if this is actually working...
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
