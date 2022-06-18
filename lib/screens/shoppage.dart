import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tamafake/screens/homepage.dart';


class ShopPage extends StatelessWidget {
  const ShopPage({Key? key}) : super(key: key);

  static const route = '/shop/';
  static const routename = 'ShopPage';

  @override
  Widget build(BuildContext context) {
    print('${ShopPage.routename} built');
    return Scaffold(
      appBar: AppBar(
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
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 20, 178, 218),
          title: const Center(
              child: Text('Shop')) 
          ),
      backgroundColor: const Color.fromARGB(255, 179, 210, 236),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.local_pizza),
            title: Text('Pizza', style: TextStyle(fontSize:20) ), 
            trailing: Text('20 €', style: TextStyle(fontSize:20)),
            onTap: () {
                print('Buy Pizza!');
              },
          ),
          ListTile(
            leading: Icon(Icons.icecream),
            title: Text('Ice Cream', style: TextStyle(fontSize:20) ),
            trailing: Text('15 €',style: TextStyle(fontSize:20) ),
            onTap: () {
                print('Buy Ice Cream!');
              },
          ),
          ListTile(
            leading: Icon(Icons.apple),
            title: Text('Apple', style: TextStyle(fontSize:20) ),
            trailing: Text('5 €', style: TextStyle(fontSize:20)),
            onTap: () {
                print('Buy Apple!');
              },
          ),
          ListTile(
            leading: Icon(MdiIcons.bottleSoda),
            title: Text('Water', style: TextStyle(fontSize:20) ),
            trailing: Text('2 €', style: TextStyle(fontSize:20) ),
            onTap: () {
                print('Buy Water!');
              },
          ),
        ],
      ),
    );
  } //build
} //ShopPage