// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, camel_case_types, file_names, deprecated_member_use, prefer_typing_uninitialized_variables, must_be_immutable, avoid_init_to_null, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../widgets/WorldData.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'GoToNext.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  RegExp regex = RegExp(
      "((?<=(?:[\u2700-\u27bf]|(?:\ud83c[\udde6-\uddff]){2}|[\ud800-\udbff][\udc00-\udfff])[\ufe0e\ufe0f]?(?:[\u0300-\u036f\ufe20-\ufe23\u20d0-\u20f0]|\ud83c[\udffb-\udfff])?(?:\u200d(?:[^\ud800-\udfff]|(?:\ud83c[\udde6-\uddff]){2}|[\ud800-\udbff][\udc00-\udfff])[\ufe0e\ufe0f]?(?:[\u0300-\u036f\ufe20-\ufe23\u20d0-\u20f0]|\ud83c[\udffb-\udfff])?)*)|(?=(?:[\u2700-\u27bf]|(?:\ud83c[\udde6-\uddff]){2}|[\ud800-\udbff][\udc00-\udfff])[\ufe0e\ufe0f]?(?:[\u0300-\u036f\ufe20-\ufe23\u20d0-\u20f0]|\ud83c[\udffb-\udfff])?(?:\u200d(?:[^\ud800-\udfff]|(?:\ud83c[\udde6-\uddff]){2}|[\ud800-\udbff][\udc00-\udfff])[\ufe0e\ufe0f]?(?:[\u0300-\u036f\ufe20-\ufe23\u20d0-\u20f0]|\ud83c[\udffb-\udfff])?)*))");
  String? chosenCountry = null,
      chosenState = null,
      chosenCity = null,
      response = "";

  Stat stat = Stat(
    cases: null,
    deaths: null,
    recovered: null,
    todayactive: null,
    todaydeaths: null,
    todaycases: null,
    critical: null,
    tests: null,
  );

  void getStats(String country) async {
    var url = Uri.parse(
        "https://coronavirus-19-api.herokuapp.com/countries/$country");

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
          critical: responseData["critical"],
          tests: responseData["totalTests"]);

      stat = obj;
    });
  }

  void getError(country) {
    setState(() {
      response = country;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   toolbarHeight: 40,
      //   title: Center(
      //       child: const Text(
      //     "Covid Tracker App",
      //     style: TextStyle(
      //         color: Color.fromRGBO(39, 105, 171, 1), fontFamily: 'Nunito'),
      //   )),
      //   backgroundColor: Colors.white,
      // ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: const [
                Color.fromRGBO(127, 127, 213, 1),
                Color.fromRGBO(134, 168, 231, 1),
                Color.fromRGBO(145, 234, 228, 1)
              ],
              //begin: FractionalOffset.bottomCenter,
              //end: FractionalOffset.topCenter,
            ),
          ),
          child: Column(
            children: <Widget>[
              WorldData(),
              Container(
                margin: const EdgeInsets.only(
                    top: 20, right: 5, left: 5, bottom: 10),
                child: Text(
                  "Search by region",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 15,
                      fontFamily: 'Nunito',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal),
                ),
              ),
              Card(
                margin: EdgeInsets.only(right: 15, left: 15),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: const [
                            Color.fromRGBO(201, 214, 255, 1),
                            Color.fromRGBO(226, 226, 226, 1)
                            //Colors.lightGreen,
                          ])),
                  padding: EdgeInsets.all(20),
                  child: SelectState(
                    onCountryChanged: (value) {
                      setState(() {
                        chosenCountry = value.split(regex)[2].trim();
                        response = "";
                        getStats(chosenCountry.toString());
                      });
                    },
                    onStateChanged: (value) {
                      setState(() {
                        chosenState = value;
                        response = "";
                      });
                    },
                    onCityChanged: (value) {
                      setState(() {
                        chosenCity = value;
                        response = "";
                      });
                    },
                  ),
                ),
              ),
              Container(
                child: Text(
                  response.toString(),
                  style: TextStyle(color: Colors.red),
                ),
                margin: EdgeInsets.only(top: 10, bottom: 10),
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                textColor: Colors.white,
                onPressed: () {
                  if (chosenCountry != null &&
                      chosenState != "Choose State" &&
                      chosenState != null &&
                      chosenCity != "Choose City" &&
                      chosenCity != null) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GoToNext(
                            chosenCountry.toString(),
                            chosenState.toString(),
                            chosenCity.toString(),
                            stat.cases.toString(),
                            stat.deaths.toString(),
                            stat.recovered.toString(),
                            stat.todayactive.toString(),
                            stat.todaydeaths.toString(),
                            stat.todaycases.toString(),
                            stat.critical.toString(),
                            stat.tests.toString())));
                  } else if (chosenCountry == null &&
                      chosenState == null &&
                      chosenCity == null) {
                    getError(
                      'Please select Country, State, City',
                    );
                  } else if (chosenCountry != null &&
                      chosenState == null &&
                      chosenState != "Choose State" &&
                      chosenCity != "Choose City" &&
                      chosenCity == null) {
                    getError("Please select State, City");
                  } else if (chosenCountry != null &&
                      chosenState != null &&
                      chosenCity != "Choose City" &&
                      chosenCity == null) {
                    getError("Please select City");
                  }
                },
                child: Text("Search",
                    style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: MediaQuery.of(context).size.width / 25)),
                // color: Color.fromRGBO(50, 100, 170, 1),
                color: Colors.blue.shade800,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
