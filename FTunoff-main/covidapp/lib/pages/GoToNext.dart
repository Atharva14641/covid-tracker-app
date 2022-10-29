// ignore_for_file: use_key_in_widget_constructors, file_names, unused_import, must_be_immutable, prefer_typing_uninitialized_variables, avoid_unnecessary_containers, non_constant_identifier_names, unused_field, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:convert';
import '../widgets/Stat_Card.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class GoToNext extends StatelessWidget {
  final String country,
      state,
      city,
      cases,
      deaths,
      recovered,
      active,
      todaydeaths,
      todaycases,
      critical,
      tests;
  const GoToNext(
      this.country,
      this.state,
      this.city,
      this.cases,
      this.deaths,
      this.recovered,
      this.active,
      this.todaydeaths,
      this.todaycases,
      this.critical,
      this.tests);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          country,
          style: const TextStyle(fontFamily: 'Nunito'),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(37, 105, 171, 1),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromRGBO(127, 127, 213, 1),
                Color.fromRGBO(134, 168, 231, 1),
                Color.fromRGBO(145, 234, 228, 1)
              ],
              //begin: FractionalOffset.bottomCenter,
              //end: FractionalOffset.topCenter,
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 15, right: 5, left: 5, bottom: 5),
                child: Text(
                  "Your Location : " +
                      city.toString() +
                      ", " +
                      state.toString(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 28,
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Nunito'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stat_Card(
                      "Total Cases",
                      (int.parse(cases.toString()) / 1000000)
                              .toStringAsFixed(2) +
                          " M",
                      Color.fromRGBO(80, 200, 120, 1)),
                  Stat_Card(
                      "Total Recovered",
                      (int.parse(recovered.toString()) / 1000000)
                              .toStringAsFixed(2) +
                          " M",
                      Color.fromRGBO(80, 200, 120, 1)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stat_Card(
                      "Total Deaths",
                      (int.parse(deaths.toString()) / 1000).toStringAsFixed(2) +
                          " K",
                      Color.fromRGBO(255, 191, 0, 1)),
                  Stat_Card(
                      "Active",
                      (int.parse(active.toString()) / 1000).toStringAsFixed(2) +
                          " K",
                      Color.fromRGBO(255, 191, 0, 1)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stat_Card(
                      "Deaths Today", todaydeaths.toString(), Colors.redAccent),
                  Stat_Card(
                      "Cases Today", todaycases.toString(), Colors.redAccent),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stat_Card(
                      "Critical",
                      (int.parse(critical.toString()) / 1000)
                              .toStringAsFixed(2) +
                          " K",
                      Color.fromRGBO(255, 203, 164, 1)),
                  Stat_Card(
                      "Total Tests",
                      (int.parse(tests.toString()) / 1000000)
                              .toStringAsFixed(2) +
                          " M",
                      Color.fromRGBO(255, 203, 164, 1)),
                ],
              ),
              MyChart(cases.toString(), deaths.toString(), recovered.toString(),
                  tests.toString())
            ],
          ),
        ),
      ),
    );
  }
}

class MyChart extends StatefulWidget {
  final String Cases, Deaths, Recovered, tests;
  const MyChart(this.Cases, this.Deaths, this.Recovered, this.tests);
  @override
  _MyChartState createState() => _MyChartState();
}

class _MyChartState extends State<MyChart> {
  late List<CasesData> _chartData;
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  List<CasesData> getChartData() {
    final List<CasesData> chartData = [
      CasesData("Total Cases", int.parse(widget.Cases)),
      CasesData("Total Deaths", int.parse(widget.Deaths)),
      CasesData("Total Recovered", int.parse(widget.Recovered)),
      CasesData("Total Tests", int.parse(widget.tests))
    ];
    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 50),
      child: SfCircularChart(
        title: ChartTitle(
            text: "Covid Statistics",
            textStyle: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.normal,
                fontSize: MediaQuery.of(context).size.width / 18,
                fontFamily: 'Nunito')),
        tooltipBehavior: _tooltipBehavior,
        legend:
            Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
        series: <CircularSeries>[
          PieSeries<CasesData, String>(
              dataSource: _chartData,
              xValueMapper: (CasesData Data, _) => Data.datatype,
              yValueMapper: (CasesData Data, _) => Data.data,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              enableTooltip: true),
        ],
      ),
    );
  }
}

class CasesData {
  CasesData(this.datatype, this.data);
  final String datatype;
  final int data;
}
