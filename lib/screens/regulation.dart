import 'package:flutter/material.dart';
import 'package:tamafake/screens/homepage.dart';

class RegulationPage extends StatelessWidget {
  const RegulationPage({Key? key}) : super(key: key);

  static const route = '/regulation/';
  static const routename = 'RegulationPage';

  @override
  Widget build(BuildContext context) {
    print('${RegulationPage.routename} built');
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF75B7E1),
        appBar: AppBar(
          title: Text('Regulation', style: TextStyle(fontSize: 25)),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 230, 67, 121),
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
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "How can you play with Eevee?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(30, 30, 30, 50),
                  child: (Column(
                    children: [
                      Text(
                          "Hello friends of Eevee!" +
                              "\n" +
                              "Welcome to this new adventure!" +
                              "\n" +
                              "\n" +
                              "With Eevee you can train and have fun at the same time but how does it work?" +
                              '\n' +
                              "After you authorize the App to access your Fitbit profile, you can upload your data and use it to train Eevee!" +
                              "\n" +
                              "For every 1000 steps you will earn 5€ that you can spend in the shop to feed Eevee. Based on the money spent in the shop Eevee's experience will increase and Eevee will level up every 100€ spent. You can also monitor your progess seeing the calories you have burned on the training page! Make your digital friend happy and play with Eevee!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                          )),
                    ],
                  ))),
            ],
          ),
        ),
      ),
    );
  }
}
