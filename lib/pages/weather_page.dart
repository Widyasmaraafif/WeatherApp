import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/models/weather_model.dart';
import 'package:weather/services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // API KEY
  final _WeatherService = WeatherServices('YOUR_API_KEY');
  Weather? _weather;

  // Fetch weather
  _fetchWeather() async {
    // get the current city
    String cityName = await _WeatherService.getCurrentCity();

    // get weather for city
    try {
      final weather = await _WeatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  // Weather animations
  String getWeatherCondition(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json'; // default

    switch (mainCondition.toLowerCase()) {
      case 'cloudy':
        return 'assets/cloudy.json';
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
      case 'rain':
        return 'assets/rainy.json';
      case 'drizzle':
      case 'shower rain':
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  // Init state
  @override
  void initState() {
    super.initState();

    // fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // City Name
            Text(_weather?.cityName ?? "Loading city..."),

            // animation
            Lottie.asset(getWeatherCondition(_weather?.mainCondition)),

            // Temperature
            Text('${_weather?.temperature.round()}°C'),

            // weather condition
            Text(_weather?.mainCondition ?? "")
          ],
        ),
      ),
    );
  }
}
