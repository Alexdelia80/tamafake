//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamafake/database/entities/tables.dart';
import 'package:tamafake/screens/homepage.dart';
import 'package:provider/provider.dart';
import '../repository/databaseRepository.dart';
import 'package:tamafake/database/entities/tables.dart';
import 'package:tamafake/screens/fetchuserdata.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  static const route = '/shop/';
  static const routename = 'ShopPage';

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  // Punteggio cibi (esperienza)
  final int valPizza = 20;
  final int valIce = 15;
  final int valApple = 5;
  final int valWater = 2;

  @override
  Widget build(BuildContext context) {
    print('${ShopPage.routename} built');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 20, 178, 218),
        title: const Center(child: Text('Shop')),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
                icon: const Icon(Icons.arrow_back_sharp),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));

                  Scaffold.of(context).openDrawer();
                },
                tooltip:
                    MaterialLocalizations.of(context).openAppDrawerTooltip);
          },
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 179, 210, 236),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.local_pizza),
            title: Text('Pizza', style: TextStyle(fontSize: 18)),
            trailing: Text('20 €', style: TextStyle(fontSize: 18)),
            onTap: () => _subtract(valPizza, context),
          ),
          ListTile(
            leading: Icon(Icons.icecream),
            title: Text('Ice Cream', style: TextStyle(fontSize: 18)),
            trailing: Text('15 €', style: TextStyle(fontSize: 18)),
            onTap: () => _subtract(valIce, context),
          ),
          ListTile(
            leading: Icon(Icons.apple),
            title: Text('Apple', style: TextStyle(fontSize: 18)),
            trailing: Text('5 €', style: TextStyle(fontSize: 18)),
            onTap: () => _subtract(valApple, context),
          ),
          ListTile(
            leading: Icon(MdiIcons.bottleSoda),
            title: Text('Water', style: TextStyle(fontSize: 18)),
            trailing: Text('2 €', style: TextStyle(fontSize: 18)),
            onTap: () => _subtract(valWater, context),
          ),
        ],
      ),
    );
  }

  // Funzione che sottrai i soldi del cibo dal portafoglio
  void _subtract(int valore, context) async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      int? portafoglio = sp.getInt('portafoglio');
      if (portafoglio == null) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            //AlertDialog Title
            title: const Text('Attention!'),
            //AlertDialog description
            content: const Text(
                'Warning: you do not have money, you need to load your progress'),
            actions: <Widget>[
              //Qui si può far scegliere all'utente di tornare alla home oppure di rimanere nello shop
              TextButton(
                //onPressed: () => Navigator.pop(context, 'Cancel'),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomePage())),
                child: const Text('Home'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        if (portafoglio >= (valore)) {
          portafoglio = portafoglio - valore;
          sp.setInt('portafoglio', portafoglio);
          // Vedo da console il valore del portafoglio:
          print(portafoglio);

          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              //AlertDialog Title
              title: const Text('YEP!!!'),
              //AlertDialog description'
              content: const Text('You bought Eevee some food!'),
            ),
          ); // Show

/*
          //Aggiorno l'esperienza
          String userID = '7ML2XV';
          // controllare che exp sia diversa da null altrimenti la poniamo a 0
          final exp = Provider.of<DatabaseRepository>(context, listen: false)
              .selectExp();
          if (exp == null) {
            final exp = 0; //inizializzo a 0 l'esperienza
          }
          // poi la aggiorniamo con i punti presi dal cibo
          final newexp = exp + valore;
          // calcoliamo il livello (raggiungi 100 di esperienza ci si alza di 1 livello)
          final level = exp! ~/ 100;
          //facciamo insert della exp aggiornata, di userID (che dobbiamo definire all'inizio) e del level calcolato
          Provider.of<DatabaseRepository>(context, listen: false)
              .insertAvatar(AvatarTable(newexp, userID, level));
          
*/
        } else {
          // Richiama il Dialog di allerta dicendo che non abbiamo abbastanza soldi, bisogna cambiare i testi
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              //AlertDialog Title
              title: const Text('Attention!'),
              //AlertDialog description
              content: const Text(
                  'Warning: you do not have enough money to buy this item'),
              actions: <Widget>[
                //Qui si può far scegliere all'utente di tornare alla home oppure di rimanere nello shop
                TextButton(
                  //onPressed: () => Navigator.pop(context, 'Cancel'),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage())),
                  child: const Text('Home'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          ); //showDialog
        } //
      }
    }); // setState
  } //_subtract
  //ShopPage
}

  
/* 
  WIDGET CHE DOPO AVER PREMUTO AVVIA UN'ALLERTA
class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('AlertDialog Title'),
          content: const Text('AlertDialog description'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
      child: const Text('Show Dialog'),
    );
  }
}
*/
