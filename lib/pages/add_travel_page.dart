import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class AddTravelPlanPage extends StatefulWidget {
  @override
  _AddTravelPlanPageState createState() => _AddTravelPlanPageState();
}

class _AddTravelPlanPageState extends State<AddTravelPlanPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _themeController = TextEditingController();

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> submitTravelPlan() async {
    // Check if all the information is entered
    if (_nameController.text.isEmpty ||
        _countryController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _startDateController.text.isEmpty ||
        _endDateController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _themeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill up all the informations")),
      );
      return;
    }
    
    var url = Uri.parse('http://localhost:3000/travel_plans');
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'name': _nameController.text,
        'country': _countryController.text,
        'city': _cityController.text,
        'startDate': _startDateController.text,
        'endDate': _endDateController.text,
        'price': int.tryParse(_priceController.text),
        'theme': _themeController.text,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Travel plan added successfully")),
      );
      // Clear the text fields
      _nameController.clear();
      _countryController.clear();
      _cityController.clear();
      _startDateController.clear();
      _endDateController.clear();
      _priceController.clear();
      _themeController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add travel plan")),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _priceController.dispose();
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Travel Plan'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '이름 (Name)',
              ),
            ),
            TextFormField(
              controller: _countryController,
              decoration: InputDecoration(
                labelText: '국가 (Country)',
              ),
            ),
            TextFormField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: '도시 (City)',
              ),
            ),
            TextFormField(
              controller: _startDateController,
              decoration: InputDecoration(
                labelText: '시작일 (Start Date)',
              ),
              onTap: () => _selectDate(context, _startDateController),
              readOnly: true,  // Prevent manual editing
            ),
            TextFormField(
              controller: _endDateController,
              decoration: InputDecoration(
                labelText: '종료일 (End Date)',
              ),
              onTap: () => _selectDate(context, _endDateController),
              readOnly: true,  // Prevent manual editing
            ),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: '가격 (Price)',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _themeController,
              decoration: InputDecoration(
                labelText: '테마 (Theme)',
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: submitTravelPlan,
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
