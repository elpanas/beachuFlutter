import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:beachu/constants.dart';
import 'package:beachu/functions.dart';
import 'package:beachu/models/bath_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class BathProvider extends ChangeNotifier {
  List<Bath> _bathList = [];
  bool _loading = false, _result = false;
  String _message = 'no_baths'.tr(), _uid = '';
  final _headersZip = {
    HttpHeaders.contentEncodingHeader: 'gzip',
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $hashAuth',
  };
  final _header = {
    HttpHeaders.authorizationHeader: 'Bearer $hashAuth',
  };

  // HANDLERS
  Future<bool> getHandler(http.Client client, String url) async {
    loading = true;
    message = 'loading'.tr();
    _result = false;
    try {
      final res = (_uid == '')
          ? await client.get(Uri.parse(url))
          : await client.get(Uri.parse(url), headers: _header);
      if (res.statusCode == 200) {
        final resJson = jsonDecode(res.body);
        _bathList = resJson.map<Bath>((data) => Bath.fromJson(data)).toList();
        _result = true;
      } else {
        message = 'no_baths'.tr();
      }
    } catch (e) {
      message = 'no_baths'.tr();
      throw Exception(e);
    } finally {
      loading = false;
    }
    return _result;
  }

  Future<bool> patchHandler(http.Client client, int index, int newValue) async {
    loading = true;
    _result = false;
    final body = jsonEncode(<String, dynamic>{
      'av_umbrellas': newValue,
    });
    final compressedBody = GZipCodec().encode(body.codeUnits);

    try {
      final res = await client.patch(
        Uri.parse('$url${_bathList[index].bid!}'),
        headers: _headersZip,
        body: compressedBody,
      );

      if (res.statusCode == 200) {
        setUmbrellas(newValue, index);
        _result = true;
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      loading = false;
    }

    return _result;
  }

  Future<Bath> makeRequest(
    String name,
    int avUmbrellas,
    int totUmbrellas,
    String phone,
    String city,
    String province,
  ) async {
    Position position = await getPosition();
    return Bath(
      uid: _uid,
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
  // coverage:ignore-start
  Future<bool> loadBaths() async {
    Position pos = await getPosition();
    return await getHandler(
        http.Client(), '${url}disp/coord/${pos.latitude}/${pos.longitude}');
  }

  Future<bool> loadBath(String bid) {
    return getHandler(http.Client(), '${url}bath/$bid');
  }

  Future<bool> loadManagerBaths() async {
    return await getHandler(http.Client(), '${url}gest/$_uid');
  }
  // coverage:ignore-end
  // ---------------------------------------------------------

  // CREATE
  Future<bool> postBath(http.Client client, Bath value) async {
    loading = true;
    _result = false;

    try {
      var compressedBody = GZipCodec().encode(jsonEncode(value).codeUnits);
      final res = await client.post(
        Uri.parse(url),
        headers: _headersZip,
        body: compressedBody,
      );

      if (res.statusCode == 201) {
        final resJson = jsonDecode(res.body);
        final bath = Bath.fromJson(resJson); // contiene solo 1 elemento
        addBathItem(bath);
        _result = true;
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      loading = false;
    }

    return _result;
  }
  // ---------------------------------------------------------

  // UPDATE

  Future<bool> putBath(http.Client client, Bath value, int index) async {
    loading = true;
    _result = false;

    final compressedBody = GZipCodec().encode(jsonEncode(bath).codeUnits);

    try {
      if (value.avUmbrellas <= value.totUmbrellas) {
        final res = await client.put(
          Uri.parse('$url${_bathList[index].bid}'),
          headers: _headersZip,
          body: compressedBody,
        );

        if (res.statusCode == 200) {
          editBathItem(value, index);
          _result = true;
        }
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      loading = false;
    }

    return _result;
  }

  Future<bool> increaseUmbrellas(int index) async {
    if (_bathList[index].avUmbrellas < _bathList[index].totUmbrellas) {
      return await patchHandler(
          http.Client(), index, _bathList[index].avUmbrellas + 1);
    } else {
      return false;
    }
  }

  Future<bool> decreaseUmbrellas(int index) async {
    if (_bathList[index].avUmbrellas > 0) {
      return await patchHandler(
          http.Client(), index, _bathList[index].avUmbrellas - 1);
    } else {
      return false;
    }
  }
  // ---------------------------------------------------------

  // DELETE
  Future<bool> deleteBath(http.Client client, int index) async {
    loading = true;
    _result = false;
    final bid = _bathList[index].bid;
    try {
      final res = await client.delete(
        Uri.parse('$url$bid'),
        headers: _header,
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
  addBathItem(Bath value) {
    _bathList.add(value);
    notifyListeners();
  }

  editBathItem(Bath value, int index) {
    _bathList[index] = value;
    notifyListeners();
  }

  removeBathItem(int index) {
    _bathList.removeAt(index);
    if (_bathList.isEmpty) _message = 'no_baths'.tr();
    notifyListeners();
  }

  setUmbrellas(int value, int index) {
    _bathList[index].avUmbrellas = value;
    notifyListeners();
  }

  // coverage:ignore-start
  callNumber(int index) async {
    await canLaunch('tel:${_bathList[index].phone}')
        ? launch('tel:${_bathList[index].phone}')
        : throw 'Could not launch';
  }

  openMap(int index) {
    MapsLauncher.launchCoordinates(
      _bathList[index].latitude,
      _bathList[index].longitude,
      _bathList[index].name,
    );
  }
  // coverage:ignore-end
  // ---------------------------------------------------------

}
