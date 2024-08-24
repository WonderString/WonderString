import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:wonderstring/constants/constants.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 엔진 초기화
  KakaoSdk.init(
    nativeAppKey: '59daa763c472339a3b29b13ae11ab1b9',
    javaScriptAppKey: 'b762dae5998ff4aa45575c32aa5598fb',
  );
  setPathUrlStrategy(); // 꼭 제일 밑에
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wonderstring 학원생 관리 프로그램',
      debugShowCheckedModeBanner: false,
      theme: ThemeManage.theme,
      home: const LoginScreen(),
    );
  }
}
