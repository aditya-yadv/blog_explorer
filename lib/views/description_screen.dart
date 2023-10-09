import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/blog_model.dart';
import '../providers/blog_provider.dart';

class DescriptionScreen extends StatefulWidget {
  final Blog blog;
  DescriptionScreen({super.key, required this.blog});

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: Text(widget.blog.title),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Stack(children: [
            Container(
              width: double.infinity,
              height: 200,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: widget.blog.imageUrl,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: CircularProgressIndicator(
                      value: downloadProgress.progress),
                ),
                errorWidget: (context, url, error) =>
                    Center(child: Icon(Icons.error)),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: InkWell(
                onTap: () {
                  setState(() {
                    context.read<BlogProvider>().toggleFavorite(widget.blog.id);
                  });
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  // radius: 20,
                  child: Icon(
                    Icons.favorite,
                    color: widget.blog.isFavorite
                        ? Colors.red
                        : Colors.grey.shade300,
                  ),
                ),
              ),
            ),
          ]),
          Expanded(
              child: Center(
            child: Text(
              'Blog Description',
              style: TextStyle(color: Colors.white, fontSize: 32),
            ),
          ))
        ],
      ),
    );
  }
}
