//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamafake/screens/homepage.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  static const route = '/shop/';
  static const routename = 'ShopPage';

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  // definisco i valori dei cibi
  final int valPizza = 20;

  final int valIce = 15;

  final int valApple = 5;

  final int valWater = 2;

  //abbiamo detto che sono 2 euri
  @override
  Widget build(BuildContext context) {
    print('${ShopPage.routename} built');
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 20, 178, 218),
          title: const Center(child: Text('Shop')) //ext(ShopPage.routename),
          ),
      backgroundColor: const Color.fromARGB(255, 179, 210, 236),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.local_pizza),
            title: Text('Pizza'),
            trailing: Text('20 €'),
            onTap: () => _subtract(valPizza, context),
          ),
          ListTile(
            leading: Icon(Icons.icecream),
            title: Text('Ice Cream'),
            trailing: Text('15 €'),
            onTap: () => _subtract(valIce, context),
          ),
          ListTile(
            leading: Icon(Icons.apple),
            title: Text('Apple'),
            trailing: Text('5 €'),
            onTap: () => _subtract(valApple, context),
          ),
          ListTile(
            leading: Icon(MdiIcons.bottleSoda),
            title: Text('Water'),
            trailing: Text('2 €'),
            onTap: () => _subtract(valWater, context),
            // _subtract($val_water,context);
          ),
        ],
      ),
    );
    //classe
  }

//Funzione che sottrai i soldi del cibo dal portafoglio
  void _subtract(int valore, context) async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      int? portafoglio = sp.getInt('portafoglio');
      if (portafoglio! >= valore) {
        portafoglio = portafoglio - valore;
        sp.setInt('portafoglio', portafoglio);
        //vedo da console il valore del portafoglio:
        print(portafoglio);

        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            //AlertDialog Title
            title: const Text('YEP!!'),
            //AlertDialog description'
            content: const Text('You bought Eevee some food :)'),
          ),
        ); //show

      } else {
        //Mi richiama il Dialogo di allerta che non abbiamo abbastanza soldi, bisogna cambiare i testi
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            //AlertDialog Title
            title: const Text('Attention!'),
            //AlertDialog description'
            content: const Text(
                'Warning: you do not have enough money to buy this item.'),
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
        ); //showDialog
      }
      ; //else
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
