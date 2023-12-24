import 'package:flutter/material.dart';
import 'package:midterm_project/pages/addplan_page.dart';
import 'package:midterm_project/pages/homepage.dart';
import 'package:midterm_project/pages/myplans_page.dart';
import 'package:midterm_project/utilities/nav_bar.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
        return Container(
          color: Colors.white,
          child: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(horizontal: 80),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadius.all(Radius.circular(30))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BottomNavWidget(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Homepage()), // Replace HomePage with your desired page
                      );
                    },
                    tabName: "Home",
                  ),
                  BottomNavWidget(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AddPlanPage()), // Replace HomePage with your desired page
                      );
                    },
                    tabName: "Add Plan",
                  ),
                  BottomNavWidget(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const MyPlansScreen()), // Replace HomePage with your desired page
                      );
                    },
                    tabName: "My Plans",
                  ),
                ],
              ),
            ),
          )),
        );
  }
}