import 'dart:convert';

class Country {
  Country({
    required this.updated,
    required this.country,
    required this.countryInfo,
    required this.cases,
    required this.todayCases,
    required this.deaths,
    required this.todayDeaths,
    required this.recovered,
    required this.todayRecovered,
    required this.active,
    required this.critical,
    required this.casesPerOneMillion,
    required this.deathsPerOneMillion,
    required this.tests,
    required this.testsPerOneMillion,
    required this.population,
    required this.continent,
    required this.oneCasePerPeople,
    required this.oneDeathPerPeople,
    required this.oneTestPerPeople,
    required this.activePerOneMillion,
    required this.recoveredPerOneMillion,
    required this.criticalPerOneMillion,
  });

  final int updated;
  final String country;
  final CountryInfo countryInfo;
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
  final String continent;
  final dynamic oneCasePerPeople;
  final dynamic oneDeathPerPeople;
  final dynamic oneTestPerPeople;
  final dynamic activePerOneMillion;
  final dynamic recoveredPerOneMillion;
  final dynamic criticalPerOneMillion;

  factory Country.fromRawJson(String str) => Country.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        updated: json["updated"],
        country: json["country"],
        countryInfo: CountryInfo.fromJson(json["countryInfo"]),
        cases: json["cases"],
        todayCases: json["todayCases"],
        deaths: json["deaths"],
        todayDeaths: json["todayDeaths"],
        recovered: json["recovered"],
        todayRecovered: json["todayRecovered"],
        active: json["active"],
        critical: json["critical"],
        casesPerOneMillion: json["casesPerOneMillion"],
        deathsPerOneMillion: json["deathsPerOneMillion"],
        tests: json["tests"],
        testsPerOneMillion: json["testsPerOneMillion"],
        population: json["population"],
        continent: json["continent"],
        oneCasePerPeople: json["oneCasePerPeople"],
        oneDeathPerPeople: json["oneDeathPerPeople"],
        oneTestPerPeople: json["oneTestPerPeople"],
        activePerOneMillion: json["activePerOneMillion"].toDouble(),
        recoveredPerOneMillion: json["recoveredPerOneMillion"].toDouble(),
        criticalPerOneMillion: json["criticalPerOneMillion"],
      );

  Map<String, dynamic> toJson() => {
        "updated": updated,
        "country": country,
        "countryInfo": countryInfo,
        "cases": cases,
        "todayCases": todayCases,
        "deaths": deaths,
        "todayDeaths": todayDeaths,
        "recovered": recovered,
        "todayRecovered": todayRecovered,
        "active": active,
        "critical": critical,
        "casesPerOneMillion": casesPerOneMillion,
        "deathsPerOneMillion": deathsPerOneMillion,
        "tests": tests,
        "testsPerOneMillion": testsPerOneMillion,
        "population": population,
        "continent": continent,
        "oneCasePerPeople": oneCasePerPeople == null ? null : oneCasePerPeople,
        "oneDeathPerPeople": oneDeathPerPeople == null ? null : oneDeathPerPeople,
        "oneTestPerPeople": oneTestPerPeople == null ? null : oneTestPerPeople,
        "activePerOneMillion": activePerOneMillion == null ? null : activePerOneMillion,
        "recoveredPerOneMillion": recoveredPerOneMillion == null ? null : recoveredPerOneMillion,
        "criticalPerOneMillion": criticalPerOneMillion == null ? null : criticalPerOneMillion,
      };
}

class CountryInfo {
  CountryInfo({
    required this.id,
    required this.iso2,
    required this.iso3,
    required this.lat,
    required this.long,
    required this.flag,
  });

  final int id;
  final String iso2;
  final String iso3;
  final dynamic lat;
  final dynamic long;
  final String flag;

  factory CountryInfo.fromRawJson(String str) => CountryInfo.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory CountryInfo.fromJson(Map<String, dynamic> json) => CountryInfo(
        id: json["_id"],
        iso2: json["iso2"],
        iso3: json["iso3"],
        lat: json["lat"],
        long: json["long"],
        flag: json["flag"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "iso2": iso2,
        "iso3": iso3,
        "lat": lat,
        "long": long,
        "flag": flag,
      };
}
