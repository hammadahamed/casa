import 'dart:math';

import 'package:flutter/material.dart';

class Components {
  static Row metric(
    IconData icon, {
    bool smaller = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: smaller ? 14 : 18,
          color: const Color.fromARGB(255, 232, 232, 232),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          '${Random().nextInt(51) + 50}',
          style: TextStyle(fontSize: smaller ? 12 : 14),
        )
      ],
    );
  }

  static Row metricsBar({smaller = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Components.metric(Icons.favorite, smaller: smaller),
        Components.metric(Icons.chat_bubble, smaller: smaller),
        Components.metric(Icons.share, smaller: smaller),
      ],
    );
  }

  // Generates random color for profile avatar
  static Color getRandomColorWithOpacity() {
    Random random = Random();
    int red = random.nextInt(256);
    int green = random.nextInt(256);
    int blue = random.nextInt(256);
    return Color.fromRGBO(red, green, blue, .5);
  }

  static Widget dynamicAvatar() {
    return Container(
      transform: Matrix4.translationValues(0, 4, 0),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        // image: const DecorationImage(
        //   image: NetworkImage(
        //       user.),
        //   fit: BoxFit.cover,
        // ),
        borderRadius: const BorderRadius.all(Radius.circular(60.0)),
        border: Border.all(
          color: const Color.fromARGB(255, 60, 60, 60),
          width: 1.0,
        ),
      ),
      child: Icon(
        Icons.person,
        size: 18,
        color: getRandomColorWithOpacity(),
      ),
    );
  }
}
