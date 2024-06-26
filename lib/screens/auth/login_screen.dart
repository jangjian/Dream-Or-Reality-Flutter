import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final String id = _userIdController.text;
    final String pw = _passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('http://43.202.54.53:3000/user/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'id': id,
          'pw': pw,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final userId = responseBody['UserId']; // int 타입으로 저장
        print('Logged in user ID: $userId');

        // 로그인 성공 시, userId를 로컬 스토리지에 저장
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', userId);

        // userId를 이용해 사용자의 이름을 가져오기
        await _getUserName(userId);

        // 로그인 성공 시, '/' 경로로 이동
        Navigator.pushNamed(context, '/');
      } else {
        final responseBody = jsonDecode(response.body);
        final error = responseBody['error'];
        print('Login error: $error');

        // 로그인 실패 시 알림
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text(error),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e, stacktrace) {
      print('Login error: $e');
      print('Stacktrace: $stacktrace');
      // 예외 발생 시 알림
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Error'),
            content: Text('An error occurred during login. Please try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _getUserName(int userId) async {
    try {
      final response = await http.post(
        Uri.parse('http://43.202.54.53:3000/user/getUserName'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, int>{
          'UserId': userId,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final userName = responseBody['name'];
        print('User name: $userName');

        // 사용자 이름을 로컬 스토리지에 저장
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userName', userName);
      } else {
        final responseBody = jsonDecode(response.body);
        final error = responseBody['error'];
        print('Error fetching user name: $error');
      }
    } catch (e, stacktrace) {
      print('Error fetching user name: $e');
      print('Stacktrace: $stacktrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 아이디 입력
            TextField(
              controller: _userIdController,
              decoration: const InputDecoration(
                labelText: 'UserId',
              ),
            ),
            const SizedBox(height: 16),
            // 비밀번호 입력
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
