import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart';
import 'package:wonderstring/constants/constants.dart';
import 'package:http/http.dart' as http;

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  Map<String, String> userProfile = {};
  List<int> selectedIndexes = []; // 여러 개의 선택된 항목을 저장하는 리스트
  bool firstCheck = false;
  bool secondCheck = false;
  Uint8List? userProfileImageData;

  String userNickname = '';
  String userPhotoUrl = '';

  // TextEditingController로 텍스트 필드의 내용을 추적합니다.
  final TextEditingController messageController = TextEditingController();
  final TextEditingController webUrlController = TextEditingController();
  final TextEditingController mobileUrlController = TextEditingController();

  String messageText = '';
  String webUrlText = '';
  String mobileUrlText = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();

    // 각 TextEditingController에 Listener를 추가하여 변경 사항을 감지하고 setState를 호출합니다.
    messageController.addListener(() {
      setState(() {
        messageText = messageController.text;
      });
    });

    webUrlController.addListener(() {
      setState(() {
        webUrlText = webUrlController.text;
      });
    });

    mobileUrlController.addListener(() {
      setState(() {
        mobileUrlText = mobileUrlController.text;
      });
    });
  }

  Future<void> _fetchImageData() async {
    // String proxyUrl = 'https://api.mapda.site/proxy';
    String proxyUrl = 'http://localhost:8000/proxy';
    // 이미지 URL을 쿼리 파라미터로 전달
    String targetUrl = userPhotoUrl;
    try {
      // 프록시 서버를 통해 이미지 데이터 요청
      final response = await http
          .get(Uri.parse('$proxyUrl?target_url=$targetUrl'), headers: {
        'Accept': 'image/jpeg',
      });
      if (response.statusCode == 200) {
        setState(() {
          userProfileImageData = response.bodyBytes;
        });
      } else {
        print('Failed to load image, Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching image: $e');
    }
  }

  // 사용자 정보 비동기로 가져오기
  Future<void> _loadUserInfo() async {
    final userInfo = UserInfo();
    final nickname = await userInfo.userNickname;
    final profileImage = await userInfo.userProfileImage;

    setState(() {
      userNickname = nickname ?? 'Unknown';
      userPhotoUrl = profileImage ?? '';
    });
    _fetchImageData();

    print('유저 닉네임: $userNickname');
    print('유저 사진 경로: $userPhotoUrl');
  }

  TextTemplate createDefaultText() {
    return TextTemplate(
      text: messageText,
      link: Link(
        webUrl: Uri.parse(webUrlText.isNotEmpty
            ? webUrlText
            : 'https://developers.kakao.com'),
        mobileWebUrl: Uri.parse(mobileUrlText.isNotEmpty
            ? mobileUrlText
            : 'https://developers.kakao.com'),
      ),
    );
  }

  void sendMessagesToMe() async {
    try {
      await TalkApi.instance.sendDefaultMemo(createDefaultText());
      print('나에게 보내기 성공');
    } catch (error) {
      print('나에게 보내기 실패 $error');
    }
  }

  PreferredSizeWidget thisAppBar() {
    return AppBar(
        toolbarHeight: 44,
        backgroundColor: AppColors.ws_main,
        centerTitle: false,
        title: Text('WONDERSTRING',
            style: AppTextStyles.tensor_sans.copyWith(color: AppColors.white)),
        actions: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.white,
            backgroundImage: MemoryImage(userProfileImageData ?? Uint8List(0)),
          ),
          Gaps.h30,
        ]);
  }

  Widget thisFriendList() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: 380,
      decoration: const BoxDecoration(
        color: AppColors.g6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Gaps.v20,
          Text('학원 수강생 목록',
              style: AppTextStyles.st2.copyWith(color: AppColors.white)),
          Gaps.v10,
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 90),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Scrollbar(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (selectedIndexes.contains(index)) {
                            selectedIndexes.remove(index); // 이미 선택된 경우 제거
                          } else {
                            selectedIndexes.add(index); // 선택되지 않은 경우 추가
                          }
                        });
                      },
                      child: StudentList(
                        isSelected: selectedIndexes.contains(index), // 선택 여부 확인
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget thisBody() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 100,
          vertical: 50,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('발송할 문구',
                  style: AppTextStyles.bd1.copyWith(color: AppColors.black)),
              Gaps.v12,
              TextField(
                controller: messageController,
                maxLength: 200,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.g2,
                      width: 1,
                    ),
                  ),
                  hintText: '발송할 내용을 입력해주세요',
                  hintStyle: AppTextStyles.bd4.copyWith(color: AppColors.g6),
                ),
              ),
              Gaps.v28,
              Text('발송할 주소(URL) - 웹',
                  style: AppTextStyles.bd1.copyWith(color: AppColors.black)),
              Gaps.v12,
              TextField(
                controller: webUrlController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.g2,
                      width: 1,
                    ),
                  ),
                  hintText: '발송할 URL을 입력해주세요',
                  hintStyle: AppTextStyles.bd4.copyWith(color: AppColors.g6),
                ),
              ),
              Gaps.v28,
              Text('발송할 주소(URL) - 모바일',
                  style: AppTextStyles.bd1.copyWith(color: AppColors.black)),
              Gaps.v12,
              TextField(
                controller: mobileUrlController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.g2,
                      width: 1,
                    ),
                  ),
                  hintText: '발송할 URL을 입력해주세요',
                  hintStyle: AppTextStyles.bd4.copyWith(color: AppColors.g6),
                ),
              ),
              Gaps.v28,
              Text('발송할 수강생',
                  style: AppTextStyles.bd1.copyWith(color: AppColors.black)),
              Gaps.v12,
              Row(children: [
                Text('선택된 수강생',
                    style: AppTextStyles.bd4.copyWith(color: AppColors.g6)),
                Gaps.h12,
                Text('${selectedIndexes.length}명',
                    style: AppTextStyles.bd4.copyWith(color: AppColors.black))
              ]),
              Gaps.v28,
              Text('발송 문자 미리보기',
                  style: AppTextStyles.bd1.copyWith(color: AppColors.black)),
              Gaps.v12,
              Container(
                  height: 400,
                  width: 600,
                  decoration: BoxDecoration(
                    color: const Color(0xffBACEDF),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.g2,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: TextPreview(
                        messageText: messageText, userPhotoUrl: userPhotoUrl),
                  )),
              Gaps.v20,
              Text('모든 내용을 확인하셨나요?',
                  style: AppTextStyles.bd1.copyWith(color: AppColors.black)),
              Text(
                firstCheck ? '정말로 확인하셨나요?' : '발송 후에는 취소할 수 없습니다. 신중히 확인해주세요.',
                style: AppTextStyles.bd4.copyWith(color: AppColors.black),
              ),
              Gaps.v12,
              Row(
                children: [
                  Checkbox(
                    value: firstCheck,
                    onChanged: (bool? value) {
                      setState(() {
                        firstCheck = value ?? false;
                        secondCheck = false;
                      });
                    },
                  ),
                  Text(
                    '위 내용을 확인했습니다.',
                    style: AppTextStyles.bd4.copyWith(color: AppColors.black),
                  ),
                ],
              ),
              if (firstCheck) ...[
                Row(
                  children: [
                    Checkbox(
                      value: secondCheck,
                      onChanged: (bool? value) {
                        setState(() {
                          secondCheck = value ?? false;
                        });
                      },
                    ),
                    Text(
                      '정말로 확인했습니다.',
                      style: AppTextStyles.bd4.copyWith(color: AppColors.black),
                    ),
                  ],
                ),
              ],
              Gaps.v20,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: thisAppBar(),
      body: Row(
        children: [
          thisFriendList(),
          thisBody(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: firstCheck && secondCheck
            ? AppColors.g2
            : AppColors.g4, // 전송 버튼 활성화/비활성화
        onPressed: firstCheck && secondCheck
            ? sendMessagesToMe
            : null, // 전송 버튼 활성화/비활성화
        child: Text(
          firstCheck && secondCheck ? '발송' : '발송 불가',
          style: firstCheck && secondCheck
              ? AppTextStyles.btn2.copyWith(color: AppColors.black)
              : AppTextStyles.btn2.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}
