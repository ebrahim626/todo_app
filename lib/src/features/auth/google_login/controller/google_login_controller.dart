import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_app/src/features/auth/google_login/model/request/sign_in_request.dart';
import '../../../../core/database/hive_storage.dart';
import '../../../../shared/toast/toast.dart';
import '../repository/sign_in_repository.dart';

typedef GoogleSignInNotifier =
    AutoDisposeAsyncNotifierProvider<GoogleSignInProvider, void>;

final googleSignInProvider = GoogleSignInNotifier(GoogleSignInProvider.new);

class GoogleSignInProvider extends AutoDisposeAsyncNotifier {
  @override
  FutureOr build() {
    //throw UnimplementedError();
  }

  Future<bool> continueWithGoogle() async {
    try {
      EasyLoading.show();

      // ✅ Classic API — works on Android, iOS, Web
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      log('Step 1: Starting Google Sign-In flow...');
      final GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account == null) {
        // User cancelled the sign-in
        log('❌ User cancelled Google Sign-In.');
        EasyLoading.dismiss();
        return false;
      }

      log('✅ Step 1 Success: Google account selected: ${account.email}');
      log('Step 2: Retrieving Google auth tokens...');

      final GoogleSignInAuthentication googleAuth =
      await account.authentication;

      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;

      if (idToken == null || accessToken == null) {
        log('❌ Step 2 Failed: Missing tokens. idToken=$idToken, accessToken=$accessToken');
        EasyLoading.dismiss();
        return false;
      }

      log('✅ Step 2 Success: Tokens retrieved.');
      log('Step 3: Creating Firebase credential...');

      final credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      log('Step 4: Signing in with Firebase...');
      final userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      final String? firebaseToken = await user?.getIdToken();
      final String? fcmToken = await FirebaseMessaging.instance.getToken();

      log('✅ Step 4 Success: Firebase user: ${user?.email}');
      log('Step 5: Sending payload to backend...');

      final SignInRequest signInRequest = SignInRequest(
        firebaseToken: firebaseToken ?? '',
        fcmToken: fcmToken ?? '',
      );

      final repo = ref.read(signInRepository);
      final response = await repo.sign(signInRequest);

      if (response.data['isSuccess'] == true) {
        final token = response.data['data']['token'];

        if (token != null) {
          log('✅ Step 5 Success: Storing token...');
          final store = ref.read(cacheServiceProvider);
          store.setLoggedIn(true);
          store.setBearerToken(token);
          ref.invalidate(cacheServiceProvider);
          FlashCard.showSuccess(message: "Login Successful");
          EasyLoading.dismiss();
          return true;
        } else {
          log('❌ No accessToken in response.');
          EasyLoading.dismiss();
          return false;
        }
      } else {
        final msg = response.data?['message'] ?? 'Unknown error';
        log('❌ Backend returned failure: $msg');
        FlashCard.showError(errorMessage: msg);
        EasyLoading.dismiss();
        return false;
      }
    } catch (e, stackTrace) {
      log('Google Sign-In error: $e\nStackTrace: $stackTrace');
      EasyLoading.dismiss();
      return false;
    }
  }
}
