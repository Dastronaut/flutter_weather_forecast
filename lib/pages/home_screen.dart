import 'dart:convert';

import 'package:flutter/material.dart';
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
                        height: 200,
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
                                          fontSize: 24,
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
                                        'min: ${(_currentWeather.main.tempMin).round().toString()}\u2103 / max: ${(_currentWeather.main.tempMax).round().toString()}\u2103',
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
                                          'wind ${_currentWeather.wind.speed} m/s',
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
                      Text(
                        'other city'.toUpperCase(),
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              fontSize: 16,
                              fontFamily: 'flutterfonts',
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                            ),
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
