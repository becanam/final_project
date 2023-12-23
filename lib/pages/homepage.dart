import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:midterm_project/providers/user_provider.dart';
import 'package:midterm_project/utilities/login.dart';
import 'package:midterm_project/utilities/tab_bar.dart';
import 'package:midterm_project/pages/add_travel_page.dart';

class ExplodingThumbsUp extends StatefulWidget {
  @override
  _ExplodingThumbsUpState createState() => _ExplodingThumbsUpState();
}

class _ExplodingThumbsUpState extends State<ExplodingThumbsUp> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 2.0).animate(_controller);
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
    _colorAnimation = ColorTween(begin: Colors.grey, end: Colors.green).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleOnPressed() {
    if (_controller.status == AnimationStatus.dismissed) {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 30,
      icon: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Icon(Icons.thumb_up, color: _colorAnimation.value),
            ),
          );
        },
      ),
      onPressed: _handleOnPressed,
    );
  }
}


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
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: CategoryTabs()),
              ),
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
              itemCount: snapshot.data!.length,
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 1.2,      //takes care of card size
              ),
      itemBuilder: (context, index) {
        var plan = snapshot.data![index];


        return Card(
  clipBehavior: Clip.antiAlias,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      Image.network(
        plan['imageUrl'] ?? 'assets/default_image.png',
        height: 250.0,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/default_image.png',
            height: 250.0,
            fit: BoxFit.cover,
          );
        },
      ),
      SizedBox(height: 10),
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              plan['name'] ?? 'Unknown Name',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "국가: ${plan['country'] ?? 'Unknown'}",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            Text(
              "도시: ${plan['city'] ?? 'Unknown'}",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            Text(
              "시작일: ${plan['startDate'] ?? 'Unknown'}",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            Text(
              "종료일: ${plan['endDate'] ?? 'Unknown'}",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            Text(
              "가격(usd): ${plan['price']?.toString() ?? 'Unknown'}",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            Text(
              "테마: ${plan['theme'] ?? 'Unknown'}",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Confirmation dialog and deletion logic
                    // ... existing code for delete button
                  },
                  child: Text('Delete', style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                ),
                IconButton(
                icon: Icon(Icons.thumb_up),
                color: Colors.grey, // Default color
                onPressed: () {
                  // Trigger the exploding animation
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        child: ExplodingThumbsUp(),
                      );
                    },
                  );
                },
              ),
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
