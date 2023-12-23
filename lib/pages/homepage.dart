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
    final double horizontalPadding = 30.0;
    final double verticalPadding = 20.0;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top section with user avatar and app icon
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
                    ElevatedButton(
                      onPressed: () async {
                        await fetchUserData();
                        if (username != null) {
                          _showLogoutDialog(context, username);
                        } else {
                          _showLoginDialog(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(15),
                        primary: Colors.grey[300],
                      ),
                      child: Image.asset('lib/icons/user.png', height: horizontalPadding, color: Colors.grey[800]),
                    ),
                  ],
                ),
              ),
              // "Best Places For Travel" section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                child: Container(
                  width: 250,
                  height: 125,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Best Places For Travel", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                      Text("Find the best places to visit!", style: TextStyle(wordSpacing: 2, height: 2, fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 135, 131, 131))),
                    ],
                  ),
                ),
              ),
              // Category tabs
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: CategoryTabs()),
              ),
              // "Travel Plan" section with "Add Plan" button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Travel Plan", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddTravelPlanPage()));
                      },
                      child: Text("Add Plan", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(primary: Colors.blue, onPrimary: Colors.white),
                    ),
                  ],
                ),
              ),
              // Dynamic travel plans section
              FutureBuilder<List<dynamic>>(
                future: fetchTravelPlans(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Center(child: Text("No travel plans available.")),
                    );
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length, // Dynamically set the itemCount
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 1.65,
                    ),
                    itemBuilder: (context, index) {
                      var plan = snapshot.data![index];
                      return Card(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plan['이름'] ?? 'Unknown Name',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),  // Space between title and details
                              Text("국가: ${plan['country'] ?? 'Unknown'}"),
                              Text("도시: ${plan['city'] ?? 'Unknown'}"),
                              Text("시작일: ${plan['startDate'] ?? 'Unknown'}"),
                              Text("종료일: ${plan['endDate'] ?? 'Unknown'}"),
                              Text("가격(usd): ${plan['price']?.toString() ?? 'Unknown'}"),
                              Text("테마: ${plan['theme'] ?? 'Unknown'}"),
                            ],
                          ),
                        ),
                      );
                    },

                  );
                },
              ),
            ],
          ),
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
