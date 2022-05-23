import 'dart:convert';

import 'package:meta/meta.dart';

class Global {
  final int updated;
  final int cases;
  final int todayCases;
  final int deaths;
  final int todayDeaths;
  final int recovered;
  final int todayRecovered;
  final int active;
  final int critical;
  final dynamic casesPerOneMillion;
  final dynamic deathsPerOneMillion;
  final int tests;
  final dynamic testsPerOneMillion;
  final int population;
  final dynamic oneCasePerPeople;
  final dynamic oneDeathPerPeople;
  final dynamic oneTestPerPeople;
  final dynamic activePerOneMillion;
  final dynamic recoveredPerOneMillion;
  final dynamic criticalPerOneMillion;
  final int affectedCountries;

  Global({
    @required this.updated,
    @required this.cases,
    @required this.todayCases,
    @required this.deaths,
    @required this.todayDeaths,
    @required this.recovered,
    @required this.todayRecovered,
    @required this.active,
    @required this.critical,
    @required this.casesPerOneMillion,
    @required this.deathsPerOneMillion,
    @required this.tests,
    @required this.testsPerOneMillion,
    @required this.population,
    @required this.oneCasePerPeople,
    @required this.oneDeathPerPeople,
    @required this.oneTestPerPeople,
    @required this.activePerOneMillion,
    @required this.recoveredPerOneMillion,
    @required this.criticalPerOneMillion,
    @required this.affectedCountries,
  });

  factory Global.fromRawJson(String str) => Global.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory Global.fromJson(Map<String, dynamic> json) => Global(
        updated: json["updated"] == null ? null : json["updated"],
        cases: json["cases"] == null ? null : json["cases"],
        todayCases: json["todayCases"] == null ? null : json["todayCases"],
        deaths: json["deaths"] == null ? null : json["deaths"],
        todayDeaths: json["todayDeaths"] == null ? null : json["todayDeaths"],
        recovered: json["recovered"] == null ? null : json["recovered"],
        todayRecovered: json["todayRecovered"] == null ? null : json["todayRecovered"],
        active: json["active"] == null ? null : json["active"],
        critical: json["critical"] == null ? null : json["critical"],
        casesPerOneMillion: json["casesPerOneMillion"] == null ? null : json["casesPerOneMillion"],
        deathsPerOneMillion: json["deathsPerOneMillion"] == null ? null : json["deathsPerOneMillion"],
        tests: json["tests"] == null ? null : json["tests"],
        testsPerOneMillion: json["testsPerOneMillion"] == null ? null : json["testsPerOneMillion"],
        population: json["population"] == null ? null : json["population"],
        oneCasePerPeople: json["oneCasePerPeople"] == null ? null : json["oneCasePerPeople"],
        oneDeathPerPeople: json["oneDeathPerPeople"] == null ? null : json["oneDeathPerPeople"],
        oneTestPerPeople: json["oneTestPerPeople"] == null ? null : json["oneTestPerPeople"],
        activePerOneMillion: json["activePerOneMillion"] == null ? null : json["activePerOneMillion"],
        recoveredPerOneMillion: json["recoveredPerOneMillion"] == null ? null : json["recoveredPerOneMillion"],
        criticalPerOneMillion: json["criticalPerOneMillion"] == null ? null : json["criticalPerOneMillion"],
        affectedCountries: json["affectedCountries"] == null ? null : json["affectedCountries"],
      );

  Map<String, dynamic> toJson() => {
        "updated": updated == null ? null : updated,
        "cases": cases == null ? null : cases,
        "todayCases": todayCases == null ? null : todayCases,
        "deaths": deaths == null ? null : deaths,
        "todayDeaths": todayDeaths == null ? null : todayDeaths,
        "recovered": recovered == null ? null : recovered,
        "todayRecovered": todayRecovered == null ? null : todayRecovered,
        "active": active == null ? null : active,
        "critical": critical == null ? null : critical,
        "casesPerOneMillion": casesPerOneMillion == null ? null : casesPerOneMillion,
        "deathsPerOneMillion": deathsPerOneMillion == null ? null : deathsPerOneMillion,
        "tests": tests == null ? null : tests,
        "testsPerOneMillion": testsPerOneMillion == null ? null : testsPerOneMillion,
        "population": population == null ? null : population,
        "oneCasePerPeople": oneCasePerPeople == null ? null : oneCasePerPeople,
        "oneDeathPerPeople": oneDeathPerPeople == null ? null : oneDeathPerPeople,
        "oneTestPerPeople": oneTestPerPeople == null ? null : oneTestPerPeople,
        "activePerOneMillion": activePerOneMillion == null ? null : activePerOneMillion,
        "recoveredPerOneMillion": recoveredPerOneMillion == null ? null : recoveredPerOneMillion,
        "criticalPerOneMillion": criticalPerOneMillion == null ? null : criticalPerOneMillion,
        "affectedCountries": affectedCountries == null ? null : affectedCountries,
      };
}
