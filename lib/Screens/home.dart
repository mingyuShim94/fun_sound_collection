import 'package:flutter/material.dart';
import 'package:happy_button/Screens/detail.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('장난치기 좋은 소리 모음'),
      ),
      body: GridView.count(
        crossAxisCount: 3, // 열의 수
        shrinkWrap: true, // 그리드 크기를 내용에 맞게 축소
        children: List.generate(15, (index) {
          // 각 셀에 사각형 추가
          final imagePath = 'assets/images/image${index + 1}.jpg';
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      DetailScreen(imagePath: imagePath, id: index),
                ),
              );
            },
            child: Hero(
              tag: imagePath,
              child: Container(
                color: Colors.blue, // 사각형의 배경색
                margin: const EdgeInsets.all(10.0), // 사각형 간의 간격 조정
                width: 50.0, // 사각형의 가로 길이
                height: 50.0, // 사각형의 세로 길이
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
