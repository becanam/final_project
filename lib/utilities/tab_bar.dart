import 'package:flutter/material.dart';

class CategoryTabs extends StatelessWidget {
  const CategoryTabs({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 6,
        child: Column(
          children: [
            Container(
              height: 45,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(25.0)),
              child: TabBar(
                indicator: BoxDecoration(
                    color: Colors.blue,
                    borderRadius:  BorderRadius.circular(25.0)
                  ) ,
                isScrollable: true,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                indicatorColor: const Color.fromARGB(255, 0, 0, 0),
                tabs: const [
                  Tab(
                      child: Text(
                    "All",
                  )),
                  Tab(child: Text("Mountain")),
                  Tab(child: Text("Forest")),
                  Tab(child: Text("Desert")),
                  Tab(child: Text("Beach")),
                  Tab(child: Text("Lake")),
                ],
              ),
            )
          ],
        ));
  }
}
