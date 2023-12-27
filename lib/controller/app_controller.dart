// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:casa/common/utils.dart';
import 'package:casa/dio_instance.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/album.dart';
import '../models/comment.dart';
import '../models/photo.dart';
import '../models/post.dart';
import '../models/user.dart';

class AppController {
  static Dio apiFactory = ApiFactory().dioInstance;
  static const currentUserId = 1;

  static showErrorSnack(BuildContext context,
      {String message = "Oops, Something went wrong"}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red.shade300,
      ),
    );
  }

/* -------------------------------------------------------------------------- */
/*                                    USERS                                   */
/* -------------------------------------------------------------------------- */
  static Future<User> fetchUserData(BuildContext context) async {
    try {
      final response = await apiFactory.get('/users/$currentUserId');
      final userData = User.fromJson(response.data);

      // CACHING
      await StoreController.saveData(
          StoreController.USER, jsonEncode(userData.toJson()));

      return userData;
    } catch (error) {
      // RETRIEVEING CACHE
      User? cachedData = await getStoredUserData(context);
      if (cachedData != null) {
        return cachedData;
      } else {
        showErrorSnack(context);
        throw "Failed to get user data";
      }
    }
  }

  static Future<User?> getStoredUserData(BuildContext context) async {
    try {
      final userDataJson = await StoreController.getData(StoreController.USER);
      return userDataJson != null
          ? User.fromJson(jsonDecode(userDataJson as String))
          : null;
    } catch (e) {
      showErrorSnack(context, message: "Failed to get Cached User Data");
      throw "Cache Retireval Failed";
    }
  }

/* -------------------------------------------------------------------------- */
/*                                   ALBUMS                                   */
/* -------------------------------------------------------------------------- */
  static Future<List<Album>> fetchAlbums(BuildContext context) async {
    try {
      final response = await apiFactory.get('/users/$currentUserId/albums');
      final List<Map<String, dynamic>> albumListJson =
          List<Map<String, dynamic>>.from(response.data);
      List<Album> albumList =
          albumListJson.map((albumJson) => Album.fromJson(albumJson)).toList();

      // CACHING
      await saveAlbums(albumList);

      return albumList;
    } catch (error) {
      // RETRIEVEING CACHE
      List<Album>? cachedAlbums = await getStoredAlbums(context);

      if (cachedAlbums != null) {
        return cachedAlbums;
      } else {
        showErrorSnack(context);
        throw Exception("Failed to fetch albums");
      }
    }
  }

  // Save albums to cache
  static saveAlbums(List<Album> albums) async {
    await StoreController.saveData(StoreController.ALBUMS,
        jsonEncode(albums.map((album) => album.toJson()).toList()));
  }

  // Retrieve albums from cache
  static Future<List<Album>?> getStoredAlbums(BuildContext context) async {
    try {
      final albumListJson =
          await StoreController.getData(StoreController.ALBUMS);

      return albumListJson != null
          ? List<Album>.from(jsonDecode(albumListJson as String)
              .map((json) => Album.fromJson(json)))
          : null;
    } catch (e) {
      showErrorSnack(context, message: "Failed to get Cached Album Data");
      throw Exception("Cache Retrieval Failed");
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                                   PHOTOS                                   */
  /* -------------------------------------------------------------------------- */
  static Future<List<Photo>> fetchPhotos(
      BuildContext context, int albumId) async {
    try {
      final response = await apiFactory.get('/albums/$albumId/photos');
      final List<Map<String, dynamic>> photoListJson =
          List<Map<String, dynamic>>.from(response.data);
      List<Photo> photoList =
          photoListJson.map((photoJson) => Photo.fromJson(photoJson)).toList();

      // CACHING
      await savePhotos(albumId, photoList);

      return photoList;
    } catch (error) {
      // RETRIEVEING CACHE
      List<Photo>? cachedPhotos = await getStoredPhotos(context, albumId);

      if (cachedPhotos != null) {
        return cachedPhotos;
      } else {
        showErrorSnack(context);
        throw Exception("Failed to fetch photos");
      }
    }
  }

  static savePhotos(int albumId, List<Photo> photos) async {
    await StoreController.saveData(
        StoreController.getPhotosPath(albumId: albumId),
        jsonEncode(photos.map((photo) => photo.toJson()).toList()));
  }

  static Future<List<Photo>?> getStoredPhotos(
      BuildContext context, int albumId) async {
    try {
      final photoListJson = await StoreController.getData(
          StoreController.getPhotosPath(albumId: albumId));

      return photoListJson != null
          ? List<Photo>.from(jsonDecode(photoListJson as String)
              .map((json) => Photo.fromJson(json)))
          : null;
    } catch (e) {
      showErrorSnack(context, message: "Failed to get Cached Photo Data");
      throw Exception("Cache Retrieval Failed");
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                                    POSTS                                   */
  /* -------------------------------------------------------------------------- */
  static Future<List<Post>> fetchUserPosts(BuildContext context) async {
    try {
      // Attempt to fetch posts from the API
      final response = await apiFactory.get('/users/$currentUserId/posts');
      final List<Map<String, dynamic>> postListJson =
          List<Map<String, dynamic>>.from(response.data);

      // CACHING
      List<Post> postList =
          postListJson.map((postJson) => Post.fromJson(postJson)).toList();

      await StoreController.saveData(StoreController.POSTS,
          jsonEncode(postList.map((post) => post.toJson()).toList()));

      return postList;
    } catch (error) {
      // RETRIEVEING CACHE
      List<Post>? cachedData = await getStoredUserPosts(context);
      if (cachedData != null) {
        return cachedData;
      } else {
        showErrorSnack(context);
        throw Exception("Failed to fetch user posts");
      }
    }
  }

  // Retrieve cached posts data
  static Future<List<Post>?> getStoredUserPosts(BuildContext context) async {
    try {
      final postsDataJson =
          await StoreController.getData(StoreController.POSTS);
      return postsDataJson != null
          ? (jsonDecode(postsDataJson as String) as List)
              .map((postJson) => Post.fromJson(postJson))
              .toList()
          : null;
    } catch (e) {
      showErrorSnack(context, message: "Failed to get Cached User Posts");
      throw Exception("Cache Retrieval Failed");
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                                  COMMENTS                                  */
  /* -------------------------------------------------------------------------- */
  static Future<List<Comment>> fetchCommentsForPost(
      BuildContext context, int postId) async {
    try {
      // Attempt to fetch comments from the API
      final response = await apiFactory.get('/posts/$postId/comments');
      final List<Map<String, dynamic>> commentsJson =
          List<Map<String, dynamic>>.from(response.data);

      // Convert JSON data to a list of Comment objects
      List<Comment> comments = commentsJson
          .map((commentJson) => Comment.fromJson(commentJson))
          .toList();

      // CACHING
      await saveComments(postId, comments);

      return comments;
    } catch (error) {
      // Attempt to retrieve cached comments data
      List<Comment>? cachedComments = await getStoredComments(context, postId);

      if (cachedComments != null) {
        return cachedComments;
      } else {
        // If no cached data is available, show an error snack
        showErrorSnack(context);
        throw Exception("Failed to fetch comments");
      }
    }
  }

  static saveComments(int postId, List<Comment> comments) async {
    await StoreController.saveData(
        StoreController.getCommentsPath(postId: postId),
        jsonEncode(comments.map((comment) => comment.toJson()).toList()));
  }

  static Future<List<Comment>?> getStoredComments(
      BuildContext context, int postId) async {
    try {
      // Retrieve cached comments data
      final commentsDataJson = await StoreController.getData(
          StoreController.getCommentsPath(postId: postId));

      return commentsDataJson != null
          ? List<Comment>.from(jsonDecode(commentsDataJson as String)
              .map((json) => Comment.fromJson(json)))
          : null;
    } catch (e) {
      // Handle cache retrieval errors
      showErrorSnack(context, message: "Failed to get Cached Comment Data");
      throw Exception("Cache Retrieval Failed");
    }
  }
}
