import 'package:flutter/material.dart';
import 'package:wonderstring/constants/constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '원더스트링 원생 메시지 발송',
              style: AppTextStyles.h4,
            ),
            Gaps.v30,
            ElevatedButton(
              onPressed: () async {
                await KakaoLoginApi().signWithKakao(context);
                print('성공');
              },
              child: const Text('로그인'),
            ),
          ],
        ),
      ),
    );
  }
}
