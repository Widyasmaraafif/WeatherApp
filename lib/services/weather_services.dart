import 'dart:convert';
import 'dart:ffi';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'package:weather/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherServices {
  static const BASE_URL = 'WEATHER_API';
  final String apiKey;

  WeatherServices(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Jika ada error dari OpenWeather API
        if (data["cod"] != 200) {
          throw Exception("Error from API: ${data["message"]}");
        }

        return Weather.fromJson(data);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print("Error fetching weather data: $e");
      throw Exception("Could not fetch weather data");
    }
  }

  Future<String> getCurrentCity() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String? city = placemarks[0].subAdministrativeArea ??
          placemarks[0].administrativeArea;

      print("Detected city: $city");
      return city ?? "Unknown";
    } catch (e) {
      print("Error getting city: $e");
      return "Unknown";
    }
  }
}
