import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dream_or_reality/theme/color.dart';

import '../widgets/bottom_navtion_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? _userId;
  String? _userName;
  List<dynamic> _projects = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // 유저 데이터
  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      final userName = prefs.getString('userName');
      setState(() {
        _userId = userId;
        _userName = userName;
      });
      print('Stored user ID: $userId');
      print('Stored user name: $userName');
      if (userId != null) {
        await _getProjects(userId);
      }
    } catch (e, stacktrace) {
      print('Error loading user data: $e');
      print('Stacktrace: $stacktrace');
    }
  }

  //프로젝트 정보 가져오기
  Future<void> _getProjects(int userId) async {
    try {
      final response = await http.post(
        Uri.parse('http://43.202.54.53:3000/user/getProjects'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, int>{
          'UserId': userId,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        setState(() {
          _projects = responseBody is List ? responseBody : [];
        });
      } else {
        final responseBody = jsonDecode(response.body);
        final error = responseBody['error'];
        print('Error fetching projects: $error');
      }
    } catch (e, stacktrace) {
      print('Error fetching projects: $e');
      print('Stacktrace: $stacktrace');
    }
  }

  //날짜 데이터의 형태를 포맷해주는 메서드
  String formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final DateFormat formatter = DateFormat('yyyy년 MM월 dd일');
    return formatter.format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('홈'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 상단 성향 테스트 배너 (누르면 페이지 이동 로직 구현할 것)
            buildTestBanner(context),
            buildMyPostTitle(context, _userName ?? 'Unknown'), // 로그인한 유저네임 불러오기
            // 나의 게시글
            Container(
              padding: const EdgeInsets.only(bottom: 25.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: strokeColor, width: 2))),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 25),
                    Row(
                      // 나의 게시글을 불러옴
                      children: _projects.map(
                        (project) {
                          // 내가 진행중인 프로젝트를 불러옴
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: buildMyPost(
                                  context,
                                  project['title'],
                                  formatDate(project['deadline']),
                                  project['recruit']),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ],
                ),
              ),
            ),
            buildMyProjectTitle(context, _userName ?? 'Unknown'),
            // 내가 진행중인 프로젝트
            Container(
              padding:
                  const EdgeInsets.only(bottom: 25.0, left: 25.0, right: 25.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: strokeColor, width: 2))),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildMyProject(context, 'STAC 개발 공모전', '2024-12-24'),
                    SizedBox(height: 10),
                    buildMyProject(context, 'Flutter로 쇼핑몰 제작', '2024-08-02'),
                    SizedBox(height: 10),
                    buildMyProject(context, '미림 소프트웨어 챌린지', '2024-07-21'),
                  ],
                ),
              ),
            ),
            buildAbilityTitle(context, _userName ?? 'Unknown'),
            buildPieChart(),
          ],
        ),
      ),
      // 하단 내비게이션 바
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.pushNamed(context, '/study');
              break;
            case 2:
              Navigator.pushNamed(context, '/memoir');
              break;
            case 3:
              showMyPageAlert(context);
              break;
          }
        },
      ),
    );
  }

  // 마이페이지 접속 막기
  void showMyPageAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('알림'),
          content: Text('원활한 전시를 위해 마이페이지 탭에는 접속하실 수 없습니다!'),
          actions: [
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// 테스트 하러가기 배너
Widget buildTestBanner(BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.pushNamed(context, '/test_start');
    },
    child: Container(
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
      decoration: BoxDecoration(
        color: primaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '나는 어떤 성향의\n개발자/디자이너 일까?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'PartialSansKR',
                ),
              ),
              Text(
                '👉 지금 테스트 하러가기!',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'PartialSansKR',
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Image.asset(
            'assets/img/illustration/developer.png',
            width: 115,
          ),
        ],
      ),
    ),
  );
}

// ~~님의 게시글(title)
Widget buildMyPostTitle(BuildContext context, String username) {
  return Padding(
    padding: const EdgeInsets.all(25.0),
    child: Row(
      children: [
        Text(
          "$username님의",
          style: const TextStyle(fontSize: 18),
        ),
        Text(
          " \"게시글\"",
          style: TextStyle(
              color: primaryColor, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

// 내가 작성한 포스트 컨테이너
Widget buildMyPost(
    BuildContext context, String title, String description, int people) {
  return Container(
    padding: const EdgeInsets.all(15.0),
    decoration: BoxDecoration(
      border: Border.all(color: secondaryColor),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.length > 10 ? '${title.substring(0, 10)}...' : title,
          style: TextStyle(fontSize: 15),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        SizedBox(height: 10),
        Text(
          "기간",
          style: TextStyle(fontSize: 13, color: secondTextColor),
        ),
        SizedBox(height: 5),
        Text(
          description,
          style: TextStyle(fontSize: 13),
        ), // 모집 마감일로 바꿔주세요!!
        SizedBox(height: 10),
        Text(
          "모집인원",
          style: TextStyle(fontSize: 13, color: secondTextColor),
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Icon(
              Icons.person,
              size: 20,
              color: primaryColor,
            ),
            SizedBox(width: 10),
            Text(
              people.toString(),
              style: TextStyle(fontSize: 13, color: primaryColor),
            )
          ],
        ),
      ],
    ),
  );
}

// ~~님이 진행중인 프로젝트 (title)
Widget buildMyProjectTitle(BuildContext context, String username) {
  return Padding(
    padding: const EdgeInsets.all(25.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Row(
            children: [
              Text(
                "$username님의",
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                " \"프로젝트\"",
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            showAddEditAlert(context);
          },
          child: Text('+ 추가하기', style: TextStyle(color: secondTextColor)),
        ),
      ],
    ),
  );
}

showAddProjectDialog(BuildContext context) {}

// 진행중인 프로젝트 컨테이너
Widget buildMyProject(BuildContext context, String title, String date) {
  return Container(
    padding: EdgeInsets.all(15),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: primaryColor, width: 1),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        //SizedBox(height: 5),
        Text(
          date,
          style: TextStyle(fontSize: 12, color: secondTextColor),
        ),
      ],
    ),
  );
}

// ~~님의 능력치
Widget buildAbilityTitle(BuildContext context, String username) {
  return Padding(
    padding: const EdgeInsets.all(25.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Row(
            children: [
              Text(
                "$username님의",
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                " \"능력치\"",
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            showAddEditAlert(context);
          },
          child: Text('수정하기', style: TextStyle(color: secondTextColor)),
        ),
      ],
    ),
  );
}

// 프로젝트 추가/수정 막기
void showAddEditAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('알림'),
        content: Text('원활한 전시를 위해 이 기능은 사용하실 수 없습니다!'),
        actions: [
          TextButton(
            child: Text('확인'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

// 파이차트
Widget buildPieChart() {
  List<PieChartSectionData> pieChartSections = [
    PieChartSectionData(
      color: primaryColor,
      value: 35,
      title: 'Flutter',
      radius: 80,
      titleStyle: TextStyle(
          fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    PieChartSectionData(
      color: primaryColor.withOpacity(0.5),
      value: 15,
      title: 'Node.js',
      radius: 80,
      titleStyle: TextStyle(
          fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    PieChartSectionData(
      color: secondaryColor,
      value: 20,
      title: 'MySQL',
      radius: 80,
      titleStyle: TextStyle(
          fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    PieChartSectionData(
      color: secondaryColor.withOpacity(0.3),
      value: 25,
      title: 'AWS',
      radius: 80,
      titleStyle: TextStyle(
          fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    PieChartSectionData(
      color: secondaryColor.withOpacity(0.5),
      value: 5,
      title: 'Vue.js',
      radius: 80,
      titleStyle: TextStyle(
          fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
    ),
  ];

  return Container(
    height: 300, // 도넛형 파이차트의 전체 높이
    child: PieChart(
      PieChartData(
        sections: pieChartSections,
        borderData: FlBorderData(show: false),
        centerSpaceRadius: 40, // 중앙 공간 반지름 (도넛의 크기를 조절)
        sectionsSpace: 0,
        pieTouchData: PieTouchData(enabled: false),
        startDegreeOffset: -90, // 시작 각도 설정
      ),
    ),
  );
}
