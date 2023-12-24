import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:midterm_project/utilities/travelcards_list.dart';

class DetailWidget extends ConsumerWidget {
  const DetailWidget({
    super.key,
    required this.travelCard, required this.likes
  });

  final TravelCard travelCard;
  final String likes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    // Navigate back to the previous screen/page
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Container(
            height: 620,
            width: 400,
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
                alignment: const Alignment(0, 1.1),
                children: <Widget>[
                  //city image
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(100),
                        topRight: Radius.circular(100),
                      ),
                      child: Image.asset(travelCard.cityImage,
                          height: 300, fit: BoxFit.cover),
                    ),
                  ),
                
                  //country flag
                  Align(
                    child: Image.asset(
                      travelCard.flag,
                      height: 60,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 33,
              ),
                
              //country name
              Text(
                travelCard.cityName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
                
              //rating
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: [
                    Text(
                      travelCard.rating,
                      style: const TextStyle(
                          height: 2,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            travelCard.icon,
                            color: travelCard.iconColor,
                            size: 28,
                          ),
                          Text(likes)
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          )),
        ),
      ],
    );
  }
}