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

    final planIndex = travelPlans.indexWhere((plan) => plan['id'] == planId);
    final plan = travelPlans[planIndex];

    final likes = plan['likes'] ?? 0;
    final recommendations = plan['recommendations'] ?? 0;

    final newLikes = type == 'like' ? likes + 1 : likes;
    final newRecommendations = type == 'recommendation' ? recommendations + 1 : recommendations;

    travelPlans[planIndex] = {
      ...plan,
      'likes': newLikes,
      'recommendations': newRecommendations,
    };
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


  
Future<void> incrementLikes(Map<String, dynamic> plan) async {
  var url = Uri.parse('http://localhost:3000/travel_plans/${plan['id']}');
  int currentLikes = plan['likes'] ?? 0;
  var response = await http.patch(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode({
      'likes': currentLikes + 1, // Increment like count
      // Include other plan properties if required by your backend
    }),
  );

  if (response.statusCode != 200) {
    print('Failed to increment like: ${response.statusCode}, ${response.body}');
  } else {
    // Update local state with new likes count
    setState(() {
      plan['likes'] = currentLikes + 1;
    });
  }
}




 Future<void> incrementRecommendations(Map<String, dynamic> plan) async {
  var url = Uri.parse('http://localhost:3000/travel_plans/${plan['id']}');
  int currentRecommendations = plan['recommendations'] ?? 0;
  var response = await http.patch(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode({
      'recommendations': currentRecommendations + 1, // Increment recommendations count
      // Include other plan properties if required by your backend
    }),
  );

  if (response.statusCode != 200) {
    print('Failed to increment recommendation: ${response.statusCode}, ${response.body}');
  } else {
    // Update local state with new recommendations count
    setState(() {
      plan['recommendations'] = currentRecommendations + 1;
    });
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
                height: 115,
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

      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.network(
              plan['imageUrl'],
              height: 250.0,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    plan['name'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 1.0, end: 1.0 + 0.05 * (plan['likes'] ?? 0)), // Adjust these values as needed
                  duration: Duration(milliseconds: 1500),
                  curve: Curves.elasticOut,
                  builder: (context, scale, child) {
                    return Transform.translate(
                      offset: Offset(scale * 5, 0), // This creates the side to side movement
                      child: Transform.scale(
                        scale: scale,
                        child: IconButton(
                          icon: Icon(Icons.favorite),
                          color: Colors.red,
                          onPressed: () => incrementLikes(plan),
                        ),
                      ),
                    );
                  },
                ),
                Text('${plan['likes'] ?? 0} likes'),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 1.0, end: 1.0 + 0.05 * (plan['likes'] ?? 0)), // Adjust these values as needed
                  duration: Duration(milliseconds: 1500),
                  curve: Curves.elasticOut,
                  builder: (context, scale, child) {
                    return Transform.translate(
                      offset: Offset(scale * 5, 0), // This creates the side to side movement
                      child: Transform.scale(
                        scale: scale,
                        child: IconButton(
                          icon: Icon(Icons.thumb_up),
                          color: Colors.blue,
                          onPressed: () => incrementRecommendations(plan),
                        ),
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
);
    },
  );
}
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
