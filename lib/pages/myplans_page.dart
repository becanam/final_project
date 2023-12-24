import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:midterm_project/utilities/heart_animation.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:midterm_project/utilities/navigation_bar.dart';

class MyPlansScreen extends ConsumerWidget {
  const MyPlansScreen({Key? key}) : super(key: key);

  Future<List<dynamic>> fetchTravelPlans() async {
    var url = Uri.parse('http://localhost:3000/travel_plans');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(
          'Failed to fetch travel plans: ${response.statusCode}, ${response.body}');
      return [];
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> _navigateToDetailPage(
        BuildContext context, String countryName) async {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DetailPage(countryName: countryName),
        ),
      );
    }

    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
          child: ListView(
            children: [
              const SizedBox(
                height: 30,
                child: Text(
                  "MY PLANS",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              FutureBuilder<List<dynamic>>(
                future: fetchTravelPlans(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Center(child: Text("No travel plans available.")),
                    );
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 1.5, // takes care of card size
                    ),
                    itemBuilder: (context, index) {
                      var plan = snapshot.data![index];

                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            _navigateToDetailPage(
                                context, plan['name'] ?? 'Unknown Name');
                          },
                          child: SizedBox(
                            height: 200, // Adjust the height as needed
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  const SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          plan['name'] ?? 'Unknown Name',
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        // ... other Text widgets
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              // Confirmation dialog and deletion logic
                                              // ... existing code for delete button
                                            },
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.red),
                                            child: const Text('Delete',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
}
