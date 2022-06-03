import 'package:flutter/material.dart';
import 'package:tamagotchi/screens/shoppage.dart';
import 'package:tamagotchi/screens/fetchuserdata.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ShopPage()));
                },
              ),
            ],
            backgroundColor: Color.fromARGB(255, 20, 178, 218),
            title: Center(child: Text('HomePage'))),
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
        backgroundColor: Color.fromARGB(255, 179, 210, 236),
        drawer: Drawer(
            child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu'),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 20, 178, 218),
              ),
            ),
            ListTile(
              leading: Icon(Icons.call),
              title: Text('Assistance'),
              onTap: () {
                print('Assistance');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Shopping'),
              onTap: () {
                print('Shopping');
              },
            ),
            Divider(),
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
  Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
  //Navigator.of(context).pushReplacementNamed(LoginPage.route);
} //_toCalendarPage
