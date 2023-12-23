import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddTravelPlanPage extends StatefulWidget {
  @override
  _AddTravelPlanPageState createState() => _AddTravelPlanPageState();
}

class _AddTravelPlanPageState extends State<AddTravelPlanPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String country = '';
  String city = '';
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  double price = 0.0;
  String theme = '';

  Future<void> submitTravelPlan() async {
    var url = Uri.parse('http://localhost:3000/travel_plans'); // Adjust URL as needed
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'name': name,
        'country': country,
        'city': city,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'price': price,
        'theme': theme,
      }),
    );

    if (response.statusCode == 201) {
      // Handle successful submission
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Travel plan added successfully")));
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill up all the informations")));
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? startDate : endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != (isStartDate ? startDate : endDate)) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Travel Plan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: '이름 (Name)'),
                onChanged: (value) => name = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '국가 (Country)'),
                onChanged: (value) => country = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '도시 (City)'),
                onChanged: (value) => city = value,
              ),
              ListTile(
                title: Text("시작일 (Start Date): ${startDate.toLocal()}".split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, true),
              ),
              ListTile(
                title: Text("종료일 (End Date): ${endDate.toLocal()}".split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, false),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '가격 (Price)'),
                keyboardType: TextInputType.number,
                onChanged: (value) => price = double.tryParse(value) ?? 0.0,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '테마 (Theme)'),
                onChanged: (value) => theme = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitTravelPlan,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
