import 'package:flutter/material.dart';
import 'package:wonderstring/constants/constants.dart';

class TextPreview extends StatelessWidget {
  final String messageText;
  final String userPhotoUrl;

  const TextPreview({
    super.key,
    required this.messageText,
    required this.userPhotoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            messageText,
            style: const TextStyle(
              fontFamily: 'pretendard',
              fontSize: 10,
              height: 14 / 10,
              color: AppColors.black,
            ),
          ),
          Gaps.v12,
          Container(
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.g2,
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: const Text('자세히보기',
                style: TextStyle(
                  fontFamily: 'pretendard',
                  fontSize: 11,
                  height: 14 / 11,
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center),
          ),
          Gaps.v12,
          Row(
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                ),
                child: AppIcon.wonder_string_pic,
              ),
              Gaps.h4,
              Text(
                'WonderString',
                style: AppTextStyles.caption
                    .copyWith(color: const Color(0xff999999)),
              )
            ],
          )
        ],
      ),
    );
  }
}
