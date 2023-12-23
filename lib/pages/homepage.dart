import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:midterm_project/providers/user_provider.dart';
import 'package:midterm_project/utilities/login.dart';
import 'package:midterm_project/utilities/tab_bar.dart';
import 'package:midterm_project/utilities/travel_options.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  Future<void> fetchUserData() async {
    var url = Uri.parse('http://localhost:3000/users'); // Adjust URL if needed
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var users = json.decode(response.body) as List;
        if (users.isNotEmpty) {
          var currentUser = users.last['username'];
          ref.read(userProvider.state).state = currentUser;
        } else {
          ref.read(userProvider.state).state = null;
        }
      } else {
        print('Failed to fetch users: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error occurred while fetching users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final username = ref.watch(userProvider.state).state;

    final double horizontalPadding = 30.0;
    final double verticalPadding = 20.0;

    List travelPlaces = [
      ["Chennai, India", "lib/icons/flag.png", "⭐️ 4.2 Rating", "lib/icons/chennai.jpg"],
      ["Sapporo, Japan", "lib/icons/japan.png", "⭐️ 4.5 Rating", "lib/icons/sapporo.jpg"],
      ["Barcelona, Spain", "lib/icons/spain.png", "⭐️ 4.8 Rating", "lib/icons/barcelona.jpg"],
      ["Rio de Janeiro, Brazil", "lib/icons/brazil.png", "⭐️ 4.1 Rating", "lib/icons/rio_de_janeiro.jpg"]
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 25,
                    child: Image.asset('lib/icons/app.png', height: horizontalPadding, color: Colors.grey[800]),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await fetchUserData();
                      if (username != null) {
                        _showLogoutDialog(context, username);
                      } else {
                        _showLoginDialog(context);
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      radius: 25,
                      child: Image.asset('lib/icons/user.png', height: horizontalPadding, color: Colors.grey[800]),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
              child: Container(
                width: 250,
                height: 125,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Best Places For Travel",
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Find the best places to visit!",
                      style: TextStyle(wordSpacing: 2, height: 2, fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 135, 131, 131)),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: CategoryTabs()),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Travel Plan",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Text(
                    "Add Plan",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ],
              ),
            ),
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
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, String username) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logged in as $username'),
          content: Text('Do you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: Text('Logout'),
              onPressed: () {
                ref.read(userProvider.state).state = null;
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: LoginScreen(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
    );
  }
}
