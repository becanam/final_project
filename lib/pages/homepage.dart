import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:midterm_project/pages/details_page.dart';
import 'package:midterm_project/pages/login_page.dart'; // Replace with your actual login page
import 'package:midterm_project/utilities/navigation_bar.dart';
import 'package:midterm_project/utilities/travelcards_list.dart';
import 'package:midterm_project/utilities/travel_options.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  final double horizontalPadding = 30;
  final double verticalPadding = 20;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    // Implement your user data fetching logic here
  }

  @override
  Widget build(BuildContext context) {
    final username = ref.watch(userProvider.state).state; // Assuming you have a userProvider

    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
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
                      radius: 20,
                      child: Image.asset('lib/icons/app.png', height: 20, color: Colors.grey[800]),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (username != null) {
                          _showLogoutDialog(context, username);
                        } else {
                          _showLoginDialog(context);
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: 20,
                        child: Image.asset('lib/icons/user.png', height: 20, color: Colors.grey[800]),
                      ),
                    )
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
                child: GridView.builder(
                  itemCount: travelOptionsList.length,
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1 / 1.65,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(travelCard: travelOptionsList[index]))),
                      child: Card(
                        // Your card layout here
                      ),
                    );
                  },
                ),
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
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage())); // Replace LoginPage with your login page widget
  }
}
