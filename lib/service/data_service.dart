import 'dart:convert';
import 'dart:ffi';

import 'package:flutter_weather_forecast/model/current_weather_data.dart';
import 'package:http/http.dart' as http;

class DataService {
  static const String _apiKey = '189df97f5958253ef6c38a94537fa094';

  Future<CurrentWeatherData> getCurrentWeatherByLatLon(
      {required double lat, required double lon}) async {
    final queryParameters = {
      'lat': lat.toString(),
      'lon': lon.toString(),
      'units': 'metric',
      'lang': 'vi',
      'appid': _apiKey
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

  Future<CurrentWeatherData> getCurrentWeatherByCity(
      {required String city}) async {
    final queryParameters = {
      'q': city,
      'units': 'metric',
      'lang': 'vi',
      'appid': _apiKey
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
    return CurrentWeatherData.fromJson(json);
  }

  static Future<List<String>> searchCities({required String query}) async {
    const limit = 5;

    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/geo/1.0/direct?q=$query&limit=$limit&appid=$_apiKey'));
    final body = json.decode(response.body);

    return body.map<String>((json) {
      final city = json['name'];
      final country = json['country'];

      return '$city, $country';
    }).toList();
  }

  void getFiveDaysThreeHoursForcastData() {}
}
