import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tamafake/repository/databaseRepository.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamafake/utils/indicator.dart';
import 'package:tamafake/screens/homepage.dart';

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
    _loadData(context).then((result) => {
          // Once we receive our name we trigger rebuild.
          setState(() {
            datarec = result;
          }),
        });
  }

  int? touchedIndex;
  //final calCard = datarec.calCardio;
  //double calCardio = datarec?[0] ?? -1

  @override
  Widget build(BuildContext context) {
    double caltot =
        (datarec?[0] ?? -1) + (datarec?[1] ?? -1) + (datarec?[2] ?? -1);
    double calCardio = (((datarec?[0] ?? -1) * 100) / caltot).roundToDouble();
    double calFatBurn =
        (((datarec?[1] ?? -1) * 100) / caltot).truncateToDouble();
    double calPeak = (((datarec?[2] ?? -1) * 100) / caltot).truncateToDouble();
    int lastdataint = (datarec?[3] ?? 0).toInt();

    //Se non abbiamo ancora caricato i dati rimandiamo alla pagina di home
    if (datarec == null) {
      return MaterialApp(
        //title: 'TamaFa Training',
        theme: ThemeData(primaryColor: const Color.fromARGB(255, 230, 67, 121)),
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 230, 67, 121),
            centerTitle: true,
            title: const Text('Authorization', style: TextStyle(fontSize: 25)),
            leading: Builder(
              builder: (BuildContext context) {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    backgroundColor: const Color.fromARGB(255, 230, 67, 121),
                    title: const Text('Attention!',
                        style: TextStyle(color: Colors.white)),
                    content: const Text('You have to upload your data first! ',
                        style: TextStyle(color: Colors.white)),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage())),
                        child: const Text('Home',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
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
        ),
      );
    } else {
      return MaterialApp(
        //title: 'TamaFa Training',
        theme: ThemeData(primaryColor: const Color.fromARGB(255, 230, 67, 121)),
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 230, 67, 121),
            centerTitle: true,
            title: const Text('Authorization', style: TextStyle(fontSize: 25)),
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
          body: Column(
            children: <Widget>[
              const SizedBox(
                height: 28,
              ),
              Text('Types of calories that you consumed $lastdataint:'),
              const SizedBox(
                height: 28,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const <Widget>[
                  Indicator(
                    color: Color.fromARGB(255, 238, 222, 2),
                    text: 'Cardio',
                    isSquare: false,
                    size: 18,
                    textColor: Colors.black,
                  ),
                  Indicator(
                    color: Color.fromARGB(255, 19, 77, 211),
                    text: 'FatBurn',
                    isSquare: false,
                    size: 18,
                    textColor: Colors.black,
                    //size: touchedIndex == 1 ? 18 : 16,
                    //textColor: touchedIndex == 1 ? Colors.black : Colors.grey,
                  ),
                  Indicator(
                    color: Color.fromARGB(255, 209, 121, 121),
                    text: 'Peak',
                    isSquare: false,
                    size: 18,
                    textColor: Colors.black,
                    //size: touchedIndex == 2 ? 18 : 16,
                    //textColor: touchedIndex == 2 ? Colors.black : Colors.grey,
                  ),
                ],
              ),
              /* const SizedBox(
              height: 5,
            ), */
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                          pieTouchData: PieTouchData(touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
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
                          startDegreeOffset: 180,
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 1,
                          centerSpaceRadius: 0,
                          sections: showingSections()),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  Text(
                      "Calories Cardio: $calCardio"
                      "\n"
                      "Calories FatBurn: $calFatBurn"
                      "\n"
                      "Calories Peak: $calPeak",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                      )),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      3,
      (i) {
        final isTouched = i == touchedIndex;
        final opacity = isTouched ? 1.0 : 0.6;

        const color0 = Color.fromARGB(255, 238, 222, 2);
        const color1 = Color.fromARGB(255, 19, 77, 211);
        const color2 = Color.fromARGB(255, 209, 121, 121);

        double caltot =
            (datarec?[0] ?? -1) + (datarec?[1] ?? -1) + (datarec?[2] ?? -1);
        double calCardio =
            (((datarec?[0] ?? -1) * 100) / caltot).roundToDouble();
        double calFatBurn =
            (((datarec?[1] ?? -1) * 100) / caltot).truncateToDouble();
        double calPeak =
            (((datarec?[2] ?? -1) * 100) / caltot).truncateToDouble();

        print('calorie cardio: $calCardio');
        print('calorie FatBurn: $calFatBurn');
        print('calorie di Picco: $calPeak');

        switch (i) {
          case 0:
            return PieChartSectionData(
              color: color0.withOpacity(opacity),
              value: calCardio,
              title: '$calCardio%',
              radius: 110,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 26, 25, 25)),
              titlePositionPercentageOffset: 0.55,
            );
          case 1:
            return PieChartSectionData(
              color: color1.withOpacity(opacity),
              value: calFatBurn,
              title: '$calFatBurn%',
              radius: 108,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 26, 25, 25)),
              titlePositionPercentageOffset: 0.55,
            );
          case 2:
            return PieChartSectionData(
              color: color2.withOpacity(opacity),
              value: calPeak,
              title: '$calPeak%',
              radius: 106,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 26, 25, 25)),
              titlePositionPercentageOffset: 0.6,
            );
          default:
            throw Error();
        }
      },
    );
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
          datarec.calPeak,
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
