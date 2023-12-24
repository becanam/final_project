import 'package:flutter/material.dart';
import 'package:midterm_project/utilities/travel_options.dart';

List<Counter> counterProviderList = [
  Counter(),
  Counter(),
  Counter(),
  Counter(),
];

class TravelCard {
  String cityName;
  String flag;
  String rating;
  String cityImage;
  IconData icon;
  Color iconColor;
  Counter counter;
  String description; // New field for longer description

  TravelCard({
    required this.cityName,
    required this.flag,
    required this.rating,
    required this.cityImage,
    required this.icon,
    required this.iconColor,
    required this.counter,
    required this.description, // New parameter
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
    counter: counterProviderList[0],
    description: "Explore the vibrant culture and rich history of Chennai. "
        "Visit historic temples, bustling markets, and enjoy the local cuisine. "
        "Chennai offers a unique blend of tradition and modernity.",
  ),
  TravelCard(
    cityName: "Sapporo, Japan",
    flag: "lib/icons/japan.png",
    rating: "⭐️ 4.5 Rating",
    cityImage: "lib/icons/sapporo.jpg",
    icon: Icons.favorite,
    iconColor: Colors.red,
    counter: counterProviderList[1],
    description: "Experience the beauty of Sapporo in every season. "
        "From cherry blossoms in spring to winter snow festivals, Sapporo "
        "offers stunning landscapes and a warm welcome. Discover the local "
        "culture and try delicious Hokkaido cuisine.",
  ),
  TravelCard(
    cityName: "Barcelona, Spain",
    flag: "lib/icons/spain.png",
    rating: "⭐️ 4.8 Rating",
    cityImage: "lib/icons/barcelona.jpg",
    icon: Icons.favorite,
    iconColor: Colors.red,
    counter: counterProviderList[2],
    description: "Explore the vibrant and artistic city of Barcelona. "
        "Visit iconic landmarks like Sagrada Familia and Park Güell. "
        "Indulge in delicious tapas and immerse yourself in the lively atmosphere "
        "of this Mediterranean gem.",
  ),
  TravelCard(
    cityName: "Rio de Janeiro, Brazil",
    flag: "lib/icons/brazil.png",
    rating: "⭐️ 4.1 Rating",
    cityImage: "lib/icons/rio_de_janeiro.jpg",
    icon: Icons.favorite,
    iconColor: Colors.red,
    counter: counterProviderList[3],
    description: "Experience the energetic vibes of Rio de Janeiro. "
        "Relax on the famous Copacabana Beach, explore the iconic Christ the Redeemer, "
        "and immerse yourself in the rhythm of samba. Rio de Janeiro is a lively "
        "destination with breathtaking landscapes.",
  ),
];
