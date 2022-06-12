import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:tamafake/database/entities/tables.dart';
import 'package:floor/floor.dart';

@dao
abstract class avatarDao {
  // gestisci l'inizializzazione a 0 dell'exp
  @Query('SELECT * FROM AvatarTable')
  Future<List<AvatarTable>> findAvatar();

  @insert //lo usiamo per inizializzarla
  Future<void> insertAvatar(AvatarTable avatar);

  @delete
  Future<void> deleteAvatar(AvatarTable avatar);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateAvatar(AvatarTable avatar);
}

@dao
abstract class userDao {
  @Query('SELECT * FROM UserTable')
  Future<List<UserTable>> findUser();

  @insert //lo usiamo per inizializzarla
  Future<void> insertUser(UserTable user);

  @delete
  Future<void> deleteUser(UserTable user);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateUser(UserTable user);
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