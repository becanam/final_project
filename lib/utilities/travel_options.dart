import 'package:flutter/material.dart';

class PlacesToTravel extends StatelessWidget {
  final String countryName;
  final String iconPath;
  final String rating;
  final String cityImage;

  const PlacesToTravel({
    super.key,
    required this.countryName,
    required this.iconPath,
    required this.rating,
    required this.cityImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(100),
                  topRight: Radius.circular(100),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16)),
            ),
            child: Column(
              children: [
                Stack(
                  alignment: const Alignment(0, 1.25),
                  children: <Widget> [
                  
                  //city image
                  ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(100),
                    topRight: Radius.circular(100),
                  ),
                  child: Image.asset(cityImage, height: 260, fit: BoxFit.cover),
                ),
                
                //country flag
                Align(
                  child: Image.asset(
                    iconPath,
                    height: 55,
                  ),
                ),
                ],
                ),
                const SizedBox(
                  height: 33,
                ),
                
                //country name
                Text(
                  countryName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                
                //rating
                Text(
                  rating,
                  style: const TextStyle(
                    height: 2,
                    fontWeight: FontWeight.bold, 
                    fontSize: 12),
                )
              ],
            )));
  }
}