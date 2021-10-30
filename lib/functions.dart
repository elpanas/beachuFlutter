import 'package:firebase_auth/firebase_auth.dart';
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

  final loc = await Geolocator.getLastKnownPosition();

  if (loc == null)
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);
  else
    return loc;
}

// TEXTFIELD VALIDATION
String? validatorCallback(value) {
  if (value == null || value.isEmpty) return 'Please enter some text';
  return null;
}

Future<bool> registerWithEmail(email, password) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user != null)
      return true;
    else
      return false;
  } catch (e) {
    // print(e);
    return false;
  }
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
    // print(e);
    return false;
  }
}

Future<String> signInWithGoogle() async {
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
    return userCredential.user!.uid;
  else
    return '';
}

/* Future<String> signInWithFacebook() async {
  // Trigger the sign-in flow
  final LoginResult result = await FacebookAuth.instance.login();

  // Create a credential from the access token
  if (result.accessToken != null) {
    final facebookAuthCredential =
        FacebookAuthProvider.credential(result.accessToken!.token);

    // Once signed in, return the UserCredential
    final userCredential = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);

    if (userCredential.user != null)
      return userCredential.user!.uid;
    else
      return '';
  } else
    return '';
}*/
