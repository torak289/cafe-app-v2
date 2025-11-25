import 'dart:async';
import 'dart:convert';
import 'package:cafeapp_v2/data_models/user_model.dart';
import 'package:cafeapp_v2/enum/app_states.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService with ChangeNotifier {
  //TODO: Fix app idle & JWT expired
  late SupabaseClient _client;
  AppState _appState = AppState.Uninitialized;

  AppState get appState => _appState;

  final StreamController<UserModel> _user = StreamController<UserModel>();

  StreamController<UserModel> get user => _user;

  AuthService() {
    _client = Supabase.instance.client;
    _client.auth.onAuthStateChange.listen(_onAuthStateChanged);
  }

  Future<void> manualRefresh() async {
    _client.auth.refreshSession();
  }

  Future<String> changePassword(String newPassword) async {
    try {
      await _client.auth.updateUser(UserAttributes(password: newPassword));
      return "Success";
    } on AuthException catch (e) {
      return e.message;
    }
  }

  Future<String> deleteUser() async {
    try {
      _appState = AppState.Authenticating;
      notifyListeners();

      final session = _client.auth.currentSession;
      if (session == null) {
        // Shouldn't happen if you're guarding the screen, but just in case
        _appState = AppState.Unauthenticated;
        notifyListeners();
        return "Not logged in";
      }

      final res = await _client.functions.invoke(
        'self_delete_user',
        method: HttpMethod.post,
        headers: {
          // user is already authenticated; just pass their access token
          'Authorization': 'Bearer ${session.accessToken}',
        },
      );

      if (res.status == 200) {
        // User deleted successfully on the server → clean up local auth state
        await _client.auth.signOut();
        _appState = AppState.Unauthenticated;
        notifyListeners();
        return "Success";
      }

      if (res.status == 401) {
        // Token invalid/expired; user is effectively logged out anyway
        await _client.auth.signOut();
        _appState = AppState.Unauthenticated;
        notifyListeners();
        return "Session expired. Please log in again.";
      }

      // Any other error – user still exists on the server,
      // so keep them as Authenticated.
      _appState = AppState.Authenticated;
      notifyListeners();

      // Try to surface a useful message from the function response
      String message = "Failed to delete account";
      final data = res.data;
      if (data is Map && data['error'] is String) {
        message = data['error'] as String;
      }

      return message;
    } on AuthException catch (e) {
      // Something went wrong with the local Supabase client
      _appState = AppState.Authenticated;
      notifyListeners();
      return e.message;
    } catch (e) {
      _appState = AppState.Authenticated;
      notifyListeners();
      return "Unexpected error while deleting account";
    }
  }

  Future<void> _onAuthStateChanged(AuthState data) async {
    final AuthChangeEvent event = data.event;
    final Session? session = data.session;

    if (session != null) {
      _user.sink.add(userFromSupabase(session.user));
    }

    switch (event) {
      case AuthChangeEvent.initialSession:
        try {
          await _client.auth.refreshSession();
          if (_client.auth.currentSession != null) {
            _appState = AppState.Authenticated;
          } else {
            _appState = AppState.Unauthenticated;
          }
        } catch (e) {
          _appState = AppState.Unauthenticated;
        }
        break;

      case AuthChangeEvent.signedIn:
        _appState = AppState.Authenticated;
        break;

      case AuthChangeEvent.signedOut:
        _appState = AppState.Unauthenticated;
        break;

      case AuthChangeEvent.passwordRecovery:
        // You can decide how to handle this; for now treat as unauthenticated
        _appState = AppState.Unauthenticated;
        break;

      case AuthChangeEvent.tokenRefreshed:
        if (session != null && session.user.aud == "authenticated") {
          _appState = AppState.Authenticated;
        } else {
          _appState = AppState.Unauthenticated;
        }
        break;

      case AuthChangeEvent.userUpdated:
        // Usually keep the current state or mark as authenticated if session exists
        if (session != null) {
          _appState = AppState.Authenticated;
        }
        break;

      case AuthChangeEvent.userDeleted:
        // Up to you: Unauthenticated may make more sense than Uninitialized
        _appState = AppState.Unauthenticated;
        break;

      case AuthChangeEvent.mfaChallengeVerified:
        _appState = AppState.Authenticated;
        break;
    }

    debugPrint('App State: $_appState');
    notifyListeners();
  }

  Future<String> emailRegister(String email, String password) async {
    try {
      await _client.auth.signUp(email: email, password: password);
      _appState = AppState.Registering;
      notifyListeners();
      return "Success";
    } on AuthException catch (e) {
      debugPrint("Auth error (existing): ${e.message}");
      _appState = AppState.Unauthenticated;
      notifyListeners();
      return e.message;
    }
  }

  Future<String> emailLogin(String email, String password) async {
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();

    try {
      await _client.auth.signInWithPassword(
        email: trimmedEmail,
        password: trimmedPassword,
      );

      _client.auth.startAutoRefresh();
      _appState = AppState.Authenticated;
      notifyListeners();
      return "Success";
    } on AuthException catch (e) {
      debugPrint("Auth error (existing): ${e.message}");
      _appState = AppState.Unauthenticated;
      notifyListeners();
      return e.message;
    }
  }

  Future<String> googleSSO() async {
    try {
      _appState = AppState.Authenticating;
      notifyListeners();

      /// Web Client ID that you registered with Google Cloud.
      const webClientId =
          '423853703530-mlsaqkdb15s0kru1sq1r1sjvg17sosam.apps.googleusercontent.com';

      /// iOS Client ID that you registered with Google Cloud.
      const iosClientId =
          '423853703530-25i0dae4m4meneuluenn28l7qqi0rkju.apps.googleusercontent.com';

      final scopes = ['email', 'profile'];
      final googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize(
        serverClientId: webClientId,
        clientId: iosClientId,
      );

      //final googleUser = await googleSignIn.attemptLightweightAuthentication();
      final googleUser = await googleSignIn.authenticate();
      debugPrint(googleUser.toString());
      if (googleUser == null) {
        throw const AuthException('Failed to sign in with Google.');
      }

      /// Authorization is required to obtain the access token with the appropriate scopes for Supabase authentication,
      /// while also granting permission to access user information.
      final authorization =
          await googleUser.authorizationClient.authorizationForScopes(scopes) ??
              await googleUser.authorizationClient.authorizeScopes(scopes);

      final idToken = googleUser.authentication.idToken;
      if (idToken == null) {
        throw const AuthException('No ID Token found.');
      }

      // Sign in with Supabase using the Google ID token
      await _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: authorization.accessToken,
      );

      // Optionally store user name/email in user metadata, similar to Apple flow
      // if available on the googleUser instance.
      if (googleUser.displayName != null || googleUser.email.isNotEmpty) {
        String? givenName;
        String? familyName;
        String? fullName = googleUser.displayName;

        if (fullName != null && fullName.trim().isNotEmpty) {
          final parts = fullName.trim().split(' ');
          if (parts.isNotEmpty) {
            givenName = parts.first;
            if (parts.length > 1) {
              familyName = parts.sublist(1).join(' ');
            }
          }
        }

        await _client.auth.updateUser(
          UserAttributes(
            data: {
              'full_name': fullName,
              'given_name': givenName,
              'family_name': familyName,
              'email': googleUser.email,
            },
          ),
        );
      }

      // Start auto-refresh and update app state
      _client.auth.startAutoRefresh();
      _appState = AppState.Authenticated;
      notifyListeners();

      return "Success";
    } on AuthException catch (e) {
      debugPrint("Google Auth Error: ${e.message}");
      _appState = AppState.Unauthenticated;
      notifyListeners();
      return e.message;
    } catch (e) {
      _appState = AppState.Unauthenticated;
      notifyListeners();
      debugPrint(e.toString());
      return "Failure";
    }
  }

  Future<String> appleSSO() async {
    try {
      _appState = AppState.Authenticating;
      notifyListeners();

      final rawNonce = _client.auth.generateRawNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      final idToken = credential.identityToken;
      if (idToken == null) {
        throw const AuthException(
          'Could not find ID Token from generated credential.',
        );
      }

      // Sign in with Supabase using the Apple ID token
      await _client.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
        nonce: rawNonce,
      );

      // Apple only provides the user's full name on the first sign-in
      // Save it to user metadata if available
      if (credential.givenName != null || credential.familyName != null) {
        final nameParts = <String>[];
        if (credential.givenName != null) nameParts.add(credential.givenName!);
        if (credential.familyName != null)
          nameParts.add(credential.familyName!);
        final fullName = nameParts.join(' ');

        await _client.auth.updateUser(
          UserAttributes(
            data: {
              'full_name': fullName,
              'given_name': credential.givenName,
              'family_name': credential.familyName,
            },
          ),
        );
      }

      // Start auto-refresh and update app state
      _client.auth.startAutoRefresh();
      _appState = AppState.Authenticated;
      notifyListeners();

      return "Success";
    } on SignInWithAppleAuthorizationException catch (e) {
      // Handle user cancellation (error code 1001) and other Apple auth errors
      if (e.code == AuthorizationErrorCode.canceled) {
        debugPrint("Apple Sign-In was canceled by user");
        _appState = AppState.Unauthenticated;
        notifyListeners();
        return "Sign in was canceled";
      } else {
        debugPrint("Apple Sign-In Error: ${e.message}");
        _appState = AppState.Unauthenticated;
        notifyListeners();
        return e.message;
      }
    } on AuthException catch (e) {
      debugPrint("Error: ${e.message}");
      _appState = AppState.Unauthenticated;
      notifyListeners();
      return e.message;
    } catch (e) {
      debugPrint("Unexpected error during Apple Sign-In: $e");
      _appState = AppState.Unauthenticated;
      notifyListeners();
      return "An unexpected error occurred";
    }
  }

  Future signOut() async {
    await _client.auth.signOut();
    _client.auth.stopAutoRefresh(); //IDK if this is actually working...
    return Future.delayed(const Duration(microseconds: 1));
  }

  UserModel userFromSupabase(User? user) {
    if (user == null) {
      return UserModel(uid: '-1', email: 'null', provider: 'null');
    } else {
      return UserModel(
          uid: user.id,
          email: user.email,
          provider: user.identities![0].provider);
    }
  }
}
