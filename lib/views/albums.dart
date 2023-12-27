import 'package:casa/views/album_details.dart';
import 'package:casa/widgets/app_loading.dart';
import 'package:casa/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import '../common/app_colors.dart';
import '../controller/app_controller.dart';
import '../models/album.dart';

class Albums extends StatefulWidget {
  const Albums({super.key});

  @override
  State<Albums> createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {
  late Future<List<Album>> albumList;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    albumList = getAlbums();
  }

  Future<List<Album>> getAlbums() async {
    setState(() {
      loading = true;
    });
    try {
      albumList = AppController.fetchAlbums(context);
      return albumList;
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
      appBar: CustomAppBar(title: "Albums", onPressed: getAlbums).appBar(),
      body: Container(
        color: AppColors.bgDark,
        child: FutureBuilder<List<Album>>(
          future: albumList,
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
                    Album album = snapshot.data![index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AlbumDetails(
                                    albumbId: album.id,
                                  ),
                                ),
                              )
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                color: AppColors.bgContainer,
                                child: const Center(
                                  child: Icon(
                                    Icons.folder_open,
                                    color: Color.fromARGB(110, 158, 158, 158),
                                    size: 40,
                                  ),
                                ),
                              ),
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
                            album.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
