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
  String description; 

  TravelCard({
    required this.cityName,
    required this.flag,
    required this.rating,
    required this.cityImage,
    required this.icon,
    required this.iconColor,
    required this.counter,
    required this.description,
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
    description: "Chennai, the capital city of the Indian state of Tamil Nadu, " +
        "is known for its rich cultural heritage and vibrant traditions. " +
        "Explore the historic temples, enjoy the delicious South Indian cuisine, " +
        "and experience the warmth of the people.",
  ),
  TravelCard(
    cityName: "Sapporo, Japan",
    flag: "lib/icons/japan.png",
    rating: "⭐️ 4.5 Rating",
    cityImage: "lib/icons/sapporo.jpg",
    icon: Icons.favorite,
    iconColor: Colors.red,
    counter: counterProviderList[1],
    description: "Sapporo, located on the northern Japanese island of Hokkaido, " +
        "is a winter wonderland known for its snow festivals and delicious ramen. " +
        "Enjoy skiing in the nearby mountains and immerse yourself in Japanese culture.",
  ),
  TravelCard(
    cityName: "Barcelona, Spain",
    flag: "lib/icons/spain.png",
    rating: "⭐️ 4.8 Rating",
    cityImage: "lib/icons/barcelona.jpg",
    icon: Icons.favorite,
    iconColor: Colors.red,
    counter: counterProviderList[2],
    description: "Barcelona, the capital of Catalonia, is famous for its unique " +
        "architecture, including the works of Antoni Gaudí. Stroll down " +
        "the bustling La Rambla, visit the Sagrada Família, and savor " +
        "authentic tapas in this vibrant city.",
  ),
  TravelCard(
    cityName: "Rio de Janeiro, Brazil",
    flag: "lib/icons/brazil.png",
    rating: "⭐️ 4.1 Rating",
    cityImage: "lib/icons/rio_de_janeiro.jpg",
    icon: Icons.favorite,
    iconColor: Colors.red,
    counter: counterProviderList[3],
    description: "Rio de Janeiro, known for its iconic Carnival and stunning " +
        "beaches like Copacabana and Ipanema, is a lively city nestled " +
        "between mountains and the Atlantic Ocean. Enjoy the vibrant " +
        "culture, music, and breathtaking views.",
  ),
];