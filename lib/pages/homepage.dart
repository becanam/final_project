import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:midterm_project/providers/user_provider.dart';
import 'package:midterm_project/utilities/login.dart';
import 'package:midterm_project/utilities/tab_bar.dart';
import 'package:midterm_project/pages/add_travel_page.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomePageState extends State<Homepage> {
  //padding constants
  final double horizontalPadding = 30;
  final double verticalPadding = 20;

// list of places
  List travelPlaces = [
    [
      "Chennai, India",
      "lib/icons/flag.png",
      "⭐️ 4.2 Rating",
      "lib/icons/chennai.jpg"
    ],
    [
      "Sapporo, Japan",
      "lib/icons/japan.png",
      "⭐️ 4.5 Rating",
      "lib/icons/sapporo.jpg"
    ],
    [
      "Barcelona, Spain",
      "lib/icons/spain.png",
      "⭐️ 4.8 Rating",
      "lib/icons/barcelona.jpg"
    ],
    [
      "Rio de Janeiro, Brazil",
      "lib/icons/brazil.png",
      "⭐️ 4.1 Rating",
      "lib/icons/rio_de_janeiro.jpg"
    ]
  ];

  @override
  Widget build(BuildContext context) {
    final username = ref.watch(userProvider.state).state;
    final double horizontalPadding = 30.0;
    final double verticalPadding = 20.0;

    return Scaffold(
        body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //appbar
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //menu icon
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  radius: 25,
                  child: Image.asset('lib/icons/app.png',
                      height: horizontalPadding, color: Colors.grey[800]),
                ),

                //profile
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  radius: 25,
                  child: Image.asset('lib/icons/user.png',
                      height: horizontalPadding, color: Colors.grey[800]),
                )
              ],
            ),
          ),

          //title
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding, vertical: verticalPadding),
            child: Container(
                width: 250,
                height: 125,
                color: Colors.black.withOpacity(0),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Best Places For Travel",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Find the best places to visit!",
                      style: TextStyle(
                          wordSpacing: 2,
                          height: 2,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 135, 131, 131)),
                    ),
                  ],
                )),
          ),

          //scrollable tab
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: CategoryTabs()),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding, vertical: verticalPadding),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //trending now
                Text(
                  "Trending Now",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                //see all
                Text(
                  "See all",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                )
              ],
            ),
          ),

          //travel options
          Expanded(
            child: GridView.builder(
              itemCount: travelPlaces.length,
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 1.65,
              ),
              itemBuilder: (context, index) {
                return PlacesToTravel(
                  countryName: travelPlaces[index][0],
                  iconPath: travelPlaces[index][1],
                  rating: travelPlaces[index][2],
                  cityImage: travelPlaces[index][3],
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}
