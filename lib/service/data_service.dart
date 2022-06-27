import 'dart:convert';
import 'dart:ffi';

import 'package:flutter_weather_forecast/pages/model.dart';
import 'package:http/http.dart' as http;

class DataService {
  Future<WeatherResponse> getCurrentWeatherByLatLon(
      double lat, double lon) async {
    final queryParameters = {
      'lat': lat,
      'lon': lon,
      'appid': 'ce5288066fb41d132b0d04c767292984'
    };

    final uri = Uri.https(
      'api.openweathermap.org',
      '/data/2.5/onecall',
      queryParameters,
    );
    final response = await http.get(uri);

    print(response.body);
    final json = jsonDecode(response.body);
    return WeatherResponse.fromJson(json);
  }

  Future<WeatherResponse> getCurrentWeatherByCity(String city) async {
    final queryParameters = {
      'q': city,
      'units': 'imperial',
      'appid': 'ce5288066fb41d132b0d04c767292984'
    };

    final uri = Uri.https(
      'api.openweathermap.org',
      '/data/2.5/onecall',
      queryParameters,
    );
    final response = await http.get(uri);

    print(response.body);
    final json = jsonDecode(response.body);
    return WeatherResponse.fromJson(json);
  }

  getWeather(String text) {}
}
