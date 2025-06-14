import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:weather_app/constants/constants.dart';
import 'package:weather_app/models/hourly_weather.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/models/weekly_weather.dart';
import 'package:weather_app/services/geolocator.dart';
import 'package:weather_app/utils/logging.dart';

@immutable
class ApiHelper {
  static const baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const weeklyWeatherUrl =
      'https://api.open-meteo.com/v1/forecast?current=&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto';

  static double lat = 0.0;
  static double lon = 0.0;
  static final dio = Dio();

  //get lat and lon

  static Future<void> fetchLocation() async {
    final location = await getLocation();
    lat = location.latitude;
    lon = location.longitude;
  }

  //current weather
  static Future<Weather> getCurrentWeather() async {
    await fetchLocation();
    final url = _constructWeatherUrl();
    final response = await _fetchData(url);
    return Weather.fromJson(response);
  }

  //hourly weather
  static Future<HourlyWeather> getHourlyForecast() async {
    await fetchLocation();
    final url = _constructForecastUrl();
    final response = await _fetchData(url);
    return HourlyWeather.fromJson(response);
  }

  //weekly weather
  static Future<WeeklyWeather> getWeeklyWeather() async {
    await fetchLocation();
    final url = _constructWeeklyWeatherUrl();
    final response = await _fetchData(url);
    return WeeklyWeather.fromJson(response);
  }

  //weather by city name
  static Future<Weather> getWeatherByCityName({
    required String cityName,

  }) async {
    final url = _constructWeatherByCityUrl(cityName);
    final response = await _fetchData(url);
    return Weather.fromJson(response);
  }



  //build urls for weather and forecast
  static String _constructWeatherUrl() =>
      '$baseUrl/weather?lat=$lat&lon=$lon&units=metric&appid=${Constants.apiKey}';

  static String _constructForecastUrl() =>
      '$baseUrl/forecast?lat=$lat&lon=$lon&units=metric&appid=${Constants.apiKey}';

  static String _constructWeatherByCityUrl(String cityName) =>
      '$baseUrl/weather?q=$cityName&units=metric&appid=${Constants.apiKey}';

  static String _constructWeeklyWeatherUrl() =>
      '$weeklyWeatherUrl&latitude=$lat&longitude=$lon';

  //fetch data for the url
  static Future<Map<String, dynamic>> _fetchData(String url) async {
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        printWarning('Error fetching data: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      printWarning('Error fetching data from $url: $e');
      throw Exception('Failed to load data:');
    }
  }
}
