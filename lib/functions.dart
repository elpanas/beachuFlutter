import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';

// GEOLOCATOR
Future<Position> getPosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return Future.error('Location services are disabled.');

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied)
      return Future.error('Location permissions are denied');
  }

  if (permission == LocationPermission.deniedForever)
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');

  return await Geolocator.getCurrentPosition();
}

// TEXTFIELD VALIDATION
String? validatorCallback(value) {
  if (value == null || value.isEmpty) return 'Please enter some text';
  return null;
}

Future<bool> signInWithEmail(email, password) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user != null)
      return true;
    else
      return false;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth =
      await googleUser!.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Once signed in, return the UserCredential
  final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

  if (userCredential.user != null)
    return true;
  else
    return false;
}

Future<bool> signInWithFacebook() async {
  // Trigger the sign-in flow
  final LoginResult result = await FacebookAuth.instance.login(
      loginBehavior: LoginBehavior
          .nativeWithFallback); // by default we request the email and the public profile

  if (result.status == LoginStatus.success)
    return true;
  else
    return false;
}
