import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:beachu/constants.dart';
import 'package:beachu/functions.dart';
import 'package:beachu/models/bath_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class BathProvider extends ChangeNotifier {
  List<Bath> _bath = [];
  bool _loading = false;
  bool _result = false;
  String _message = 'Loading...';
  String _uid = '';

  // HANDLERS
  void getHandler(url) async {
    loading = true;
    message = 'Loading...';
    try {
      http.Response res =
          await http.get(Uri.parse(url)).timeout(Duration(seconds: 2));

      loading = false;

      if (res.statusCode == 200) {
        var resJson = jsonDecode(res.body);
        print(resJson);
        _bath = resJson.map<Bath>((data) => Bath.fromJson(data)).toList();
        _result = true;
      } else
        message = 'No Baths';
    } on TimeoutException catch (_) {
      message = 'No Baths';
    } finally {
      loading = false;
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
        'bid': _bath[index].bid!,
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
  void loadBaths() async {
    Position pos = await getPosition();
    getHandler('${url}disp/coord/${pos.latitude}/${pos.longitude}');
  }

  // GET MANAGER BATH LIST
  void loadManagerBaths() {
    print(_uid);
    getHandler('${url}gest/$_uid');
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
        Uri.parse('$url/${_bath[index].bid}'),
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
    if (_bath[index].avUmbrellas < _bath[index].totUmbrellas)
      return await putHandler(index, _bath[index].avUmbrellas + 1);
    else
      return false;
  }

  Future<bool> decreaseUmbrellas(int index) async {
    if (_bath[index].avUmbrellas > 0)
      return await putHandler(index, _bath[index].avUmbrellas - 1);
    else
      return false;
  }

  // DELETE A BATH
  Future<bool> deleteBath(int index) async {
    loading = true;
    String? bid = _bath[index].bid;
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
  get bathCount => _bath.length;
  get bath => _bath;

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
    _bath = value;
    notifyListeners();
  }

  // LIST SETTERS
  void addBathItem(value) {
    _bath.add(value);
    notifyListeners();
  }

  void editBathItem(value, index) {
    _bath[index] = value;
    notifyListeners();
  }

  void removeBathItem(index) {
    _bath.removeAt(index);
    if (_bath.length == 0) _message = 'No Baths';
    notifyListeners();
  }

  void setUmbrellas(value, index) {
    _bath[index].avUmbrellas = value;
    notifyListeners();
  }
}
