import 'package:flutter/material.dart';
import 'package:wonderstring/constants/constants.dart';

class StudentList extends StatelessWidget {
  final bool isSelected; // 선택 여부를 받는 변수

  const StudentList({super.key, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.g6.withOpacity(0.3)
            : Colors.transparent, // 선택된 항목의 배경색
        border: const Border(
          bottom: BorderSide(
            color: AppColors.stroke,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.white,
              backgroundImage: NetworkImage(
                  'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg')),
          Gaps.h12,
          Text('홍길동',
              style: AppTextStyles.bd3.copyWith(color: AppColors.black)),
        ],
      ),
    );
  }
}
