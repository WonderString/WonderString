// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

//앱 로그인
Future<void> signInWithKakao(BuildContext context) async {
  print('카카오해시값 ${await KakaoSdk.origin}');

  if (await isKakaoTalkInstalled()) {
    try {
      await UserApi.instance.loginWithKakaoTalk();

      User user = await UserApi.instance.me();
      AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
      print('사용자 데이터: $user');
      print('토큰 유효성 체크 성공 ${tokenInfo.id} ${tokenInfo.expiresIn}');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('kakaoUserData', jsonEncode(user.toJson()));
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');

      if (error is PlatformException && error.code == 'CANCELED') {
        return;
      }
      await tryKakaoAccountLogin(context);
    }
  } else {
    await tryKakaoAccountLogin(context);
  }
}

// 웹 로그인
Future<void> tryKakaoAccountLogin(BuildContext context) async {
  try {
    await UserApi.instance.loginWithKakaoAccount();

    User user = await UserApi.instance.me();
    AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
    print('사용자 데이터: $user');
    print('토큰 유효성 체크 성공 ${tokenInfo.id} ${tokenInfo.expiresIn}');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('kakaoUserData', jsonEncode(user.toJson()));
  } catch (error) {
    print('카카오계정으로 로그인 실패: $error');
  }
}
