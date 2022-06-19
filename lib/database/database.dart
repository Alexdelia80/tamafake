//Imports that are necessary to the code generator of floor
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

//Here, we are importing the entities and the daos of the database
import 'package:tamafake/database/daos/tablesDao.dart';
import 'package:tamafake/database/entities/tables.dart';

//The generated code will be in database.g.dart
part 'database.g.dart';

@Database(version: 1, entities: [UserTable, AvatarTable])
abstract class AppDatabase extends FloorDatabase {
  //Add all the daos as getters here
  UserDao get user;
  AvatarDao get avatar;
} //AppDatabase

/*
@Database(version: 1, entities: [AvatarTable, UserTable])
abstract class AppDatabase extends FloorDatabase {
  //Add all the daos as getters here
  avatarDao get avatar;
  userDao get user;
  Future<void> clearAllTables() async {
    await database.execute('DELETE FROM user');
    await database.execute('DELETE FROM avatar');
  }
}//AppDatabase
*/
