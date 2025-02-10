import 'dart:convert';
import 'dart:ffi';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'package:weather/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherServices {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherServices(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(
      Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    // Get Permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Fetch the current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // convert the location into a list of placemark object
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    // extract city name from the first placemark
    String? city = placemarks[0].locality;

    return city ?? "";
  }
}
