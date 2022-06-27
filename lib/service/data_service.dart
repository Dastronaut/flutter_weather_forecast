import 'dart:convert';
import 'dart:ffi';

import 'package:flutter_weather_forecast/model/current_weather_data.dart';
import 'package:flutter_weather_forecast/model/model.dart';
import 'package:http/http.dart' as http;

class DataService {
  Future<CurrentWeatherData> getCurrentWeatherByLatLon(
      String lat, String lon) async {
    final queryParameters = {
      'lat': lat,
      'lon': lon,
      'units': 'metric',
      'lang': 'vi',
      'appid': 'ce5288066fb41d132b0d04c767292984'
    };

    final uri = Uri.https(
      'api.openweathermap.org',
      '/data/2.5/weather',
      queryParameters,
    );
    final response = await http.get(uri);
    print(uri);
    final json = jsonDecode(response.body);
    print(response.body);
    return CurrentWeatherData.fromJson(json);
  }

  Future<WeatherResponse> getCurrentWeatherByCity(String city) async {
    final queryParameters = {
      'q': city,
      'units': 'metric',
      'lang': 'vi',
      'appid': 'ce5288066fb41d132b0d04c767292984'
    };

    final uri = Uri.https(
      'api.openweathermap.org',
      '/data/2.5/weather',
      queryParameters,
    );

    final response = await http.get(uri);
    print(uri);
    print(response.body);
    final json = jsonDecode(response.body);
    return WeatherResponse.fromJson(json);
  }

  void getFiveDaysThreeHoursForcastData() {}
}
