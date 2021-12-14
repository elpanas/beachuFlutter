import 'dart:convert';
import 'dart:io';
import 'package:beachu/constants.dart';
import 'package:beachu/models/bath_model.dart';
import 'package:beachu/models/hive_model.dart';
import 'package:beachu/providers/fav_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:beachu/providers/bath_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'bath_provider_test.mocks.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([http.Client])
void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: "../../.env");
  Hive.registerAdapter(LocalBathAdapter());
  await Hive.initFlutter();
  await Hive.deleteBoxFromDisk('favourites');
  await Hive.openBox('favourites');
  BathProvider bathP = BathProvider();
  FavProvider favP = FavProvider(bathP);
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
  const String jsonBath =
      '''{
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
  }''';

  final headersZip = {
    HttpHeaders.contentEncodingHeader: 'gzip',
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $hashAuth',
  };

  group('HTTP methods', () {
    test('POST request', () async {
      final compressedBody = GZipCodec().encode(jsonEncode(bath).codeUnits);

      when(client.post(
        Uri.parse(url),
        headers: headersZip,
        body: compressedBody,
      )).thenAnswer((_) async => http.Response(jsonBath, 201));

      expect(await bathP.postBath(client, bath), isTrue);
    });

    test('GET request', () async {
      when(client.get(Uri.parse('${url}disp/coord/41.222/15.333')))
          .thenAnswer((_) async => http.Response('[$jsonBath]', 200));

      expect(await bathP.getHandler(client, '${url}disp/coord/41.222/15.333'),
          isTrue);
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

      expect(await bathP.patchHandler(client, 0, 148), isTrue);
    });

    test('DELETE request', () async {
      when(client.delete(
        Uri.parse('${url}1'),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $hashAuth'},
      )).thenAnswer((_) async => http.Response('{}', 200));

      expect(await bathP.deleteBath(client, 0), isTrue);
    });
  });

  group('List methods', () {
    test('number of elements should be 0', () {
      expect(bathP.bathCount, 0);
    });

    test('item should be added', () {
      bathP.addBathItem(bath);
      expect(bathP.bathCount, 1);
    });

    test('umbrellas number should be 148', () {
      expect(bathP.bath[0].avUmbrellas, 148);
    });

    test('umbrellas number should be decreased of 1', () {
      bathP.setUmbrellas(149, 0);
      expect(bathP.bath[0].avUmbrellas, 149);
    });

    test('item should be edited', () {
      bathP.editBathItem(bath, 0);
      expect(bathP.bath[0].totUmbrellas, 148);
    });

    test('item should be removed', () {
      bathP.removeBathItem(0);
      expect(bathP.bath, isEmpty);
    });
  });

  group('Fav methods', () {
    test('should add fav to the list', () {
      bath.bid = '1';
      bathP.addBathItem(bath);
      favP.addFav(0);
      expect(favP.favList.length, 1);
    });

    test('should load favs', () {
      favP.loadFavList();
      expect(favP.favList.length, 1);
    });

    test('should remove fav from the list', () {
      favP.delFav(0);
      expect(favP.favList.isEmpty, true);
    });
  });

  group('Setters & Getters', () {
    test('should set the uid', () {
      bathP.userId = '1';
      expect(bathP.userId, '1');
      expect(bathP.userId = '1', isNot(throwsException));
    });

    test('should set loading status', () {
      bathP.loading = true;
      expect(bathP.loading, true);
    });

    test('should set message', () {
      const message = 'This is a trial message';
      bathP.message = message;
      expect(bathP.message, message);
      expect(bathP.message = message, isNot(throwsException));
    });

    test('should return a bath', () {
      expect(bathP.bath, isA<List<Bath>>());
    });
  });
}
