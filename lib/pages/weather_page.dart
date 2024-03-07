// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // key api
  final _weatherService = WeatherService('');
  Weather? _weather;


  _fetchWeather() async {
    try {
      String cityName = await _weatherService.getCurrentCity();
      print('Current City: $cityName');

      if (cityName.isNotEmpty) {
        final weather = await _weatherService.getWeather(cityName);

        // ignore: unnecessary_null_comparison
        if (weather != null) {
          setState(() {
            _weather = weather;
          });
        } else {
          print('Weather object is null.');
        }
      } else {
        print('City name is empty.');
      }
    } catch (e) {
      print('Error fetching weather: $e');
    }
  }

  // weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thumderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchWeather();
  }

  //weather animations

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Column(
        children: [
          
          // city name
          Padding(
            padding: const EdgeInsets.only(top: 80, bottom: 150),
            child:
            Column(
              children: [
                Icon(Icons.location_pin,
                  color: Colors.grey[500],
                ),
                Text(
                  _weather?.cityName ?? "loading city...".toUpperCase(),
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // animation

          Padding(
            padding: const EdgeInsets.only(bottom: 150),
            child: Center(
                child:
                    Lottie.asset(getWeatherAnimation(_weather?.mainCondition))),
          ),

          // temperature
          Text(
            '${_weather?.temperature.round()}º' ?? "Loading..." ,
              style: TextStyle(
              color: Colors.grey[500],
              fontSize: 50.0,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            _weather?.mainCondition ?? "",
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
