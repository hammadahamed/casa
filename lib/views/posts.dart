import 'package:casa/views/post_details.dart';
import 'package:casa/widgets/post_item.dart';
import 'package:flutter/material.dart';

import '../common/app_colors.dart';
import '../controller/app_controller.dart';
import '../models/post.dart';
import '../widgets/app_loading.dart';
import '../widgets/custom_app_bar.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  late Future<List<Post>> postsList;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    postsList = getPosts();
  }

  Future<List<Post>> getPosts() async {
    setState(() {
      loading = true;
    });
    try {
      postsList = AppController.fetchUserPosts(context);
      return postsList;
    } catch (error) {
      throw "Failed";
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "My Posts", onPressed: getPosts).appBar(),
      body: Container(
        color: AppColors.bgDark,
        child: FutureBuilder<List<Post>>(
          future: postsList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AppLoading();
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Failed to load albums'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No albums available'),
              );
            } else {
              List<Post>? posts = snapshot.data;
              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: posts?.length,
                itemBuilder: (context, index) {
                  Post post = snapshot.data![index];
                  return posts != null
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostDetails(
                                  post: post,
                                ),
                              ),
                            );
                          },
                          child: PostItem(
                            post: post,
                          ),
                        )
                      : const SizedBox();
                },
              );
            }
          },
        ),
      ),
    );
  }
}
