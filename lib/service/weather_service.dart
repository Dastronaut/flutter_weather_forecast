import 'package:flutter/foundation.dart';

class WeatherService {
  double lat;
  double lon;
  String baseUrl = 'https://api.openweathermap.org/data/2.5/onecall';
  String apiKey = 'appid=ce5288066fb41d132b0d04c767292984';
  WeatherService({
    required this.lat,
    required this.lon,
  });

  void getCurrentWeatherData() {
    final url = '$baseUrl/onecall?lat=$lat&lon=$lon&lang=vi&$apiKey';
    ApiRepository(url: '$url', payload: null).get(
        beforeSend: () => {
              if (beforSend != null)
                {
                  beforSend(),
                },
            },
        onSuccess: (data) => {
              onSuccess(CurrentWeatherData.fromJson(data)),
            },
        onError: (error) => {
              if (onError != null)
                {
                  print(error),
                  onError(error),
                }
            });
  }

  void getFiveDaysThreeHoursForcastData({
    Function() beforSend,
    Function(List<FiveDayData> fiveDayData) onSuccess,
    Function(dynamic error) onError,
  }) {
    final url = '$baseUrl/forecast?q=$city&lang=en&$apiKey';
    print(url);
    ApiRepository(url: '$url', payload: null).get(
        beforeSend: () => {},
        onSuccess: (data) => {
              onSuccess((data['list'] as List)
                      ?.map((t) => FiveDayData.fromJson(t))
                      ?.toList() ??
                  List.empty()),
            },
        onError: (error) => {
              print(error),
              onError(error),
            });
  }
}
