import 'package:flutter/material.dart';
import 'package:wonderstring/constants/constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void performLogin(BuildContext context) async {
    await signInWithKakao(context);

    if (await UserInfo().userNickname != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MessageScreen()),
      );
    }
  }

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
              onPressed: () => performLogin(context),
              child: const Text('로그인'),
            ),
          ],
        ),
      ),
    );
  }
}
