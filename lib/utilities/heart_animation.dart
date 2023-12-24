import 'package:flutter/material.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // "더이상 누를 수 없습니다!" 문구
              Visibility(
                visible: isMaxSizeReached,
                child: const SizedBox(
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
              const SizedBox(height: 16.0),
      
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
      
                    Future.delayed(const Duration(seconds: 1), () {
                      setState(() {
                        isMaxSizeReached = false;
                      });
                    });
                  }
                },
                child: const Text("+"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(50, 50),
                ),
              ),
              const SizedBox(height: 16.0),
      
              // "-" 버튼
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    iconSize -= 10.0;
                  });
                },
                child: const Text("-"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(50, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}