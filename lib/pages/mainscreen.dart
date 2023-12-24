import 'package:flutter/material.dart';
import 'package:midterm_project/controllers/mainscreen_provider.dart';
import 'package:midterm_project/pages/addplan_page.dart';
import 'package:midterm_project/pages/homepage.dart';
import 'package:midterm_project/utilities/navigation_bar.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final List<Widget> pageList = [
    const Homepage(),
    const AddPlanPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenNotifier>(
      builder: (context, mainScreenNotifier, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: pageList[mainScreenNotifier.pageIndex],
        bottomNavigationBar: const BottomNavBar(),
      );
    });
  }
}


