import 'package:beachu/constants.dart';
import 'package:beachu/models/bath_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:beachu/providers/bath_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'bath_provider_test.mocks.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([http.Client])
void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: "../../.env");
  BathProvider provider = BathProvider();
  Bath _bath = Bath(
    bid: '1',
    uid: '1',
    name: 'Bagno Prova',
    avUmbrellas: 150,
    totUmbrellas: 150,
    phone: '3333333',
    latitude: 41.222,
    longitude: 15.333,
    city: 'Manfredonia',
    province: 'Foggia',
    fav: false,
  );

  group('List methods', () {
    test('number of elements should be 0', () {
      expect(provider.bathCount, equals(0));
    });

    test('item should be added', () {
      provider.addBathItem(_bath);
      expect(provider.bathCount, equals(1));
    });

    test('umbrellas number should be 150', () {
      expect(provider.bath[0].avUmbrellas, equals(150));
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
}
