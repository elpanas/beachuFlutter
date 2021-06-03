import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:beachu/constants.dart';
import 'package:beachu/models/bath_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class BathProvider extends ChangeNotifier {
  List<Bath> _bath = [];
  bool _loading = false;
  bool _result = false;
  String _message = 'Loading...';

  // GET BATH INFOS FROM THE WEB SERVICE
  void loadBaths(lat, long) async {
    setLoading(true);
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
    setLoading(true);

    http.Response res = await http.put(
      Uri.parse('$url/${value.bid}'),
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

  // RETURN LOADING VAR STATUS
  bool isLoading() {
    return _loading;
  }

  // SET RESULT VAR
  void setResult(value) => _result = value;

  // SET LOADING VAR AND NOTIFIY
  void setLoading(value) {
    _loading = value;
    notifyListeners();
  }

  void setMessage(value) {
    _message = value;
    notifyListeners();
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
}
