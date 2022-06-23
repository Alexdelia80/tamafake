import 'package:flutter/material.dart';
import 'package:tamafake/screens/shoppage.dart';
import 'package:tamafake/screens/fetchuserdata.dart';
import 'package:tamafake/screens/loginpage.dart';
import 'package:tamafake/screens/assistancepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:tamafake/database/entities/tables.dart';
import 'package:tamafake/repository/databaseRepository.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const route = '/homepage/';
  static const routename = 'HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //final Arguments stepsArgs = Arguments();
  @override
  Widget build(BuildContext context) {
    //if (ModalRoute.of(context)!.settings.arguments != null) {
    //  final args = ModalRoute.of(context)!.settings.arguments as List;
    //}
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                tooltip: 'Go to the Shop',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ShopPage()));
                },
              ),
            ],
            backgroundColor: const Color.fromARGB(255, 20, 178, 218),
            foregroundColor: Color.fromARGB(255, 234, 251, 255),
            title: const Center(child: Text('TamaFAKE'))),
        body: Center(
          child:
              //We will show the todo table with a ListView.
              //To do so, we use a Consumer of DatabaseRepository in order to rebuild the widget tree when
              //entries are deleted or created.
              Consumer<DatabaseRepository>(builder: (context, dbr, child) {
            //The logic is to query the DB for the entire list of Todo using dbr.findAllTodos()
            //and then populate the ListView accordingly.
            //We need to use a FutureBuilder since the result of dbr.findAllTodos() is a Future.
            return FutureBuilder(
              initialData: null,
              future: dbr.findUser(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data as List<UserTable>;
                  return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, userIndex) {
                        final dataRecs = data[userIndex];
                        return Card(
                          elevation: 5,
                          //Here we use a Dismissible widget to create a nicer UI.
                          child: Dismissible(
                            //Just create a dummy unique key
                            key: UniqueKey(),
                            //This is the background to show when the ListTile is swiped
                            background: Container(color: Colors.red),
                            //The ListTile is used to show the Todo entry
                            child: ListTile(
                              leading: const Icon(MdiIcons.note),
                              title: Text(dataRecs.steps.toString()),
                              subtitle: Text('ID: ${dataRecs.userId}'),
                              //If the ListTile is tapped, it is deleted
                            ),
                            //This method is called when the ListTile is dismissed
                            onDismissed: (direction) async {
                              //No need to use a Consumer, we are just using a method of the DatabaseRepository
                              await Provider.of<DatabaseRepository>(context,
                                      listen: false)
                                  .removeUser(dataRecs);
                            },
                          ),
                        );
                      });
                } else {
                  //A CircularProgressIndicator is shown while the list of Todo is loading.
                  return const Text('il db è vuoto! Caricare i dati!');
                  // CircularProgressIndicator();
                } //else
              }, //builder of FutureBuilder
            );
          }),
        ),

        /*
        Center(
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 40, 0, 30),
            height: 600,
            child: Card(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
               ],
          
            const Center(
                child: CircleAvatar(
          backgroundImage:
              NetworkImage('https://www.woolha.com/media/2020/03/eevee.png'),
          radius: 50,
        )),
        
                  Text('${args[0].dateOfMonitoring}'),
                  Text('${args[0].restingHeartRate}'),
                  Text('${args[0].caloriesCardio}'),
                  
              ),
            ),
          ),
        ),
        */
        /*
        const Center(  
            child: CircleAvatar(
          backgroundImage:
              NetworkImage('https://www.woolha.com/media/2020/03/eevee.png'),
          radius: 50,
        )          
        ),
        */
        backgroundColor: const Color.fromARGB(255, 179, 210, 236),
        drawer: Drawer(
            backgroundColor: const Color.fromARGB(255, 179, 210, 236),
            child: ListView(
              children: <Widget>[
                const DrawerHeader(
                  child: Text('Menu',style: TextStyle(
                            fontSize: 30,
                          ), textAlign: TextAlign.center),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 20, 178, 218),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.call),
                  title: const Text('Assistance',
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  onTap: () {
                    print('Assistance');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AssistancePage()));
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.shopping_cart),
                  title: const Text('Shopping',
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  onTap: () {
                    print('Shopping');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ShopPage()));
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Authorization',
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  onTap: () {
                    print('Authorization');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FetchPage()));
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Log Out',
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  onTap: () {
                    print('Log Out');
                    _toLoginPage(context);
                  },
                )
              ],
            )),
      ),
    );
  } //build
} //HomePage

void _toLoginPage(BuildContext context) async {
  //Unset the 'username' filed in SharedPreference
  final sp = await SharedPreferences.getInstance();
  sp.remove('username');

  //Pop the drawer first
  Navigator.pop(context);
  //Then pop the HomePage
  Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
  //Navigator.of(context).pushReplacementNamed(LoginPage.route);
} //_toCalendarPage

// CODICE ELIMINATO:
/*
        Container(
          margin: const EdgeInsets.all(20),
          //color: Color.fromARGB(255, 255, 255, 255),
          width: 500,
          height: 500,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // bottoni al centro della pagina
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.teal,
                  ),
                  child: const Text('Fetch User Data'),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => FetchPage()));
                  },
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.teal,
                  ),
                  child: const Text('LogOut'),
                  onPressed: () => _toLoginPage(context),
                ),
                // fine pulsanti da mettere nella barra laterale
                // MyButton('label', Navigator.pop(context)),
              ],
            ),
          ),
        ),
        */