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

  // GET BATH LIST
  void loadBaths() async {
    setLoading(true);
    Position position = await getPosition();
    double lat = position.latitude;
    double long = position.longitude;
    setMessage('Loading...');
    try {
      http.Response res = await http
          .get(Uri.parse('${url}disp/coord/$lat/$long'))
          .timeout(Duration(seconds: 5));

      setLoading(false);

      if (res.statusCode == 200) {
        var resJson = jsonDecode(res.body);
        _bath = resJson.map<Bath>((data) => Bath.fromJson(data)).toList();
      } else
        setMessage('No Baths');
    } on TimeoutException catch (_) {
      setLoading(false);
      setMessage('No Baths');
    }

    notifyListeners();
  }

  // GET MANAGER BATH LIST
  void loadManagerBaths(uid) async {
    setLoading(true);
    setMessage('Loading...');
    try {
      http.Response res = await http.get(
        Uri.parse('${url}gest'),
        headers: {
          HttpHeaders.authorizationHeader: uid,
        },
      ).timeout(Duration(seconds: 5));

      setLoading(false);

      if (res.statusCode == 200) {
        var resJson = jsonDecode(res.body);
        _bath = resJson.map<Bath>((data) => Bath.fromJson(data)).toList();
      } else
        setMessage('No Baths');
    } on TimeoutException catch (_) {
      setLoading(false);
      setMessage('No Baths');
    }

    notifyListeners();
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
    setLoading(true);
    http.Response res = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: hashAuth,
      },
      body: jsonEncode(_bath),
    );
    setLoading(false);

    if (res.statusCode == 200) {
      addBathItem(value);
      setResult(true);
    }

    return _result;
  }

  // UPDATE A BATH TO THE WEB SERVICE
  Future<bool> putBath(Bath value, int index) async {
    http.Response res = await http.put(
      Uri.parse('$url/${_bath[index].bid}'),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: hashAuth,
      },
      body: jsonEncode(_bath),
    );
    setLoading(false);

    if (res.statusCode == 200) {
      editBathItem(value, index);
      setResult(true);
    }

    return _result;
  }

  // IN/DECREASE NR OF UMBRELLAS
  Future<bool> updateUmbrellas(bool increase, int index) async {
    final int newValue = (increase)
        ? _bath[index].avUmbrellas + 1
        : _bath[index].avUmbrellas - 1;

    setLoading(true);

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
    setLoading(false);

    if (res.statusCode == 200) {
      setUmbrellas(newValue, index);
      setResult(true);
    }

    return _result;
  }

  // DELETE A BATH
  Future<bool> deleteBath(String bid, int index) async {
    setLoading(true);

    http.Response res = await http.delete(
      Uri.parse('$url/$bid'),
      headers: {
        HttpHeaders.authorizationHeader: hashAuth,
      },
    );

    setLoading(false);

    if (res.statusCode == 200) {
      removeBathItem(index);
      setResult(true);
    }

    return _result;
  }

  // VARS GETTERS
  bool isLoading() {
    return _loading;
  }

  String getMessage() {
    return _message;
  }

  int getBathItemCount() {
    return _bath.length;
  }

  Bath getBathItem(index) {
    return _bath[index];
  }

  // VARS SETTERS
  void setResult(value) => _result = value;

  void setLoading(value) {
    _loading = value;
    notifyListeners();
  }

  void setMessage(value) {
    _message = value;
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
    notifyListeners();
  }

  void setUmbrellas(value, index) {
    _bath[index].avUmbrellas = value;
    notifyListeners();
  }
}
