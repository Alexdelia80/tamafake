import 'package:flutter/material.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({Key? key}) : super(key: key);

  static const route = '/shop/';
  static const routename = 'ShopPage';

  @override
  Widget build(BuildContext context) {
    print('${ShopPage.routename} built');
    return Scaffold(
        appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 20, 178, 218),
            title: const Center(
                child: Text(ShopPage.routename)) //ext(ShopPage.routename),
            ),
        backgroundColor: const Color.fromARGB(255, 179, 210, 236),
        body: ListView(
          children: [
            ListTile(
              //leading: Icon()
              title: Text("Acqua"),
              subtitle: Text("Punti: 10"),
              trailing: Icon(Icons.arrow_right),
            ),
          ],
        ));
  } //build
} //ShopPage
