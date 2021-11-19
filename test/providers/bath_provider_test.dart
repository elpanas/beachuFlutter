import 'dart:convert';
import 'dart:io';
import 'package:beachu/constants.dart';
// import 'package:beachu/functions.dart';
import 'package:beachu/models/bath_model.dart';
import 'package:beachu/models/hive_model.dart';
import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:beachu/providers/bath_provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'bath_provider_test.mocks.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([http.Client])
void main() async {
  /* setUpAll(() {
    // required to avoid HTTP error 400 mocked returns
    HttpOverrides.global = null;
  });*/
  TestWidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: "../../.env");
  //await Firebase.initializeApp();
  Hive.registerAdapter(LocalBathAdapter());
  await Hive.initFlutter();
  await Hive.deleteBoxFromDisk('favourites');
  await Hive.openBox('favourites');
  BathProvider provider = BathProvider();
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  final client = MockClient();
  Bath bath = Bath(
    uid: '1',
    name: 'Bagno Prova 2',
    avUmbrellas: 148,
    totUmbrellas: 148,
    phone: '3333333',
    latitude: 41.222,
    longitude: 15.333,
    city: 'Manfredonia',
    province: 'Foggia',
    fav: false,
  );
  String jsonBath =
      '''[{
    "_id": "1",
    "uid": "1",
    "name": "Bagno Prova",
    "av_umbrellas": 150,
    "tot_umbrellas": 150,
    "phone": "3333333",
    "location": {
      "type": "Point",
      "coordinates": [15.333, 41.222]
    },
    "city": "Manfredonia",
    "province": "Foggia"
  }]''';

  final headersZip = {
    HttpHeaders.contentEncodingHeader: 'gzip',
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: hashAuth,
  };

  group('HTTP methods', () {
    test('POST request', () async {
      final compressedBody = GZipCodec().encode(jsonEncode(bath).codeUnits);

      when(client.post(
        Uri.parse(url),
        headers: headersZip,
        body: compressedBody,
      )).thenAnswer((_) async => http.Response(jsonBath, 201));

      expect(await provider.postBath(client, bath), isTrue);
    });

    test('GET request', () async {
      when(client.get(Uri.parse('${url}disp/coord/41.222/15.333')))
          .thenAnswer((_) async => http.Response(jsonBath, 200));

      expect(
          await provider.getHandler(client, '${url}disp/coord/41.222/15.333'),
          isTrue);
    });

    test('PATCH request', () async {
      final body = jsonEncode(<String, dynamic>{
        'av_umbrellas': 148,
      });
      final compressedBody = GZipCodec().encode(body.codeUnits);

      when(client.patch(
        Uri.parse('${url}1'),
        headers: headersZip,
        body: compressedBody,
      )).thenAnswer((_) async => http.Response('{}', 200));

      expect(await provider.patchHandler(client, 0, 148), isTrue);
    });
    /*
    test('PUT request', () async {
      final body = jsonEncode(bath);
      final compressedBody = GZipCodec().encode(body.codeUnits);

      when(client.put(
        Uri.parse('${url}1'),
        headers: headersZip,
        body: compressedBody,
      )).thenAnswer((_) async => http.Response('{}', 200));

      expect(await provider.putBath(client, bath, 0), isTrue);
    });
    */
    test('DELETE request', () async {
      when(client.delete(
        Uri.parse('${url}1'),
        headers: {HttpHeaders.authorizationHeader: hashAuth},
      )).thenAnswer((_) async => http.Response('{}', 200));

      expect(await provider.deleteBath(client, 0), isTrue);
    });
  });

  group('List methods', () {
    test('number of elements should be 0', () {
      expect(provider.bathCount, equals(0));
    });

    test('item should be added', () {
      provider.addBathItem(bath);
      expect(provider.bathCount, equals(1));
    });

    test('umbrellas number should be 148', () {
      expect(provider.bath[0].avUmbrellas, equals(148));
    });

    test('umbrellas number should be decreased of 1', () {
      provider.setUmbrellas(149, 0);
      expect(provider.bath[0].avUmbrellas, equals(149));
    });

    test('item should be removed', () {
      provider.removeBathItem(0);
      expect(provider.bathCount, equals(0));
    });
  });

  group('Fav methods', () {
    test('should add fav to the list', () {
      bath.bid = '1';
      provider.addBathItem(bath);
      provider.addFav(0);
      expect(provider.favList.length, 1);
    });

    test('should load favs', () {
      provider.loadFavList();
      expect(provider.favList.length, 1);
    });

    test('should remove fav from the list', () {
      provider.delFav(0);
      expect(provider.favList.length, 0);
    });
  });

  group('Setters & Getters', () {
    test('should set the uid', () {
      provider.userId = '1';
      expect(provider.userId, equals('1'));
      expect(provider.userId = '1', isNot(throwsException));
    });

    test('should set loading status', () {
      provider.loading = true;
      expect(provider.loading, true);
    });

    test('should set message', () {
      const message = 'This is a trial message';
      provider.message = message;
      expect(provider.message, message);
      expect(provider.message = message, isNot(throwsException));
    });

    test('should return a bath', () {
      expect(provider.bath, isA<List<Bath>>());
    });
  });
  /*
  group('Firebase functions', () {
    test('Sign In', () async {
      final String email = 'luca.panariello@gmail.com';
      final String password = '123456';
      final result = await signInWithEmail(email, password);

      if (result) provider.userId = _auth.currentUser!.uid;

      expect(result, isTrue);
      expect(provider.userId, isNotNull);
    });

    test('Sign out', () async {
      await _auth.signOut();

      expect(_auth.currentUser, isNull);
    });
  });
  */
}
