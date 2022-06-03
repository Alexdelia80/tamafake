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
          backgroundColor: Color.fromARGB(255, 20, 178, 218),
          title:
              Center(child: Text(ShopPage.routename)) //ext(ShopPage.routename),
          ),
      backgroundColor: Color.fromARGB(255, 179, 210, 236),
    );
  } //build
} //ShopPage
