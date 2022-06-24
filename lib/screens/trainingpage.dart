import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tamafake/database/entities/tables.dart';
import 'package:tamafake/repository/databaseRepository.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitbitter/fitbitter.dart';

class TrainingPage extends StatefulWidget {
  TrainingPage({Key? key}) : super(key: key);

  static const route = '/training/';
  static const routename = 'TrainingPage';

  @override
  _TrainingPageState createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
// end Future function

  List<double?>? datarec;
  @override
  void initState() {
    super.initState();
    // fetchName function is a asynchronously to GET data
    _loadData(context).then((result) {
      // Once we receive our name we trigger rebuild.
      setState(() {
        datarec = result;
      });
    });
  }

  int touchedIndex = 0;
  //final calCard = datarec.calCardio;
  //double calCardio = datarec?[0] ?? -1

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blue,
        alignment: Alignment.center,
        width: double.infinity,
        height: 250.0,
        child: AspectRatio(
          aspectRatio: 1.3,
          child: Card(
            color: Colors.white,
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                    pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    }),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 0,
                    sections: showingSections()),
              ),
            ),
          ),
        ));
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      double calCardio = datarec?[0] ?? -1;
      double calFatBurn = datarec?[1] ?? -1;
      double calOoR = datarec?[2] ?? -1;
      double calPeak = datarec?[3] ?? -1;
      print('calorie cardio: $calCardio');
      print('calorie FatBurn: $calFatBurn');
      print('calorie out of Range: $calOoR');
      print('calorie Peak: $calPeak');

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: calCardio,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              'assets/cardio.jpg',
              size: widgetSize,
              borderColor: const Color(0xff0293ee),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: calFatBurn,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              'assets/fat.jpg',
              size: widgetSize,
              borderColor: const Color(0xfff8b250),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: calPeak,
            title: '16%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              'assets/peak.jpg',
              size: widgetSize,
              borderColor: const Color(0xff845bef),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: calOoR,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              'assets/oor.jpg',
              size: widgetSize,
              borderColor: const Color(0xff13d38e),
            ),
            badgePositionPercentageOffset: .98,
          );
        default:
          throw 'Oh no';
      }
    });
  }
}

class _Badge extends StatelessWidget {
  final String svgAsset;
  final double size;
  final Color borderColor;

  const _Badge(
    this.svgAsset, {
    Key? key,
    required this.size,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: SvgPicture.asset(
          svgAsset,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

Future<List<double?>?> _loadData(context) async {
  final calcData = DateTime.now().subtract(const Duration(days: 1));
  int dataINT = int.parse(DateFormat("ddMMyyyy").format(calcData));

  final listtable =
      await Provider.of<DatabaseRepository>(context, listen: false).findUser();

  if (listtable.isNotEmpty) {
    int? indice = listtable.length - 1;
    int? lastdata = listtable[indice].data;
    if (lastdata == dataINT) {
      final sp = await SharedPreferences.getInstance();
      if (sp.getString('AuthorizationCheck') != null) {
        final datarec = listtable[indice];
        List<double?>? vect = [
          datarec.calCardio,
          datarec.calFatBurn,
          datarec.calOoR,
          datarec.calPeak
        ];
        print(vect);
        return vect;
      } else {
        return null;
      } // Endif lastData=dataint
    } else {
      return null;
    }
  }
} 

/*
Future<List<double?>?> _loadData(context) async {
  String fitclientid = '238BYH';
  String fitclientsec = '9d8c4fb21e663b4f783f3f4fc6acffb8';
  String redirecturi = 'example://fitbit/auth';
  String callbackurl = 'example';
  String? userID;
  String fixedUID = '7ML2XV';
  final calcData = DateTime.now().subtract(const Duration(days: 1));
  int dataINT = int.parse(DateFormat("ddMMyyyy").format(calcData));
  final listtable =
      await Provider.of<DatabaseRepository>(context, listen: false).findUser();
  if (listtable.isNotEmpty) {
    int? indice = listtable.length - 1;
    int? lastdata = listtable[indice].data;
    if (lastdata == dataINT) {
      final sp = await SharedPreferences.getInstance();
      if (sp.getString('AuthorizationCheck') != null) {
        FitbitHeartDataManager fitbitActivityDataManager =
            FitbitHeartDataManager(
          clientID: fitclientid,
          clientSecret: fitclientsec,
        );
        final heartData = await fitbitActivityDataManager
            .fetch(FitbitHeartAPIURL.dayWithUserID(
          date: calcData,
          userID: fixedUID,
        )) as List<FitbitHeartData>;
        final calCardio = heartData[indice].caloriesCardio;
        final calFatBurn = heartData[indice].caloriesFatBurn;
        final calOOR = heartData[indice].caloriesOutOfRange;
        final calPeak = heartData[indice].caloriesPeak;
        List<double?>? vect = [calCardio, calFatBurn, calOOR, calPeak];
        return vect;
      } else {
        List<double?>? vect = [0, 0, 0, 0];
        return vect;
      } // Endif lastData=dataint
    } else {
      List<double?>? vect = [0, 0, 0, 0];
      return vect;
    }
  }
}
*/

/*
  @override
  Widget build(BuildContext context) {
    print('${TrainingPage.routename} built');
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF75B7E1),
        appBar: AppBar(
          title: Text('Train with Eevee', style: TextStyle(fontSize: 25)),
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
        //body:
      ),
    );
  }
}
*/