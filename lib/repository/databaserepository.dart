import 'package:tamafake/database/database.dart';
import 'package:tamafake/database/entities/tables.dart';
import 'package:flutter/material.dart';

class DatabaseRepository extends ChangeNotifier{

  //The state of the database is just the AppDatabase
  final AppDatabase database;

  //Default constructor
  DatabaseRepository({required this.database});

  //These methods wrap the findUser() and findAvatar() methods of the DAO
  Future<List<UserTable>> findUser() async{
    final results = await database.user.findUser();
    return results;
  }

  Future<List<AvatarTable>> findAvatar() async{
    final results = await database.avatar.findAvatar();
    return results;
  }

  //These methods wrap the insertUser() and insertAvatar() methods of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> insertUser(UserTable user)async {
    await database.user.insertUser(user);
    notifyListeners();
  }

   Future<void> insertAvatar(AvatarTable avatar)async {
    await database.avatar.insertAvatar(avatar);
    notifyListeners();
  }

  //These methods wrap the deleteUser() and deleteAvatar methods of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> removeUser(UserTable user) async{
    await database.user.deleteUser(user);
    notifyListeners();
  }

   Future<void> removeAvatar(AvatarTable avatar) async{
    await database.avatar.deleteAvatar(avatar);
    notifyListeners();
  }
  
  //These methods wrap the updateUser() and updateAvatar methods of the DAO. 
  //Then, it notifies the listeners that something changed.
   Future<void> updateUser(UserTable user) async{
    await database.user.updateUser(user);
    notifyListeners();
  }

   Future<void> updateAvatar(AvatarTable avatar) async{
    await database.avatar.updateAvatar(avatar);
    notifyListeners();
  }
  
}//DatabaseRepository