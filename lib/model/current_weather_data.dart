import 'package:flutter_weather_forecast/model/clouds.dart';
import 'package:flutter_weather_forecast/model/coord.dart';
import 'package:flutter_weather_forecast/model/main_weather.dart';
import 'package:flutter_weather_forecast/model/sys.dart';
import 'package:flutter_weather_forecast/model/weather.dart';
import 'package:flutter_weather_forecast/model/wind.dart';

class CurrentWeatherData {
  late Coord coord;
  late List<Weather> weather;
  late String base;
  late Main main;
  late int visibility;
  late Wind wind;
  late Clouds clouds;
  late int dt;
  late Sys sys;
  late int timezone;
  late int id;
  late String name;
  late int cod;

  CurrentWeatherData(
      {required this.coord,
      required this.weather,
      required this.base,
      required this.main,
      required this.visibility,
      required this.wind,
      required this.clouds,
      required this.dt,
      required this.sys,
      required this.timezone,
      required this.id,
      required this.name,
      required this.cod});

  CurrentWeatherData.fromJson(Map<String, dynamic> json) {
    coord = (json['coord'] != null ? Coord.fromJson(json['coord']) : null)!;
    if (json['weather'] != null) {
      weather = <Weather>[];
      json['weather'].forEach((v) {
        weather.add(Weather.fromJson(v));
      });
    }
    base = '';
    main = (json['main'] != null ? Main.fromJson(json['main']) : null)!;
    visibility = 0;
    wind = (json['wind'] != null ? Wind.fromJson(json['wind']) : null)!;
    clouds = (json['clouds'] != null ? Clouds.fromJson(json['clouds']) : null)!;
    dt = json['dt'];
    sys = (json['sys'] != null ? Sys.fromJson(json['sys']) : null)!;
    timezone = 0;
    id = 0;
    name = json['name'];
    cod = json['cod'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (coord != null) {
      data['coord'] = coord.toJson();
    }
    if (weather != null) {
      data['weather'] = weather.map((v) => v.toJson()).toList();
    }
    data['base'] = base;
    if (main != null) {
      data['main'] = main.toJson();
    }
    data['visibility'] = visibility;
    if (wind != null) {
      data['wind'] = wind.toJson();
    }
    if (clouds != null) {
      data['clouds'] = clouds.toJson();
    }
    data['dt'] = dt;
    if (sys != null) {
      data['sys'] = sys.toJson();
    }
    data['timezone'] = timezone;
    data['id'] = id;
    data['name'] = name;
    data['cod'] = cod;
    return data;
  }
}
