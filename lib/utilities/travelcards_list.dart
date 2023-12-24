import 'package:flutter/material.dart';
import 'package:midterm_project/utilities/travel_options.dart';

List<Counter> counterProviderList = [
  Counter(),
  Counter(),
  Counter(),
  Counter()
];

class TravelCard {
  String cityName;
  String flag;
  String rating;
  String cityImage;
  IconData icon;
  Color iconColor;
  Counter counter;

  TravelCard({
    required this.cityName,
    required this.flag,
    required this.rating,
    required this.cityImage,
    required this.icon,
    required this.iconColor,
    required this.counter
  });
}

List<TravelCard> travelOptionsList = [
  TravelCard(
    cityName: "Chennai, India",
    flag: "lib/icons/flag.png",
    rating: "⭐️ 4.2 Rating",
    cityImage: "lib/icons/chennai.jpg",
    icon: Icons.favorite,
    iconColor: Colors.red,
    counter: counterProviderList[0]
  ),
  TravelCard(
    cityName: "Sapporo, Japan",
    flag: "lib/icons/japan.png",
    rating: "⭐️ 4.5 Rating",
    cityImage: "lib/icons/sapporo.jpg",
    icon: Icons.favorite,
    iconColor: Colors.red,
    counter: counterProviderList[1]
  ),
  TravelCard(
    cityName: "Barcelona, Spain",
    flag: "lib/icons/spain.png",
    rating: "⭐️ 4.8 Rating",
    cityImage: "lib/icons/barcelona.jpg",
    icon: Icons.favorite,
    iconColor: Colors.red,
    counter: counterProviderList[2]
  ),
  TravelCard(
    cityName: "Rio de Janeiro, Brazil",
    flag: "lib/icons/brazil.png",
    rating: "⭐️ 4.1 Rating",
    cityImage: "lib/icons/rio_de_janeiro.jpg",
    icon: Icons.favorite,
    iconColor: Colors.red,
    counter: counterProviderList[3]
  ),
];
