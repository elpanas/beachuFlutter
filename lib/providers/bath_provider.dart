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

class BathProvider extends ChangeNotifier {
  List<Bath> _bathList = [];
  bool _loading = false;
  bool _result = false;
  String _message = 'no_baths'.tr();
  String _uid = '';
  var _favList = Hive.box('favourites');

  // HANDLERS
  void getHandler(url) async {
    loading = true;
    message = 'loading'.tr();
    try {
      http.Response res = await http
          .get(
            Uri.parse(url),
          )
          .timeout(
            Duration(seconds: 2),
          );

      loading = false;

      if (res.statusCode == 200) {
        var resJson = jsonDecode(res.body);
        _bathList = resJson.map<Bath>((data) => Bath.fromJson(data)).toList();
        _result = true;
      } else
        message = 'no_baths'.tr();
    } on TimeoutException catch (_) {
      message = 'no_baths'.tr();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> putHandler(int index, int newValue) async {
    loading = true;

    http.Response res = await http.put(
      Uri.parse('$url/disp/'),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: hashAuth,
      },
      body: jsonEncode(<String, dynamic>{
        'bid': _bathList[index].bid!,
        'av_umbrellas': newValue,
      }),
    );
    loading = false;

    if (res.statusCode == 200) {
      setUmbrellas(newValue, index);
      _result = true;
    }

    return _result;
  }

  // GET BATH LIST
  loadBaths() async {
    Position pos = await getPosition();
    getHandler('${url}disp/coord/${pos.latitude}/${pos.longitude}');
  }

  // GET SINGLE BATH
  bool loadBath(String bid) {
    getHandler('${url}bath/$bid');
    return _result;
  }

  // GET MANAGER BATH LIST
  loadManagerBaths() => getHandler('${url}gest/$_uid');

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

  // POST A NEW BATH TO THE WEB SERVICE
  Future<bool> postBath(Bath value) async {
    loading = true;
    http.Response res = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: hashAuth,
      },
      body: jsonEncode(value),
    );
    loading = false;

    if (res.statusCode == 200) {
      addBathItem(value);
      loadManagerBaths();
      _result = true;
    } else
      print(res.body);

    return _result;
  }

  // UPDATE A BATH TO THE WEB SERVICE
  Future<bool> putBath(Bath value, int index) async {
    loading = true;

    if (value.avUmbrellas <= value.totUmbrellas) {
      http.Response res = await http.put(
        Uri.parse('$url/${_bathList[index].bid}'),
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: hashAuth,
        },
        body: jsonEncode(value),
      );
      loading = false;

      if (res.statusCode == 200) {
        editBathItem(value, index);
        _result = true;
      }
    } else
      _result = false;

    return _result;
  }

  // IN/DECREASE NR OF UMBRELLAS
  Future<bool> increaseUmbrellas(int index) async {
    if (_bathList[index].avUmbrellas < _bathList[index].totUmbrellas)
      return await putHandler(index, _bathList[index].avUmbrellas + 1);
    else
      return false;
  }

  Future<bool> decreaseUmbrellas(int index) async {
    if (_bathList[index].avUmbrellas > 0)
      return await putHandler(index, _bathList[index].avUmbrellas - 1);
    else
      return false;
  }

  // DELETE A BATH
  Future<bool> deleteBath(int index) async {
    loading = true;
    String? bid = _bathList[index].bid;
    http.Response res = await http.delete(
      Uri.parse('$url/$bid'),
      headers: {
        HttpHeaders.authorizationHeader: hashAuth,
      },
    );
    loading = false;

    if (res.statusCode == 200) {
      removeBathItem(index);
      _result = true;
    } else
      _result = false;

    return _result;
  }

  // VARS GETTERS
  get userId => _uid;
  get loading => _loading;
  get message => _message;
  get bathCount => _bathList.length;
  get bath => _bathList;

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

  // LIST SETTERS
  void addBathItem(value) {
    _bathList.add(value);
    notifyListeners();
  }

  void editBathItem(value, index) {
    _bathList[index] = value;
    notifyListeners();
  }

  void removeBathItem(index) {
    _bathList.removeAt(index);
    if (_bathList.length == 0) _message = 'no_baths'.tr();
    notifyListeners();
  }

  void setUmbrellas(value, index) {
    _bathList[index].avUmbrellas = value;
    notifyListeners();
  }

  // DB FUNCTIONS
  get loadFavList => _favList.values.toList();

  void addFav(int index) {
    LocalBath singleBath = LocalBath(
      bid: _bathList[index].bid!,
      name: _bathList[index].name,
      city: _bathList[index].city,
    );
    _favList.add(singleBath);
    _bathList[index].fav = true;
    notifyListeners();
  }

  void delFav(int index) {
    _favList.deleteAt(index);
    _bathList[index].fav = false;
    notifyListeners();
  }
}
