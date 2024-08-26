import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserInfo {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // 사용자 ID 가져오기
  Future<String?> get userId async {
    String? data =
        await _prefs.then((prefs) => prefs.getString('kakaoUserData'));
    if (data != null) {
      var jsonData = jsonDecode(data);
      return jsonData['id'].toString();
    }
    return null;
  }

  // 사용자 닉네임 가져오기
  Future<String?> get userNickname async {
    String? data =
        await _prefs.then((prefs) => prefs.getString('kakaoUserData'));
    if (data != null) {
      var jsonData = jsonDecode(data);
      return jsonData['properties']['nickname'];
    }
    return null;
  }

  // 프로필 이미지 URL 가져오기
  Future<String?> get userProfileImage async {
    String? data =
        await _prefs.then((prefs) => prefs.getString('kakaoUserData'));
    if (data != null) {
      var jsonData = jsonDecode(data);
      return jsonData['properties']['profile_image'];
    }
    return null;
  }

  // 썸네일 이미지 URL 가져오기
  Future<String?> get userThumbnailImage async {
    String? data =
        await _prefs.then((prefs) => prefs.getString('kakaoUserData'));
    if (data != null) {
      var jsonData = jsonDecode(data);
      return jsonData['properties']['thumbnail_image'];
    }
    return null;
  }

  // 사용자 이메일 가져오기
  Future<String?> get userEmail async {
    String? data =
        await _prefs.then((prefs) => prefs.getString('kakaoUserData'));
    if (data != null) {
      var jsonData = jsonDecode(data);
      var kakaoAccount = jsonData['kakao_account'];
      return kakaoAccount != null ? kakaoAccount['email'] : null;
    }
    return null;
  }

  // 이메일 유효성 및 인증 상태 가져오기
  Future<bool> get isEmailVerified async {
    String? data =
        await _prefs.then((prefs) => prefs.getString('kakaoUserData'));
    if (data != null) {
      var jsonData = jsonDecode(data);
      var kakaoAccount = jsonData['kakao_account'];
      return kakaoAccount != null ? kakaoAccount['is_email_verified'] : false;
    }
    return false;
  }
}
