import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:beachu/constants.dart';
import 'package:beachu/functions.dart';
import 'package:beachu/models/bath_model.dart';
import 'package:beachu/models/hive_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class BathProvider extends ChangeNotifier {
  List<Bath> _bathList = [];
  var _favList = [];
  bool _loading = false, _result = false;
  String _message = 'no_baths'.tr(), _uid = '';
  final headers = {
    HttpHeaders.contentEncodingHeader: 'gzip',
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: hashAuth,
  };

  // HANDLERS
  getHandler(url) async {
    loading = true;
    message = 'loading'.tr();
    _result = false;
    try {
      http.Response res = await http.get(
        Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: hashAuth},
      );

      if (res.statusCode == 200) {
        final resJson = jsonDecode(res.body);
        _bathList = resJson.map<Bath>((data) => Bath.fromJson(data)).toList();
        _result = true;
      } else
        message = 'no_baths'.tr();
    } catch (e) {
      message = 'no_baths'.tr();
    } finally {
      loading = false;
    }
  }

  Future<bool> patchHandler(int index, int newValue) async {
    loading = true;
    _result = false;
    final body = jsonEncode(<String, dynamic>{
          'bid': _bathList[index].bid!,
          'av_umbrellas': newValue,
        }),
        compressedBody = GZipCodec().encode(body.codeUnits);

    try {
      http.Response res = await http.patch(
        Uri.parse('$url/disp/'),
        headers: headers,
        body: compressedBody,
      );

      if (res.statusCode == 200) {
        setUmbrellas(newValue, index);
        _result = true;
      }
    } catch (e) {
      // ...
    } finally {
      loading = false;
    }

    return _result;
  }

  Future<Bath> makeRequest(
    String uid,
    String name,
    int avUmbrellas,
    int totUmbrellas,
    String phone,
    String city,
    String province,
  ) async {
    Position position = await getPosition();
    return Bath(
      uid: uid,
      name: name,
      avUmbrellas: avUmbrellas,
      totUmbrellas: totUmbrellas,
      phone: phone,
      latitude: position.latitude,
      longitude: position.longitude,
      city: city,
      province: province,
      fav: false,
    );
  }
  // ---------------------------------------------------------

  // GET
  loadBaths() async {
    Position pos = await getPosition();
    getHandler('${url}disp/coord/${pos.latitude}/${pos.longitude}');
  }

  loadBath(String bid) => getHandler('${url}bath/$bid');

  loadManagerBaths() => getHandler('${url}gest/$_uid');
  // ---------------------------------------------------------

  // CREATE
  Future<bool> postBath(Bath value) async {
    loading = true;
    _result = false;
    try {
      final compressedBody = GZipCodec().encode(jsonEncode(bath).codeUnits);
      http.Response res = await http.post(
        Uri.parse(url),
        headers: headers,
        body: compressedBody,
      );

      if (res.statusCode == 201) {
        addBathItem(value);
        loadManagerBaths();
        _result = true;
      }
    } catch (e) {
      // ...
    } finally {
      loading = false;
    }

    return _result;
  }
  // ---------------------------------------------------------

  // UPDATE
  Future<bool> putBath(Bath value, int index) async {
    loading = true;
    _result = false;

    final compressedBody = GZipCodec().encode(jsonEncode(bath).codeUnits);

    try {
      if (value.avUmbrellas <= value.totUmbrellas) {
        http.Response res = await http.put(
          Uri.parse('$url/${_bathList[index].bid}'),
          headers: headers,
          body: compressedBody,
        );

        if (res.statusCode == 200) {
          editBathItem(value, index);
          _result = true;
        }
      } else
        _result = false;
    } catch (e) {
      // ...
    } finally {
      loading = false;
    }

    return _result;
  }

  Future<bool> increaseUmbrellas(int index) async {
    if (_bathList[index].avUmbrellas < _bathList[index].totUmbrellas)
      return await patchHandler(index, _bathList[index].avUmbrellas + 1);
    else
      return false;
  }

  Future<bool> decreaseUmbrellas(int index) async {
    if (_bathList[index].avUmbrellas > 0)
      return await patchHandler(index, _bathList[index].avUmbrellas - 1);
    else
      return false;
  }
  // ---------------------------------------------------------

  // DELETE
  Future<bool> deleteBath(int index) async {
    loading = true;
    _result = false;
    final bid = _bathList[index].bid;
    try {
      http.Response res = await http.delete(
        Uri.parse('$url/$bid'),
        headers: {HttpHeaders.authorizationHeader: hashAuth},
      );

      if (res.statusCode == 200) {
        removeBathItem(index);
        _result = true;
      }
    } catch (e) {
      // ...
    } finally {
      loading = false;
    }

    return _result;
  }

  // ---------------------------------------------------------
  // VARS GETTERS
  get userId => _uid;
  get loading => _loading;
  get message => _message;
  get bathCount => _bathList.length;
  get bath => _bathList;
  get favList => _favList;
  // ---------------------------------------------------------

  // VARS SETTERS
  set userId(userId) {
    _uid = userId;
    notifyListeners();
  }

  set loading(value) {
    _loading = value;
    notifyListeners();
  }

  set message(value) {
    _message = value;
    notifyListeners();
  }

  set bath(value) {
    _bathList = value;
    notifyListeners();
  }
  // ---------------------------------------------------------

  // LIST SETTERS
  addBathItem(value) {
    _bathList.add(value);
    notifyListeners();
  }

  editBathItem(value, index) {
    _bathList[index] = value;
    notifyListeners();
  }

  removeBathItem(index) {
    _bathList.removeAt(index);
    if (_bathList.length == 0) _message = 'no_baths'.tr();
    notifyListeners();
  }

  setUmbrellas(value, index) {
    _bathList[index].avUmbrellas = value;
    notifyListeners();
  }

  callNumber(index) async {
    await canLaunch('tel:${_bathList[index].phone}')
        ? launch('tel:${_bathList[index].phone}')
        : throw 'Could not launch';
  }

  openMap(index) {
    MapsLauncher.launchCoordinates(
      _bathList[index].latitude,
      _bathList[index].longitude,
      _bathList[index].name,
    );
  }
  // ---------------------------------------------------------

  // DB FUNCTIONS
  loadFavList() {
    var box = Hive.box('favourites');
    _favList = box.values.toList();
    if (_favList.length == 0) message = 'no_baths'.tr();
    notifyListeners();
  }

  addFav(int index) {
    var box = Hive.box('favourites');
    LocalBath singleBath = LocalBath(
      bid: _bathList[index].bid!,
      name: _bathList[index].name,
      city: _bathList[index].city,
    );
    box.add(singleBath);
    _bathList[index].fav = true;
    _favList = box.values.toList();
    notifyListeners();
  }

  delFav(int index) {
    var box = Hive.box('favourites');
    box.values
        .firstWhere((element) => element.bid == _bathList[index].bid)
        .delete();
    _bathList[index].fav = false;
    _favList = box.values.toList();
    notifyListeners();
  }
  // ---------------------------------------------------------
}
