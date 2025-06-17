import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/constants/text_styles.dart';
import 'package:weather_app/extensions/datetime.dart';
import 'package:weather_app/providers/current_weather_provider.dart';
import 'package:weather_app/views/gradient_container.dart';

class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherData = ref.watch(currentWeatherProvider);

    return weatherData.when(
      data: (weather) {
        return GradientContainer(
          children: [
            SizedBox(width: double.infinity),
            Text(weather.name, style: TextStyles.h1),
            SizedBox(height: 20),
            Text(DateTime.now().dateTime),
            SizedBox(height: 30),
            SizedBox(
              height: 260,
              child: Image.asset(
                'assets/icons/${weather.weather[0].icon.replaceAll('n', 'd')}.png',
              ),
            ),
            SizedBox(height: 40),
            Text(weather.weather[0].description, style: TextStyles.h2),
          ],
        );
      },
      error: (error, StackTrace) {
        return Center(child: Text(error.toString()));
      },
      loading: () {
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
