import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:tamafake/database/entities/tables.dart';
import 'package:floor/floor.dart';

@dao
abstract class UserDao {
  @Query('SELECT * FROM UserTable')
  Future<List<UserTable>> findUser();

  @Query('DELETE FROM UserTable')
  Future<void> deleteAllUser();

  @insert
  Future<void> insertUser(UserTable user);

  @delete
  Future<void> deleteUser(UserTable user);

  @Query('SELECT * FROM UserTable WHERE data = :data')
  Future<List<UserTable>> findData(int data);
}

@dao
abstract class AvatarDao {
  @Query('SELECT * FROM AvatarTable')
  Future<List<AvatarTable>> findAvatar();

  @Query('DELETE FROM AvatarTable')
  Future<void> deleteAllAvatar();

  @insert
  Future<void> insertAvatar(AvatarTable avatar);

  @delete
  Future<void> deleteAvatar(AvatarTable avatar);

  @Query('SELECT MAX(exp) FROM AvatarTable')
  Future<int?> selectExp();
}

/*
@dao
abstract class DataDao {
  @Query('SELECT * FROM UserTable')
  Future<List<DataTable>> findUser();
  @insert //lo usiamo per inizializzarla
  Future<void> insertUser(DataTable data);
  @delete
  Future<void> deleteUser(DataTable data);
  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateUser(DataTable data);
}
*/