import 'package:flutter/material.dart';
import 'package:midterm_project/pages/details_page.dart';
import 'package:midterm_project/utilities/navigation_bar.dart';
import 'package:midterm_project/utilities/travelcards_list.dart';
import 'package:midterm_project/utilities/travel_options.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomePageState();
}

class _HomePageState extends State<Homepage> {
  //padding constants
  final double horizontalPadding = 30;
  final double verticalPadding = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
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
                  radius: 20,
                  child: Image.asset('lib/icons/app.png',
                      height: 20, color: Colors.grey[800]),
                ),

                //profile
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  radius: 20,
                  child: Image.asset('lib/icons/user.png',
                      height: 20, color: Colors.grey[800]),
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
                height: 95,
                color: Colors.black.withOpacity(0),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Best Places For Travel",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Find the best places to visit!",
                      style: TextStyle(
                          wordSpacing: 2,
                          height: 2,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 135, 131, 131)),
                    ),
                  ],
                )),
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
              itemCount: travelOptionsList.length,
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 1.65,
              ),
              itemBuilder: (context, index) {
                return PlacesToTravel(
                    travelCard: travelOptionsList[index],
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailsScreen(travelCard: travelOptionsList[index]))));
              },
            ),
          ),
        ],
      ),
    ));
  }
}
