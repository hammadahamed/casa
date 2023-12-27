import 'package:casa/common/app_colors.dart';
import "package:flutter/material.dart";

class ProfileItem extends StatelessWidget {
  const ProfileItem({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 30,
        ),
        Text(
          title,
          style: const TextStyle(
            color: Color.fromARGB(255, 202, 202, 202),
            fontSize: 13,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.only(
            bottom: 8,
            left: 8,
            right: 8,
            top: 4,
          ),
          decoration: BoxDecoration(
            color: AppColors.bgContainer,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            value,
            style: const TextStyle(height: 1.5),
          ),
        ),
      ],
    );
  }
}
