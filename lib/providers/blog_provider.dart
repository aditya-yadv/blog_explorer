import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/blog_model.dart';
import 'package:http/http.dart' as http;

class BlogProvider extends ChangeNotifier {
  // Local DB box instance
  Box<Blog> blogBox = Hive.box<Blog>('blogs');

  // list of blogs to be populated on the home screen
  List<Blog> blogs = [];

  // method to load the list of blogs from the local DB
  void fetchDB() {
    blogs = blogBox.values.toList();
    notifyListeners();
  }

  // method to fetch the blogs from the api and load the list with the blogs and upadate the list in the local DB
  Future<void> fetchBlogs() async {
    final String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
    final String adminSecret =
        '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'x-hasura-admin-secret': adminSecret,
      });

      if (response.statusCode == 200) {
        // Request successful, handle the response data here
        final jso = json.decode(response.body);
        final jsonBlogs = jso["blogs"];

        final List<Blog> fetchedBlogs = jsonBlogs.map<Blog>((json) {
          return Blog(
              id: json["id"],
              imageUrl: json["image_url"],
              title: json["title"]);
        }).toList();

        // loading the provider list
        blogs = fetchedBlogs;

        // Clear the existing data in the DB
        await blogBox.clear();

        // Save the fetched blogs to the DB
        await blogBox.addAll(blogs);
      } else {
        // Request failed
        print('Request failed with status code: ${response.statusCode}');
        print('Response data: ${response.body}');
      }
    } catch (e) {
      // Handle any errors that occurred during the request
      print('Error: $e');
      throw (e);
    }
    notifyListeners();
  }

  // Method to toggle favorite status
  void toggleFavorite(String blogId) {
    final blogIndex = blogs.indexWhere((blog) => blog.id == blogId);
    if (blogIndex != -1) {
      blogs[blogIndex].isFavorite = !blogs[blogIndex].isFavorite;
      notifyListeners();
    }
  }
}
