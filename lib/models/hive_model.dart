import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class LocalBath extends HiveObject {
  @HiveField(0)
  int? index;

  @HiveField(1)
  String? name;
}
