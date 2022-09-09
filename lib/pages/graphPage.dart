import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:expenses/controllers/db_helper.dart';

import '../theme/static.dart'as Static;

class GraphPage extends StatefulWidget {
  const GraphPage({Key? key}) : super(key: key);

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  DbHelper dbHelper =DbHelper();
  DateTime today= DateTime.now();
  int totalBalance=0;
  int totalIncome=0;
  int totalExpense=0;
  List<FlSpot> dataSet=[];

  List<FlSpot> getPlotPoints(Map entireData){
    dataSet=[];
    entireData.forEach((key, value) {
      if(value['type'] == false && (value['DateTime'] as DateTime).year == today.year){
        dataSet.add (FlSpot( (value['DateTime'] as DateTime).day.toDouble(),
        (value['amount'] as int).toDouble() )
        );
      }
    });
    //print(dataSet);
    // return [
    //   FlSpot(3, 7),
    //   FlSpot(10, 8),
    //   FlSpot(5, 3),
    // ];
    return dataSet;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:FutureBuilder<Map>(
        future: dbHelper.fetch(),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return const Center(child: Text('Unexpected Error'),);
          } 
          if(snapshot.hasData){
            if(snapshot.data!.isEmpty){
              return const Center(
                child: Text("No Data Found!"),
              );
            }
            return Column(
              children:[
              const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                    'G R A P H',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Static.PrimaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                    ), 
                  ),
              const SizedBox(
              height: 15.0,
              ),
              Container(
              padding: EdgeInsets.all(10.0),
              height: 450.0,
              child: LineChart(
              LineChartData(
              borderData: FlBorderData(show: true),
              lineBarsData:[ LineChartBarData(
                spots: getPlotPoints(snapshot.data!),
                isCurved: false,
                barWidth: 2.5,
                colors: [
                  Static.PrimaryColor,
                ],
                )]
              )
              ),
              )
        
              ]
            );
          }
          else{
            return const Center(child: Text('Not Enough Occured'),);
          }                   
        }
      )
      );
  }
}