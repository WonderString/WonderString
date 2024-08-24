import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> signInWithKakao(BuildContext context) async {
  print('카카오해시값 ${await KakaoSdk.origin}');

  // 카카오톡 실행 가능 여부 확인
  if (await isKakaoTalkInstalled()) {
    try {
      await UserApi.instance.loginWithKakaoTalk();

      // 사용자 정보 요청
      User user = await UserApi.instance.me();
      print('사용자 ID: ${user.id}');
      print('사용자 이메일: ${user.kakaoAccount!.email}');

      // user.id와 userEmail을 SharedPreferences에 안전하게 저장
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('kakaoUserID', user.id.toString());
      String? userEmail = user.kakaoAccount?.email;
      await prefs.setString('kakaoUserEmail', userEmail ?? '');
      print('성공');
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');

      if (error is PlatformException && error.code == 'CANCELED') {
        // 사용자가 로그인을 취소한 경우
        return;
      }
      // 카카오계정으로 시도
      await tryKakaoAccountLogin(context);
    }
  } else {
    // 카카오계정으로 로그인 시도
    await tryKakaoAccountLogin(context);
  }
}

Future<void> tryKakaoAccountLogin(BuildContext context) async {
  try {
    await UserApi.instance.loginWithKakaoAccount();

    // 사용자 정보 요청
    User user = await UserApi.instance.me();
    print('사용자 ID: ${user.id}');
    print('사용자 이메일: ${user.kakaoAccount!.email}');

    // user.id와 userEmail을 SharedPreferences에 안전하게 저장
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('kakaoUserID', user.id.toString());
    String? userEmail = user.kakaoAccount?.email;
    await prefs.setString('kakaoUserEmail', userEmail ?? '');
  } catch (error) {
    print('카카오계정으로 로그인 실패: $error');
    if (error is Exception) {
      // 예외에 따른 추가적인 에러 처리를 여기에 구현할 수 있습니다.
    }
  }
}
