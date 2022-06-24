/*
{
{
  "lat": 33.44,
  "lon": -94.04,
  "timezone": "America/Chicago",
  "current": {
    "temp": 284.07,
    "weather": [
      {
        "id": 500,
        "main": "Rain",
        "icon": "10d"
      }
    ],
  },
*/

class WeatherResponse {
  final String cityName;

  WeatherResponse({required this.cityName});

  factory WeatherResponse.fromJson(Map<String, dynamic> json){
    final cityName = json['timezone'];
    return WeatherResponse(cityName: cityName);
  }

}