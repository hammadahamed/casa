import 'dart:io';

import 'package:casa/common/app_colors.dart';
import 'package:casa/common/utils.dart';
import 'package:casa/controller/app_controller.dart';
import 'package:casa/dio_instance.dart';
import 'package:casa/widgets/app_loading.dart';
import 'package:casa/widgets/custom_app_bar.dart';
import 'package:casa/widgets/profile_item.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Dio apiFactory = ApiFactory().dioInstance;
  late Future<User> userData;
  bool loading = true;
  File? profilePicture;
  ImageSource? source;

  @override
  void initState() {
    super.initState();
    userData = getUserData();
  }

  Future<User> getUserData() async {
    setState(() {
      loading = true;
    });
    try {
      userData = AppController.fetchUserData(context);
      return userData;
    } catch (error) {
      throw "Failed";
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  String getAddress(Address address) {
    List list = [address.street, address.street, address.city, address.zipcode];
    return list.join(", ");
  }

  getPic() async {
    Navigator.pop(context);
    if (source != null) {
      File? pic = await AppUtils.pickImage(source ?? ImageSource.gallery);

      setState(() {
        profilePicture = pic;
      });
    }
  }

  showPickerOptions(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: AppColors.bgDark,
          title: const Text('Select Image'),
          content: SizedBox(
            height: 120,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    source = ImageSource.gallery;
                    getPic();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () {
                    source = ImageSource.camera;
                    getPic();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Home',
        onPressed: getUserData,
      ).appBar(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: AppColors.bgDark,
        child: loading
            ? const AppLoading()
            : FutureBuilder<User>(
                future: userData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const AppLoading();
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text('No Data, try refreshing !'));
                  } else {
                    final user = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Stack(
                                children: [
                                  // AVATAR
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      image: profilePicture != null
                                          ? DecorationImage(
                                              image: FileImage(
                                                  profilePicture as File),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(60.0)),
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 60, 60, 60),
                                        width: 4.0,
                                      ),
                                    ),
                                  ),

                                  // EDIT BUTTON
                                  Positioned(
                                    bottom: 20,
                                    right: 0,
                                    child: InkWell(
                                      onTap: () async {
                                        showPickerOptions(context);
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          // image: const DecorationImage(
                                          //   image: NetworkImage(
                                          //       user.),
                                          //   fit: BoxFit.cover,
                                          // ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(60.0)),
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 60, 60, 60),
                                            width: 4.0,
                                          ),
                                          color: Colors.black,
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.edit,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    transform:
                                        Matrix4.translationValues(-50, 25, 0),
                                    child: Text(
                                      user.name.split(' ')[0],
                                      style: nameStyle(
                                          color: const Color.fromARGB(
                                              255, 102, 102, 102)),
                                    ),
                                  ),
                                  Text(
                                    user.name.split(' ')[1],
                                    style: nameStyle(),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ProfileItem(
                                        title: "Username",
                                        value: "@ ${user.username}"),
                                    ProfileItem(
                                        title: "Email", value: user.email),
                                    ProfileItem(
                                        title: "Phone", value: user.phone),
                                    ProfileItem(
                                        title: "Website", value: user.website),
                                    ProfileItem(
                                        title: "Company",
                                        value:
                                            "${user.company.name}, ${user.company.catchPhrase}."),
                                    ProfileItem(
                                        title: "Address",
                                        value: getAddress(user.address)),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                },
              ),
      ),
    );
  }

  TextStyle nameStyle({
    Color color = const Color.fromARGB(255, 221, 221, 221),
  }) {
    return TextStyle(
      color: color,
      fontSize: 34,
      fontWeight: FontWeight.bold,
    );
  }
}
