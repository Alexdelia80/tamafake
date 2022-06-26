import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamafake/database/entities/tables.dart';
import 'package:tamafake/screens/homepage.dart';
import 'package:provider/provider.dart';
import '../repository/databaseRepository.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  static const route = '/shop/';
  static const routename = 'ShopPage';

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  void initState() {
    super.initState();
  }

  // Punteggio cibi (esperienza)
  final int valPizza = 20;
  final int valIce = 15;
  final int valFish = 10;
  final int valApple = 5;
  final int valBread = 2;
  final int valWater = 1;

  @override
  Widget build(BuildContext context) {
    print('${ShopPage.routename} built');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 230, 67, 121),
        centerTitle: true,
        title: Text('Shop', style: TextStyle(fontSize: 25)),
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
      backgroundColor: Color(0xFF75B7E1),
      body: ListView(
        children: [
          const Divider(),
          ListTile(
            leading: Icon(Icons.local_pizza, size: 30),
            iconColor: Color.fromARGB(255, 230, 67, 121),
            title: Text('Pizza', style: TextStyle(fontSize: 23)),
            trailing: Text('20 €', style: TextStyle(fontSize: 22)),
            onTap: () => _subtract(valPizza, context),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.icecream, size: 30),
            iconColor: Color.fromARGB(255, 230, 67, 121),
            title: Text('Gourmet Ice Cream', style: TextStyle(fontSize: 23)),
            trailing: Text('15 €', style: TextStyle(fontSize: 22)),
            onTap: () => _subtract(valIce, context),
          ),
          const Divider(),
          ListTile(
            leading: Icon(MdiIcons.fish, size: 30),
            iconColor: Color.fromARGB(255, 230, 67, 121),
            title: Text('Fish', style: TextStyle(fontSize: 23)),
            trailing: Text('10 €', style: TextStyle(fontSize: 22)),
            onTap: () => _subtract(valFish, context),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.apple, size: 30),
            iconColor: Color.fromARGB(255, 230, 67, 121),
            title: Text('Apple', style: TextStyle(fontSize: 23)),
            trailing: Text('5 €', style: TextStyle(fontSize: 22)),
            onTap: () => _subtract(valApple, context),
          ),
          const Divider(),
          ListTile(
            leading: Icon(MdiIcons.baguette, size: 30),
            iconColor: Color.fromARGB(255, 230, 67, 121),
            title: Text('Bread', style: TextStyle(fontSize: 23)),
            trailing: Text('3 €', style: TextStyle(fontSize: 22)),
            onTap: () => _subtract(valBread, context),
          ),
          const Divider(),
          ListTile(
            leading: Icon(MdiIcons.bottleSoda, size: 30),
            iconColor: Color.fromARGB(255, 230, 67, 121),
            title: Text('Water', style: TextStyle(fontSize: 23)),
            trailing: Text('1 €', style: TextStyle(fontSize: 22)),
            onTap: () => _subtract(valWater, context),
          ),
          const Divider(),
          // Stampo il portafoglio nella schermata di shop
          FutureBuilder(
            future: SharedPreferences.getInstance(),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                final sp = snapshot.data as SharedPreferences;
                if (sp.getInt('portafoglio') == null) {
                  sp.setInt('portafoglio', 0);
                  final portafoglio = sp.getInt('portafoglio');
                  return Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Money: $portafoglio',
                      style: TextStyle(fontSize: 22),
                    ),
                  );
                } else {
                  final portafoglio = sp.getInt('portafoglio');
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      '\n' + '\n' + 'Money: $portafoglio',
                      style: TextStyle(fontSize: 25),
                    ),
                  );
                }
              } else {
                return CircularProgressIndicator();
              }
            }),
          ),
        ],
      ),
    );
  }

  // Metodo che sottrae i soldi spesi dal portafoglio
  void _subtract(int valore, context) async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      int? portafoglio = sp.getInt('portafoglio');
      if (portafoglio == null) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            //AlertDialog Title
            backgroundColor: Color.fromARGB(255, 230, 67, 121),
            title: const Text('Attention!'),
            //AlertDialog description
            content: const Text(
                'You do not have money, you need to load your progress first!',
                style: TextStyle(color: Colors.white)),
            actions: <Widget>[
              //Qui si può far scegliere all'utente di tornare alla home oppure di rimanere nello shop
              TextButton(
                //onPressed: () => Navigator.pop(context, 'Cancel'),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomePage())),
                child:
                    const Text('Home', style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      } else {
        if (portafoglio >= (valore)) {
          portafoglio = portafoglio - valore;
          sp.setInt('portafoglio', portafoglio);
          // Vedo da console il valore del portafoglio:
          print('Money: $portafoglio');

          showDialog<String>(
            context: context,
            builder: (BuildContext context) => const AlertDialog(
              //AlertDialog Title
              backgroundColor: Color.fromARGB(255, 230, 67, 121),
              title: const Text('YEP YOU ARE A GOOD TRAINER!!!',
                  style: TextStyle(color: Colors.white)),
              //AlertDialog description'
              content: const Text('You bought Eevee some food!',
                  style: TextStyle(color: Colors.white)),
            ),
          ); // Show

          //aggiorna tabella avatar con la funzione
          addAvatar(context, valore);
        } else {
          // Richiama il Dialog di allerta dicendo che non abbiamo abbastanza soldi
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              //AlertDialog Title
              backgroundColor: Color.fromARGB(255, 230, 67, 121),
              title: const Text('Attention!',
                  style: TextStyle(color: Colors.white)),
              //AlertDialog description
              content: const Text(
                  'You do not have enough money to buy this item',
                  style: TextStyle(color: Colors.white)),
              actions: <Widget>[
                //Qui si può far scegliere all'utente di tornare alla home oppure di rimanere nello shop
                TextButton(
                  //onPressed: () => Navigator.pop(context, 'Cancel'),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage())),
                  child:
                      const Text('Home', style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child:
                      const Text('OK', style: TextStyle(color: Colors.white)),
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

void addAvatar(context, int valore) async {
  String userID = '7ML2XV';
  final listavatar =
      await Provider.of<DatabaseRepository>(context, listen: false)
          .findAvatar();
  if (listavatar.isNotEmpty) {
    final int indice = listavatar.length - 1;
    int lastexp = listavatar[indice].exp;
    final newexp = lastexp + valore;
    final newlevel = newexp ~/ 100 + 1;
    print('Nuovo livello raggiunto: $newlevel');
    print('Nuova esperienza raggiunta: $newexp');
    Provider.of<DatabaseRepository>(context, listen: false)
        .insertAvatar(AvatarTable(newexp, userID, newlevel));

    // aggiorno il progresso
    final sp = await SharedPreferences.getInstance();
    if (sp.getDouble('progress') == null) {
      sp.setDouble('progress', 0);
      //calcolo progress
      final progress = (newexp - (newlevel - 1) * 100) / 100;
      sp.setDouble('progress', progress);
    } else {
      final progress = (newexp - (newlevel - 1) * 100) / 100;
      sp.setDouble('progress', progress);
    }
  }
  //AvatarTable vuota:
  else {
    final int lastexp = 0;
    final int level = 1;
    //inizializziamo la prima riga dell'avatar
    await Provider.of<DatabaseRepository>(context, listen: false)
        .insertAvatar(AvatarTable(lastexp, userID, level));
    final newexp = lastexp + valore;
    final newlevel = newexp ~/ 100 + 1;
    print('level: $newlevel');
    await Provider.of<DatabaseRepository>(context, listen: false)
        .insertAvatar(AvatarTable(newexp, userID, newlevel));

    // aggiorno il progresso
    final sp = await SharedPreferences.getInstance();
    if (sp.getDouble('progress') == null) {
      sp.setDouble('progress', 0);
      //calcolo progress
      final progress = (newexp - (newlevel - 1) * 100) / 100;
      sp.setDouble('progress', progress);
    } else {
      final progress = (newexp - (newlevel - 1) * 100) / 100;
      sp.setDouble('progress', progress);
    }
  }
}
