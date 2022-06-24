import 'package:floor/floor.dart';

@entity
class UserTable {
  @PrimaryKey()
  final int data;

  final String? userId;

  final double? steps;

  final double? calCardio;
  final double? calFatBurn;
  final double? calOoR;
  final double? calPeak;

  UserTable(this.data, this.userId, this.steps, this.calCardio, this.calFatBurn,
      this.calOoR, this.calPeak);
}

@entity
class AvatarTable {
  @PrimaryKey()
  final int exp;

  final String? userId;

  final int? level;

  AvatarTable(this.exp, this.userId, this.level);
}
