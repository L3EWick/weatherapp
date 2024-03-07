import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        print('Response Body: ${response.body}');
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to load weather data. Status Code: ${response.statusCode}');
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print('Error fetching weather data: $e');
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        String? city = placemarks[0].locality;
        return city ?? "";
      } else {
        throw Exception('Failed to retrieve city information.');
      }
    } catch (e) {
      print('Error getting current city: $e');
      throw Exception('Failed to retrieve location information.');
    }
  }
}
