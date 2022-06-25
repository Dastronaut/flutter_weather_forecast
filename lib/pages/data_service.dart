import 'dart:convert';
import 'dart:ffi';

import 'package:flutter_weather_forecast/pages/model.dart';
import 'package:http/http.dart' as http;
class DataService{
  Future<WeatherResponse> getWeather(String city) async{
    // https://api.openweathermap.org/data/2.5/onecall?lat=33.44&lon=-94.04&exclude=hourly,daily&appid=07ae6c80431f35e89b399f5025ca9dbf
    // https://api.openweathermap.org/data/2.5/weather?q=LonDon&appid=07ae6c80431f35e89b399f5025ca9dbf
    final queryParameters = {
      // 'a': 'lat',
      // 'o': 'lon',
      'q' : city,
      'units' : 'imperial',
      'appid': '07ae6c80431f35e89b399f5025ca9dbf'
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
}