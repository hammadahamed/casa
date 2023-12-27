import 'package:casa/common/app_colors.dart';
import 'package:casa/models/comment.dart';
import 'package:casa/widgets/app_loading.dart';
import 'package:casa/widgets/comment_item.dart';
import 'package:casa/widgets/post_item.dart';
import 'package:flutter/material.dart';

import '../controller/app_controller.dart';
import '../models/post.dart';
import '../widgets/custom_app_bar.dart';

class PostDetails extends StatefulWidget {
  const PostDetails({
    super.key,
    required this.post,
  });
  final Post post;
  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  List<Comment>? comments;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getPostComments();
  }

  Future<List<Comment>?> getPostComments() async {
    setState(() {
      loading = true;
    });
    try {
      comments =
          await AppController.fetchCommentsForPost(context, widget.post.id);
      return comments;
    } catch (error) {
      throw "Failed";
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  getComments() {
    return comments?.map((comment) => CommentItem(comment: comment)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBar(title: "Albums", onPressed: getPostComments).appBar(),
      backgroundColor: AppColors.bgDark,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: PostItem(
                post: widget.post,
              ),
            ),
            loading == true
                ? const Column(
                    children: [
                      AppLoading(),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Loading Comments..",
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  )
                : comments != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40.0,
                        ),
                        child: Column(
                          children: [
                            ...getComments(),
                          ],
                        ),
                      )
                    : const Text(
                        "Oh Snap, try refreshing !",
                        style: TextStyle(fontSize: 10),
                      ),
          ],
        ),
      ),
    );
  }
}
