part of 'bath_model.dart';

Bath _$BathFromJson(Map<String, dynamic> json) {
  var favList = Hive.box('favourites');
  bool fav = (favList.values.where(
    (element) => element.bid == json['_id'],
  )).isNotEmpty;
  return Bath(
    bid: json['_id'],
    uid: json['uid'],
    name: json['name'],
    avUmbrellas: json['av_umbrellas'],
    totUmbrellas: json['tot_umbrellas'],
    phone: json['phone'],
    latitude: json['location']['coordinates'][0],
    longitude: json['location']['coordinates'][1],
    city: json['city'],
    province: json['province'],
    fav: fav,
  );
}

Map<String, dynamic> _$BathToJson(Bath instance) => <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'av_umbrellas': instance.avUmbrellas,
      'tot_umbrellas': instance.totUmbrellas,
      'phone': instance.phone,
      'location': {
        'type': "Point",
        'coordinates': [instance.longitude, instance.latitude]
      },
      'city': instance.city,
      'province': instance.province
    };
