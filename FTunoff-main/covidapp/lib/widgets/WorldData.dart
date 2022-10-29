
// ignore_for_file: use_key_in_widget_constructors, file_names, unused_import, must_be_immutable, prefer_typing_uninitialized_variables, prefer_const_constructors

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Stat_Card.dart';

class Stat {
  final cases;
  final deaths;
  final recovered;
  final todayactive;
  final todaydeaths;
  final todaycases;
  final critical;
  final tests;
  Stat(
      {this.cases,
      this.deaths,
      this.recovered,
      this.todayactive,
      this.todaydeaths,
      this.todaycases,
      this.critical,
      this.tests});
}

class WorldData extends StatefulWidget {
  @override
  _WorldData createState() => _WorldData();
}

class _WorldData extends State<WorldData> {
  Stat stat = Stat(
    cases: 0,
    deaths: 0,
    recovered: 0,
    todayactive: 0,
    todaydeaths: 0,
    todaycases: 0,
  );

  void getStats() async {
    var url =
        Uri.parse("https://coronavirus-19-api.herokuapp.com/countries/world");

    var response = await http.get(url);

    var responseData = jsonDecode(response.body);
    setState(() {
      Stat obj = Stat(
        cases: responseData["cases"],
        deaths: responseData["deaths"],
        recovered: responseData["recovered"],
        todayactive: responseData["active"],
        todaydeaths: responseData["todayDeaths"],
        todaycases: responseData["todayCases"],
      );

      stat = obj;
    });
  }

  @override
  void initState() {
    super.initState();
    getStats();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: Column(
        children: [
          Container(
            margin:
                const EdgeInsets.only(top: 50, right: 5, left: 5, bottom: 10),
            child: Text(
              "World Statistics",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                  color: Colors.white,
                  fontStyle: FontStyle.normal),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stat_Card(
                  "Total Cases",
                  (int.parse(stat.cases.toString()) / 1000000)
                          .toStringAsFixed(2) +
                      " M",
                  const Color.fromRGBO(80, 200, 120, 1)),
              Stat_Card(
                  "Total Recovered",
                  (int.parse(stat.recovered.toString()) / 1000000)
                          .toStringAsFixed(2) +
                      " M",
                  const Color.fromRGBO(80, 200, 120, 1)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stat_Card(
                  "Total Deaths",
                  (int.parse(stat.deaths.toString()) / 1000000)
                          .toStringAsFixed(2) +
                      " M",
                  Color.fromRGBO(255, 191, 0, 1)),
              Stat_Card(
                  "Active",
                  (int.parse(stat.todayactive.toString()) / 1000000)
                          .toStringAsFixed(2) +
                      " M",
                  Color.fromRGBO(255, 191, 0, 1)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stat_Card(
                  "Deaths Today",
                  (int.parse(stat.todaydeaths.toString()) / 1000)
                          .toStringAsFixed(2) +
                      " K",
                  Colors.redAccent),
              Stat_Card(
                  "Cases Today",
                  (int.parse(stat.todaycases.toString()) / 1000000)
                          .toStringAsFixed(2) +
                      " M",
                  Colors.redAccent),
            ],
          )
        ],
      ),
    );
  }
}
