import 'package:flutter/material.dart';

import '../../theme/color.dart';

class WriteMemoirScreen extends StatelessWidget {
  final DateTime selectedDate;

  const WriteMemoirScreen({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    late String memoirContent;

    void saveMemoirToDatabase(String text) {
      //TODO: 데이터 베이스에 값을 저장하는 로직 구현하기
      print(memoirContent);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("회고록 작성"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 80),
            // 선택된 날짜를 불러옴
            Text(
              "${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일",
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xFFB3B3B3),
              ),
            ),
            const SizedBox(height: 40),
            // 회고록 작성
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: const TextStyle(fontSize: 18),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 50),
                hintText: '오늘 하루를 기록해보세요.',
                hintStyle: TextStyle(
                  fontSize: 18,
                ),
              ),
              textAlign: TextAlign.center,
              onChanged: (value) {
                // 텍스트가 변경될 때마다 memoirText 변수에 저장
                memoirContent = value;
              },
            ),
            const Spacer(),
            //저장 버튼
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {
                  saveMemoirToDatabase(memoirContent);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  '저장하기',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}