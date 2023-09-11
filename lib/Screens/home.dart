import 'package:flutter/material.dart';
import 'package:happy_button/Screens/detail.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<String> text = [
    '방귀',
    '바리깡',
    '접시깨짐',
    '머리자르는 가위',
    'xxxxhub',
    '트름',
    '뼈부러짐',
    '모기',
    '싸우는고양이',
    'Air horn',
    '차사고',
    '닭울음소리',
    '생일폭죽',
    '뺨때리기',
    '여자비명',
  ];
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
                  builder: (context) => DetailScreen(
                      imagePath: imagePath, id: index, name: text[index]),
                ),
              );
            },
            child: Hero(
              tag: imagePath,
              child: Column(
                children: [
                  Container(
                    color: Colors.blue, // 사각형의 배경색
                    margin: const EdgeInsets.all(10.0), // 사각형 간의 간격 조정
                    width: 100.0, // 사각형의 가로 길이
                    height: 100.0, // 사각형의 세로 길이
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    text[index],
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
