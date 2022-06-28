import 'package:flutter/material.dart';
import 'package:flutter_weather_forecast/common/sub_weather_item.dart';
import 'package:flutter_weather_forecast/model/current_weather_data.dart';
import 'package:flutter_weather_forecast/service/data_service.dart';

class SearchScreen extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      hintColor: Colors.black,
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) =>
      FutureBuilder<CurrentWeatherData>(
        future: DataService.getCurrentWeatherByCity(city: query),
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
                        color: Colors.white.withOpacity(0.65),
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
                                        color: Colors.black87,
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text(
                                      _currentWeather.weather[0].description,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(
                                            color: Colors.black87,
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
                                              color: Colors.black87,
                                              fontFamily: 'flutterfonts'),
                                    ),
                                    Text(
                                      'Cao: ${(_currentWeather.main.tempMin).round().toString()}\u2103 / Thấp: ${(_currentWeather.main.tempMax).round().toString()}\u2103',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(
                                            color: Colors.black54,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: 120,
                                        height: 120,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/icon-01.jpg'),
                                            fit: BoxFit.cover,
                                            opacity: 0.65,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Gió ${_currentWeather.wind.speed} m/s',
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .copyWith(
                                              color: Colors.black87,
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
      );

  @override
  Widget buildSuggestions(BuildContext context) => Container(
        color: Colors.black,
        child: FutureBuilder<List<String>>(
          future: DataService.searchCities(query: query),
          builder: (context, snapshot) {
            if (query.isEmpty) return buildNoSuggestions();

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError || snapshot.data!.isEmpty) {
                  return buildNoSuggestions();
                } else {
                  return buildSuggestionsSuccess(snapshot.data);
                }
            }
          },
        ),
      );

  Widget buildNoSuggestions() => const Center(
        child: Text(
          'No suggestions!',
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
      );

  Widget buildSuggestionsSuccess(List<String>? suggestions) => ListView.builder(
        itemCount: suggestions!.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          final queryText = suggestion.substring(0, query.length);
          final remainingText = suggestion.substring(query.length);

          return ListTile(
            onTap: () {
              query = suggestion;
              showResults(context);
            },
            leading: const Icon(Icons.location_city),
            // title: Text(suggestion),
            title: RichText(
              text: TextSpan(
                text: queryText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: [
                  TextSpan(
                    text: remainingText,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
}
