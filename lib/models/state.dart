import 'dart:convert';

import 'package:meta/meta.dart';

class States {
  States({
    @required this.state,
    @required this.updated,
    @required this.cases,
    @required this.todayCases,
    @required this.deaths,
    @required this.todayDeaths,
    @required this.recovered,
    @required this.active,
    @required this.casesPerOneMillion,
    @required this.deathsPerOneMillion,
    @required this.tests,
    @required this.testsPerOneMillion,
    @required this.population,
  });

  final String state;
  final int updated;
  final int cases;
  final int todayCases;
  final int deaths;
  final int todayDeaths;
  final int recovered;
  final int active;
  final dynamic casesPerOneMillion;
  final dynamic deathsPerOneMillion;
  final int tests;
  final dynamic testsPerOneMillion;
  final int population;

  factory States.fromRawJson(String str) => States.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory States.fromJson(Map<String, dynamic> json) => States(
        state: json["state"] == null ? null : json["state"],
        updated: json["updated"] == null ? null : json["updated"],
        cases: json["cases"] == null ? null : json["cases"],
        todayCases: json["todayCases"] == null ? null : json["todayCases"],
        deaths: json["deaths"] == null ? null : json["deaths"],
        todayDeaths: json["todayDeaths"] == null ? null : json["todayDeaths"],
        recovered: json["recovered"] == null ? null : json["recovered"],
        active: json["active"] == null ? null : json["active"],
        casesPerOneMillion: json["casesPerOneMillion"] == null ? null : json["casesPerOneMillion"],
        deathsPerOneMillion: json["deathsPerOneMillion"] == null ? null : json["deathsPerOneMillion"],
        tests: json["tests"] == null ? null : json["tests"],
        testsPerOneMillion: json["testsPerOneMillion"] == null ? null : json["testsPerOneMillion"],
        population: json["population"] == null ? null : json["population"],
      );

  Map<String, dynamic> toJson() => {
        "state": state == null ? null : state,
        "updated": updated == null ? null : updated,
        "cases": cases == null ? null : cases,
        "todayCases": todayCases == null ? null : todayCases,
        "deaths": deaths == null ? null : deaths,
        "todayDeaths": todayDeaths == null ? null : todayDeaths,
        "recovered": recovered == null ? null : recovered,
        "active": active == null ? null : active,
        "casesPerOneMillion": casesPerOneMillion == null ? null : casesPerOneMillion,
        "deathsPerOneMillion": deathsPerOneMillion == null ? null : deathsPerOneMillion,
        "tests": tests == null ? null : tests,
        "testsPerOneMillion": testsPerOneMillion == null ? null : testsPerOneMillion,
        "population": population == null ? null : population,
      };
}
