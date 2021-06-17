import 'package:hive/hive.dart';
part 'hive_model.g.dart';

@HiveType(typeId: 0)
class LocalBath {
  @HiveField(0)
  final String bid;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String city;

  LocalBath({
    required this.bid,
    required this.name,
    required this.city,
  });
}
