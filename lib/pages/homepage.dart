import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:midterm_project/providers/user_provider.dart';
import 'package:midterm_project/utilities/login.dart';
import 'package:midterm_project/utilities/navigation_bar.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  Future<void> fetchUserData() async {
    var url = Uri.parse('http://localhost:3000/users');
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

  Future<List<dynamic>> fetchTravelPlans() async {
    var url = Uri.parse('http://localhost:3000/travel_plans');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to fetch travel plans: ${response.statusCode}, ${response.body}');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final username = ref.watch(userProvider.state).state;
    final double horizontalPadding = 30;
    final double verticalPadding = 20;

    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... Existing AppBar and padding code

            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: fetchTravelPlans(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No travel plans available."));
                  }
                  return GridView.builder(
                    itemCount: snapshot.data!.length,
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 1.2,
                    ),
                    itemBuilder: (context, index) {
                      var plan = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          // Define action on tap, if needed
                        },
                        child: Card(
                          elevation: 5, // Add elevation for depth
                          margin: EdgeInsets.all(8), // Margin for spacing
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Rounded corners
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Expanded(
                                child: Image.network(
                                  plan['imageUrl'], // Replace with actual image URL property from your plan
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      plan['name'], // Replace with actual title property from your plan
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.start,
                                    ),
                                    SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
}
