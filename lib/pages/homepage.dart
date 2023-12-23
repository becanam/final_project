import 'package:flutter/material.dart';
import 'package:midterm_project/utilities/tab_bar.dart';
import 'package:midterm_project/utilities/travel_options.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomePageState();
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //appbar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //menu icon
                  CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 25,
                    child: Image.asset('lib/icons/app.png',
                        height: horizontalPadding, color: Colors.grey[800]),
                  ),

                  //profile
                  CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 25,
                    child: Image.asset('lib/icons/user.png',
                        height: horizontalPadding, color: Colors.grey[800]),
                  )
                ],
              ),
            ),

            //title
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: verticalPadding),
              child: Container(
                  width: 250,
                  height: 125,
                  color: Colors.black.withOpacity(0),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Best Places For Travel",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Find the best places to visit!",
                        style: TextStyle(
                            wordSpacing: 2,
                            height: 2,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 135, 131, 131)),
                      ),
                    ],
                  )),
            ),

            //scrollable tab
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: CategoryTabs()),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: verticalPadding),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //trending now
                  Text(
                    "Trending Now",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  //see all
                  Text(
                    "See all",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  )
                ],
              ),
            ),

            //travel options
            Expanded(
              child: GridView.builder(
                itemCount: travelPlaces.length,
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1.65,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      _navigateToDetailPage(context, travelPlaces[index][0]);
                    },
                    child: PlacesToTravel(
                      countryName: travelPlaces[index][0],
                      iconPath: travelPlaces[index][1],
                      rating: travelPlaces[index][2],
                      cityImage: travelPlaces[index][3],
                    ),
                  );
                },
              ),
            ),
          ],
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
