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

  void _navigateToDetailPage(BuildContext context, String countryName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailPage(countryName: countryName),
      ),
    );
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
                  color: Colors.black.withOpacity(0),
                  child: const Column(
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
                      childAspectRatio: 1 / 1, // Adjusted childAspectRatio
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
                            SizedBox(height: 10), // Adjusted gap
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    plan['name'] ?? 'Unknown Name',
                                    style: TextStyle(
                                      fontSize: 24, // Increased font size
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "국가: ${plan['country'] ?? 'Unknown'}",
                                    style: TextStyle(fontSize: 18), // Increased font size
                                    textAlign: TextAlign.center,
                                  ),
                                    Text(
                                      "도시: ${plan['city'] ?? 'Unknown'}",
                                      style: TextStyle(fontSize: 20),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      "시작일: ${plan['startDate'] ?? 'Unknown'}",
                                      style: TextStyle(fontSize: 20),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      "종료일: ${plan['endDate'] ?? 'Unknown'}",
                                      style: TextStyle(fontSize: 20),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      "가격(usd): ${plan['price']?.toString() ?? 'Unknown'}",
                                      style: TextStyle(fontSize: 20),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      "테마: ${plan['theme'] ?? 'Unknown'}",
                                      style: TextStyle(fontSize: 20),
                                      textAlign: TextAlign.center,
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
}

// DetailPage 클래스 정의

class DetailPage extends StatefulWidget {
  final String countryName;

  const DetailPage({required this.countryName});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  double iconSize = 48.0;
  bool isMaxSizeReached = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.countryName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // "더이상 누를 수 없습니다!" 문구
            Visibility(
              visible: isMaxSizeReached,
              child: SizedBox(
                height: 30.0,
                child: Center(
                  child: Text(
                    "더이상 누를 수 없습니다!",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),
            // 좋아요 아이콘
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'lib/icons/heart.png',
                height: iconSize,
                width: iconSize,
              ),
            ),
            SizedBox(height: 16.0),

            // "+" 버튼
            ElevatedButton(
              onPressed: () {
                if (iconSize + 10.0 <= 530.0) {
                  setState(() {
                    iconSize += 10.0;
                    isMaxSizeReached = false;
                  });
                } else {
                  setState(() {
                    isMaxSizeReached = true;
                  });

                  Future.delayed(Duration(seconds: 1), () {
                    setState(() {
                      isMaxSizeReached = false;
                    });
                  });
                }
              },
              child: Text("+"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(50, 50),
              ),
            ),
            SizedBox(height: 16.0),

            // "-" 버튼
            ElevatedButton(
              onPressed: () {
                setState(() {
                  iconSize -= 10.0;
                });
              },
              child: Text("-"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(50, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
