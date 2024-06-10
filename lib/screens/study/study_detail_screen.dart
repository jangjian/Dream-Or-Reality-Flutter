import 'package:flutter/material.dart';
import 'package:flutter_dream_or_reality/theme/color.dart';

class StudyDetailScreen extends StatefulWidget {
  const StudyDetailScreen({super.key});

  @override
  State<StudyDetailScreen> createState() => _StudyDetailScreenState();
}

class _StudyDetailScreenState extends State<StudyDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildDetailHeader(),
            buildDetailInfo(),
          ],
        ),
      ),
    );
  }

  Widget buildDetailHeader() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: strokeColor, width: 2)),
      ),
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'IT 서비스 공모전에 참여하실 디자인과 분을 모십니다!',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
          Text('김햄지'),
          SizedBox(height: 20),
          Text(
            '상금이 500만원인 공모전에 참여하실 디자이너분을 모집합니다. 저희는 1주일에 2번 화상회의를 합니다.\n\n저희 팀은 각종 서비스 공모전에서 시상을 할 만큼 능력있는 개발자로 꾸려져 있으나 현재 디자인 인력이 부족한 팀입니다. 피그마를 잘 다룰줄 알며, 어느 정도 기본기가 탄탄한 디자이너를 구합니다.\n\n댓글 남겨주시면 연락드리겠습니다.',
          ),
        ],
      ),
    );
  }

  Widget buildDetailInfo() {
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: strokeColor, width: 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildInfoSection(
            title: '기한',
            content: Text('8월 25일'),
          ),
          SizedBox(height: 20),
          buildInfoSection(
            title: '인원',
            content: Row(
              children: [
                Icon(Icons.person, size: 20, color: primaryColor),
                SizedBox(width: 15),
                Text(
                  '3',
                  style: TextStyle(color: primaryColor),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          buildInfoSection(
            title: '제한사항',
            content: Container(
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: strokeColor,
              ),
              child: Text(
                '프로젝트를 중도포기 하신 적 있으신 분은 함께하기 어렵습니다.',
                style: TextStyle(color: secondTextColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoSection({required String title, required Widget content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: secondTextColor),
        ),
        SizedBox(height: 10),
        content,
      ],
    );
  }
}