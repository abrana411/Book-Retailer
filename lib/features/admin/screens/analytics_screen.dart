import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../models/sale_model.dart';
import '../services/admin_services.dart';
import '../../../constants/screen_loader.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  AdminServices adminServices = AdminServices();
  int? totalEarnings = 0;
  List<BarChartGroupData>? catEarnings;
  // List<String>? titles;

  void getAnalyticsOfListedProducts() async {
    await adminServices.getAnalyticsOfListedProducts(context: context);
  }

  @override
  void initState() {
    getAnalyticsOfListedProducts();
    super.initState();
    // getTheAnalyticsData();
  }

  //getter(needed a getter only) to get title corresponding to x axis int value:-
  SideTitles get _bottomTitles => SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        String text = '';
        switch (value.toInt()) {
          case 0:
            text = 'Mobiles';
            break;
          case 1:
            text = 'Essentials';
            break;
          case 2:
            text = 'Books';
            break;
          case 3:
            text = 'Appliances';
            break;
          case 4:
            text = 'Fashion';
            break;
        }

        return Text(text);
      });

  void getTheAnalyticsData() async {
    final data = await adminServices.getAnalyticsData(context: context);
    //data is a map now , so below getting the totalEarnings and the list
    totalEarnings = data['totalEarnings'];
    final List<Sale> sales = data['sales'];
    catEarnings = [];
    for (int i = 0; i < sales.length; i++) {
      final Sale currCatEarn = sales[i];
      catEarnings!.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
                toY: double.parse(currCatEarn.earnings.toString()),
                width: 15,
                color: Colors.red),
          ],
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // return (catEarnings == null || totalEarnings == null)
    //     ? const ScreenLoader()
    //     : Container(
    //         margin: const EdgeInsets.only(top: 50),
    //         padding: const EdgeInsets.all(20),
    //         height: 300,
    //         child: BarChart(BarChartData(
    //             gridData: FlGridData(show: false),
    //             borderData: FlBorderData(
    //               border: const Border(
    //                 top: BorderSide.none,
    //                 right: BorderSide.none,
    //                 left: BorderSide(width: 1),
    //                 bottom: BorderSide(width: 1),
    //               ),
    //             ),
    //             groupsSpace: 10,
    //             titlesData: FlTitlesData(
    //               bottomTitles: AxisTitles(sideTitles: _bottomTitles),
    //               leftTitles:
    //                   AxisTitles(sideTitles: SideTitles(showTitles: false)),
    //               topTitles:
    //                   AxisTitles(sideTitles: SideTitles(showTitles: false)),
    //               rightTitles:
    //                   AxisTitles(sideTitles: SideTitles(showTitles: false)),
    //             ),
    //             // add bars
    //             barGroups: catEarnings)),
    //       );

    return Scaffold(
      body: Container(
        child: Text('Hello'),
      ),
    );
  }
}
