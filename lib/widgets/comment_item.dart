import 'package:casa/common/components.dart';
import 'package:casa/models/comment.dart';
import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({
    super.key,
    required this.comment,
  });
  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Components.dynamicAvatar(),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.email,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                // Text(
                //   comment.name,
                //   style: const TextStyle(
                //     color: Colors.white,
                //     fontSize: 14,
                //   ),
                // ),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50.0),
          child: Column(
            children: [
              Text(comment.body),
              const SizedBox(height: 20),
              Components.metricsBar(smaller: true),
            ],
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
