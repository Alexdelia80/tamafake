import 'package:flutter/material.dart';
import 'package:tamafake/screens/shoppage.dart';
import 'package:tamafake/screens/fetchuserdata.dart';
import 'package:tamafake/screens/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamafake/screens/authorizationpage.dart';

/*
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const route = '/home/';
  static const routename = 'Homepage';
*/
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const route = '/homepage/';
  static const routename = 'HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
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
            title: const Center(child: Text('HomePage'))),
        body: Container(
          margin: const EdgeInsets.all(20),
          //color: Color.fromARGB(255, 255, 255, 255),
          width: 500,
          height: 500,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                /* 
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.teal,
                  ),
                  child: const Text('Statistiche'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                */
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.teal,
                  ),
                  child: const Text('LogOut'),
                  onPressed: () => _toLoginPage(context),
                ),
                // MyButton('label', Navigator.pop(context)),
              ],
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 179, 210, 236),
        drawer: Drawer(
            child: ListView(
          children: <Widget>[
            const DrawerHeader(
              child: Text('Menu'),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 20, 178, 218),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.call),
              title: const Text('Assistance'),
              onTap: () {
                print('Assistance');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Authorization'),
              onTap: () {
                print('Authorization');
                Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AuthorizationPage()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () {
                print('Log Out');
                _toLoginPage(context);
              },
             
            ),
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
