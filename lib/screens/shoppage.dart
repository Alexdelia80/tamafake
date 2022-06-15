import 'dart:js';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({Key? key}) : super(key: key);

  static const route = '/shop/';
  static const routename = 'ShopPage';
  
  @override
  // definisco i valori dei cibi
  final int val_water = 2; //abbiamo detto che sono 2 euri

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
            onTap: () {
              print('Buy Pizza!');
            },
          ),
          ListTile(
            leading: Icon(Icons.icecream),
            title: Text('Ice Cream'),
            trailing: Text('15 €'),
            onTap: () {
              print('Buy Ice Cream!');
            },
          ),
          ListTile(
            leading: Icon(Icons.apple),
            title: Text('Apple'),
            trailing: Text('5 €'),
            onTap: () {
              print('Buy Apple!');
            },
          ),
          ListTile(
            leading: Icon(MdiIcons.bottleSoda),
            title: Text('Water'),
            trailing: Text('2 €'),
            //onTap: //=> _subtract($val_water, context);
            // _subtract($val_water,context);
          ),
        ],
      ),


      //Implemento la parte del portafoglio
      child: [
      FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: ((context, snapshot){
          if (snapshot.hasData){
            //sp contiene solo una coppia portafoglio:valore
            final sp = snapshot.data as SharedPreferences; 
            //inizializzo il portafoglio
            if(sp.getInt('portafoglio')==null){
              sp.setInt('portafoglio',0);
              //return Text('portafoglio=0);
            }
            else {
              final portafoglio = sp.getInt('portafoglio')!;
              return Text('Portafoglio =$portafoglio'); //dove lo sta ritornando? CAMBIARE
              //Bisogna aggiornare il portafoglio con i nuovi passi
            }
          }
          else {
            return CircularProgressIndicator();
          }
        })
      )
    ];
  );
  } 
  
  //Aggiungi al bottone onPressed del cibo il collegamento a queste funzioni
  void _subtract(int valore, context) async {
    final sp = await SharedPreferences.getInstance();
    setState((){
      var int portafoglio = sp.getInt('portafoglio');
      if (portafoglio >= $valore){
        portafoglio = portafoglio - $valore;
        sp.setInt('portafoglio', portafoglio);
      }
      else{
        //Mi richiama il Dialogo di allerta che non abbiamo abbastanza soldi, bisogna cambiare i testi
        showDialog<String>(
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
      );
    );};
    });
  }//_subtract

} //ShopPage

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