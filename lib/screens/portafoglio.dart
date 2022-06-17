import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamafake/screens/shoppage.dart';
import 'package:tamafake/repository/databaserepository.dart';
import 'package:tamafake/database/entities/tables.dart';


//Funzione che inizializza il portafoglio
  Future<String> portafoglio (ShopPage data) async {
    final sp = await SharedPreferences.getInstance();
    if (sp.getInt('portafoglio') == null) {
      sp.setInt('portafoglio', 0);
     return '';
    } else {
      return '';
    }
  }

 