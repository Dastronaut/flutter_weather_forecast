import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_weather_forecast/common/sub_weather_item.dart';
import 'package:flutter_weather_forecast/common/theme_helper.dart';
import 'package:flutter_weather_forecast/model/current_weather_data.dart';
import 'package:flutter_weather_forecast/service/data_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? _currentPosition;
  late LocationPermission permission;
  final _dataService = DataService();
  Future<CurrentWeatherData>? currentWeatherData;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low)
        .then((position) {
      setState(() {
        _currentPosition = position;
        // currentWeatherData = _dataService.getCurrentWeatherByLatLon(
        //     _currentPosition!.latitude.toString(),
        //     _currentPosition!.longitude.toString());
        currentWeatherData =
            _dataService.getCurrentWeatherByLatLon('35.1', '139.1');
      });
    }).catchError((e) {
      print(e);
    });
  }

  // _search() async {
  //   final response = await _dataService.getWeather(_cityTextController.text);
  //   setState(() => _response = response);
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: FutureBuilder<CurrentWeatherData>(
          future: currentWeatherData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              CurrentWeatherData _currentWeather = snapshot.data!;
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/cloud-in-blue-sky.jpg'),
                    fit: BoxFit.cover,
                    opacity: 0.8,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        height: 210,
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Center(
                                  child: Text(
                                    _currentWeather.name.toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                          color: Colors.black45,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'flutterfonts',
                                        ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        _currentWeather.weather[0].description,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .copyWith(
                                              color: Colors.black45,
                                              fontSize: 22,
                                              fontFamily: 'flutterfonts',
                                            ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        '${(_currentWeather.main.temp).round().toString()}\u2103',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2!
                                            .copyWith(
                                                color: Colors.black45,
                                                fontFamily: 'flutterfonts'),
                                      ),
                                      Text(
                                        'Cao: ${(_currentWeather.main.tempMin).round().toString()}\u2103 / Thấp: ${(_currentWeather.main.tempMax).round().toString()}\u2103',
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .copyWith(
                                              color: Colors.black45,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'flutterfonts',
                                            ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: 120,
                                          height: 120,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/icon-01.jpg'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Gió ${_currentWeather.wind.speed} m/s',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(
                                                color: Colors.black45,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'flutterfonts',
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      GridView.count(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(20),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 2,
                        children: <Widget>[
                          SubWeather(
                            icon: Icons.device_thermostat,
                            title: 'Cảm nhận',
                            value:
                                '${_currentWeather.main.feelsLike.toString()}\u2103',
                            description: '',
                          ),
                          SubWeather(
                            icon: Icons.speed_outlined,
                            title: 'Áp suất',
                            value:
                                '${_currentWeather.main.pressure.toString()} hPa',
                            description: _currentWeather.main.pressure > 1010
                                ? 'Áp suất cao'
                                : 'Áp suất thấp',
                          ),
                          SubWeather(
                            icon: Icons.water_drop_outlined,
                            title: 'Độ ẩm',
                            value:
                                '${_currentWeather.main.humidity.toString()} %',
                            description: '',
                          ),
                          SubWeather(
                            icon: Icons.waves_outlined,
                            title: 'Tốc độ gió',
                            value:
                                '${_currentWeather.wind.speed.toString()} km/h',
                            description: '',
                          ),
                          SubWeather(
                            icon: Icons.sunny_snowing,
                            title: 'Mặt trời mọc',
                            value: _currentWeather.sys.sunrise,
                            description:
                                'Mặt trời lặn: ${_currentWeather.sys.sunset}',
                          ),
                          SubWeather(
                            icon: Icons.sunny_snowing,
                            title: 'Mặt trời mọc',
                            value: _currentWeather.sys.sunrise,
                            description:
                                'Mặt trời lặn: ${_currentWeather.sys.sunset}',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

_location(CurrentWeatherData weatherData) {
  return Text(
    // _currentWeather: _cityTextController,
    //decoration: InputDecoration(labelText: 'City'),
    weatherData.name,
    style: const TextStyle(fontSize: 28),
  );
}

_temperature(CurrentWeatherData weatherData) {
  return Text(
    weatherData.main.temp.toString(),
    style: const TextStyle(fontSize: 100),
  );
}

_decription(CurrentWeatherData weatherData) {
  return Text(
    weatherData.weather[0].description,
    style: const TextStyle(fontSize: 22),
  );
}

_rangeTemperature(CurrentWeatherData weatherData) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Text(
        weatherData.main.tempMax.toString(),
        style: const TextStyle(fontSize: 18),
      ),
      Text(
        weatherData.main.tempMin.toString(),
        style: const TextStyle(fontSize: 18),
      ),
    ],
  );
}

// _hourlyForecast(BuildContext context) {
//   return Container(
//     margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
//     height: 200,
//     width: MediaQuery.of(context).size.width - 20,
//     padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
//     decoration: ThemeHelper().informationBoxDecoration(),
//     child: Text(
//         _position.latitude.toString() + ', ' + _position.longitude.toString()),
//   );
// }
