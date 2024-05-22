import 'package:flutter/material.dart';
import 'package:flutter_dream_or_reality/screens/memoir/write_memoir_screen.dart';
import 'package:flutter_dream_or_reality/theme/color.dart';
import 'package:flutter_dream_or_reality/widgets/memoir_calendar_widget.dart';

import '../../widgets/bottom_navtion_bar_widget.dart';

class MemoirScreen extends StatefulWidget {
  const MemoirScreen({super.key});

  @override
  State<MemoirScreen> createState() => _MemoirScreenState();
}

class _MemoirScreenState extends State<MemoirScreen> {
  // 선택된 날짜를 관리하는 변수
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  // 선택된 날짜를 업데이트
  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회고록'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          MemoirCalendarWidget(
            selectedDate: selectedDate, // 현재 선택된 날짜 전달
            onDaySelected: onDaySelected, // 날짜 선택 시 호출될 콜백 함수 설정
          ),
        ],
      ),
      // 플로팅 버튼
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      WriteMemoirScreen(selectedDate: selectedDate)));
        },
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: const Text(
          '글쓰기',
          style: TextStyle(
              fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
      ),
      // 하단 내비게이션 바
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pop(context, '/');
              break;
            case 1:
              Navigator.pushNamed(context, '/study');
              break;
          }
        },
      ),
    );
  }
}
