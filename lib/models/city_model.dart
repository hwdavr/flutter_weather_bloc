import 'package:hive/hive.dart';

part 'city_model.g.dart';

@HiveType(typeId: 0)
class City {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int updatedAt;

  City({this.name, this.updatedAt});
}
