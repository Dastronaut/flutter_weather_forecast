import 'package:flutter/material.dart';
import 'package:flutter_weather_forecast/common/theme_helper.dart';
import 'package:flutter_weather_forecast/pages/data_service.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Position _currentPosition;
  late LocationPermission permission;
  final _latitude = TextEditingController();
  final _longitude = TextEditingController();

  final _dataService = DataService();
  @override
  void initState() {
    super.initState();
    _getUserPermission();
  }
  _search() async{
    final response = await _dataService.getWeather(_latitude.text, _longitude.text);
    print(response.cityName);
  }

  _getUserPermission() async {
    permission = await Geolocator.requestPermission();
    print(permission.toString());
    if (permission.toString() == "LocationPermission.whileInUse") {
      _getCurrentLocation();
    }
  }

  void _getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        print(_currentPosition);
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/sunny.jpg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: Column(children: [
          _location(),
          _temperature(),
          _decription(),
          _rangeTemperature(),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            height: 200,
            width: MediaQuery.of(context).size.width - 20,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            decoration: ThemeHelper().informationBoxDecoration(),
            // child: Text(currentPosition.isMocked == true
            //     ? "Lat: ${currentPosition.altitude.toString()}"
            //     : "Long: ${currentPosition.longitude.toString()}"),
            child: const Text('OK'),
          ),
        ]),
      ),
    );
  }
}

_location() {
  return const Text(
    'Da Nang',
    style: TextStyle(fontSize: 28),
  );
}

_temperature() {
  return const Text(
    '31',
    style: TextStyle(fontSize: 100),
  );
}

_decription() {
  return const Text(
    'Troi nang',
    style: TextStyle(fontSize: 22),
  );
}

_rangeTemperature() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: const [
      Text(
        'C: 34',
        style: TextStyle(fontSize: 18),
      ),
      Text(
        'T: 26',
        style: TextStyle(fontSize: 18),
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
