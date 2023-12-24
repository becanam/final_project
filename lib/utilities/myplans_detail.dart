import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailPage extends StatefulWidget {
  final String countryName;

  const DetailPage({required this.countryName});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<List<dynamic>> travelPlans;

  @override
  void initState() {
    super.initState();
    travelPlans = fetchTravelPlans();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.countryName),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: travelPlans,
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

          // 찾는 국가에 해당하는 여행 계획 찾기
          var plan = snapshot.data!.firstWhere(
            (plan) => plan['name'] == widget.countryName,
            orElse: () => {}, // 만약 없으면 빈 맵 반환
          );

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
      ),
    );
  }
}
