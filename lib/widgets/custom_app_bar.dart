import 'package:flutter/material.dart';

import '../common/app_colors.dart';

class CustomAppBar {
  CustomAppBar({
    required this.title,
    required this.onPressed,
  });

  final String title;
  final Function onPressed;

  appBar() {
    return AppBar(
      title: Text(title),
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.bgDark,
      automaticallyImplyLeading: true,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.replay_outlined,
          ),
          onPressed: () {
            onPressed();
          },
        )
      ],
    );
  }
}
