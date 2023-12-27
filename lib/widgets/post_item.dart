import 'package:casa/common/components.dart';
import "package:flutter/material.dart";

import '../models/post.dart';

class PostItem extends StatelessWidget {
  const PostItem({
    super.key,
    required this.post,
  });
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          post.title,
          style: const TextStyle(
            fontSize: 19,
            height: 1.1,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          post.body,
          style: const TextStyle(
            fontSize: 13,
            height: 1.5,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(
          height: 35,
        ),
        Components.metricsBar(),
        const Divider(
          color: Color.fromARGB(255, 44, 44, 44),
        ),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
