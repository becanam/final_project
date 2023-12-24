import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:midterm_project/providers/user_provider.dart';
import 'package:midterm_project/utilities/login.dart';
import 'package:midterm_project/utilities/navigation_bar.dart';
import 'package:midterm_project/providers/travelplan_provider.dart';
import 'package:flutter/animation.dart';

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

 void animateCounts(int planId, String type) {
  final travelPlans = ref.read(travelPlanProvider);
  final List<Map<String, dynamic>> updatedPlans = List.from(travelPlans);

  final planIndex = updatedPlans.indexWhere((plan) => plan['id'] == planId);
  final plan = updatedPlans[planIndex];

  final likes = plan['likes'] ?? 0;
  final recommendations = plan['recommendations'] ?? 0;

  final newLikes = type == 'like' ? likes + 1 : likes;
  final newRecommendations = type == 'recommendation' ? recommendations + 1 : recommendations;

  updatedPlans[planIndex] = {
    ...plan,
    'likes': newLikes,
    'recommendations': newRecommendations,
  };

  ref.read(travelPlanProvider).state = updatedPlans;
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

  Future<void> incrementLikes(int planId) async {
    var url = Uri.parse('http://localhost:3000/travel_plans/$planId/likes');
    var response = await http.patch(url);
    if (response.statusCode != 200) {
      print('Failed to increment like: ${response.statusCode}, ${response.body}');
    } else {
      animateCounts(planId, 'like');
    }
  }

  Future<void> incrementRecommendations(int planId) async {
    var url = Uri.parse('http://localhost:3000/travel_plans/$planId/recommendations');
    var response = await http.patch(url);
    if (response.statusCode != 200) {
      print('Failed to increment recommendation: ${response.statusCode}, ${response.body}');
    } else {
      animateCounts(planId, 'recommendation');
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 20,
                    child: Image.asset('lib/icons/app.png', height: 20, color: Colors.grey[800]),
                  ),
                  IconButton(
                    icon: Icon(Icons.person),
                    onPressed: () {
                      if (username != null) {
                        _showLogoutDialog(context, username);
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
              child: Container(
                width: 250,
                height: 95,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Best Places For Travel", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    Text("Find the best places to visit!", style: TextStyle(wordSpacing: 2, height: 2, fontSize: 12, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 135, 131, 131))),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Trending Now", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                  Text("See all", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue)),
                ],
              ),
            ),
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
                      childAspectRatio: 1 / 0.8,
                    ),
                    itemBuilder: (context, index) {
                      var plan = snapshot.data![index];
                      final likeTween = Tween<double>(begin: 1, end: 1 + 0.5 * (plan['likes'] ?? 0));
                      final recommendationTween = Tween<double>(begin: 1, end: 1 + 0.1 * (plan['recommendations'] ?? 0));
                      return GestureDetector(
                        onTap: () {
                          // Define action on tap, if needed
                        },
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Image.network(
                                plan['imageUrl'], // Replace with actual image URL property from your plan
                                height: 250.0,
                                fit: BoxFit.cover,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      plan['name'], // Replace with actual title property from your plan
                                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                   Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TweenAnimationBuilder<double>(
                  tween: likeTween,
                  duration: Duration(seconds: 1),
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: IconButton(
                        icon: Icon(Icons.favorite),
                        color: Colors.red,
                        onPressed: () => incrementLikes(plan['id']),
                      ),
                    );
                  },
                ),
                Text('${plan['likes'] ?? 0} likes'),
                TweenAnimationBuilder<double>(
                  tween: recommendationTween,
                  duration: Duration(seconds: 1),
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: IconButton(
                        icon: Icon(Icons.thumb_up),
                        color: Colors.blue,
                        onPressed: () => incrementRecommendations(plan['id']),
                      ),
                    );
                  },
                ),
                Text('${plan['recommendations'] ?? 0} recommendations'),
              ],
            ),
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
