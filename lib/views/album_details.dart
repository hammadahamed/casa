import 'package:casa/common/app_colors.dart';
import 'package:casa/models/photo.dart';
import 'package:casa/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import '../controller/app_controller.dart';
import '../widgets/app_loading.dart';

class AlbumDetails extends StatefulWidget {
  const AlbumDetails({
    super.key,
    required this.albumbId,
  });
  final int albumbId;
  @override
  State<AlbumDetails> createState() => _AlbumDetailsState();
}

class _AlbumDetailsState extends State<AlbumDetails> {
  late Future<List<Photo>> photoList;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    photoList = getPhotos();
  }

  Future<List<Photo>> getPhotos() async {
    setState(() {
      loading = true;
    });
    try {
      photoList = AppController.fetchPhotos(context, widget.albumbId);
      return photoList;
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
      appBar: CustomAppBar(title: "", onPressed: getPhotos).appBar(),
      body: Container(
        color: AppColors.bgDark,
        child: FutureBuilder<List<Photo>>(
          future: photoList,
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
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 25,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Photo photo = snapshot.data![index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Image.network(
                              photo.thumbnailUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                    ),
                                  );
                                }
                              },
                              errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.photo_size_select_large,
                                        color:
                                            Color.fromARGB(255, 218, 218, 218),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Network Error !',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey.withOpacity(.5),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                            right: 8,
                          ),
                          child: Text(
                            photo.title,
                            maxLines: 1,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 248, 248, 248),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
