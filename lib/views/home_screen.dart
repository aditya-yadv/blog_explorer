import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/blog_provider.dart';
import './description_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool isconnected;
  HomeScreen({super.key, required this.isconnected});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // call the method to load list depending on the internet connection from DB or API
    if (widget.isconnected) {
      context.read<BlogProvider>().fetchBlogs();
    } else {
      context.read<BlogProvider>().fetchDB();
    }
  }

  @override
  Widget build(BuildContext context) {
    final blogs = context.watch<BlogProvider>().blogs;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        // appbar will be red if the user is not connected to the internet
        backgroundColor: widget.isconnected ? Colors.grey.shade900 : Colors.red,
        title: SvgPicture.asset(
          'assets/icons/subspace_hor.svg',
          semanticsLabel: 'logo',
          width: 140,
        ),
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            width: 40,
            decoration:
                BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: blogs.length == 0
          ? Center(child: CircularProgressIndicator())
          : Container(
              margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: ListView.builder(
                itemCount: blogs.length,
                itemBuilder: ((context, index) => InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DescriptionScreen(
                              // imageUrl: blogs[index].imageUrl,
                              // title: blogs[index].title,
                              blog: blogs[index],
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(children: [
                            Container(
                              width: double.infinity,
                              height: 200,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: blogs[index].imageUrl,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
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
                                  context
                                      .read<BlogProvider>()
                                      .toggleFavorite(blogs[index].id);
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  // radius: 20,
                                  child: Icon(
                                    Icons.favorite,
                                    color: blogs[index].isFavorite
                                        ? Colors.red
                                        : Colors.grey.shade300,
                                  ),
                                ),
                              ),
                            ),
                          ]),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 25),
                            child: Text(
                              blogs[index].title,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    )),
              ),
            ),
    );
  }
}
