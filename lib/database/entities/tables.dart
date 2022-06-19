import 'package:floor/floor.dart';

@entity
class UserTable {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String? userId;

  final String? data;

  final double? steps;

  final double? calories;

  UserTable(this.id, this.userId, this.data, this.steps, this.calories);
}

@entity
class AvatarTable {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String? userId;

  final int? exp;

  AvatarTable(this.id, this.userId, this.exp);
}
