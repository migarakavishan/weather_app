import 'package:flutter/material.dart';
import 'package:weather_app/models/famous_city.dart';
import 'package:weather_app/widgets/famous_city_tile.dart';

class FamousCitiesView extends StatelessWidget {
  const FamousCitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: famousCities.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final city = famousCities[index];

        return FamousCityTile(index: index, city: city.name);
      },
    );
  }
}
