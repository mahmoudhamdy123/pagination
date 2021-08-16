import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination/models/post/post_model.dart';
import 'package:pagination/modules/mainPage/cubit/cubit.dart';
import 'package:pagination/modules/mainPage/cubit/states.dart';

class MainPageScreen extends StatelessWidget {
  MainPageScreen({Key? key}) : super(key: key);

  final scrollController = ScrollController();

  void setupScrollController(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          PostCubit.get(context).loadPosts();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pagination"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: BlocProvider(
        create: (context) => PostCubit()..loadPosts(),
        child: BlocConsumer<PostCubit, PostStates>(
          listener: (context, state) {},
          builder: (context, state) {
            setupScrollController(context);
            if (state is PostsLoadingState && state.isFirstFetch) {
              return Center(child: CircularProgressIndicator());
            }
            List<PostModel> posts = [];
            bool isLoading = false;
            if (state is PostsLoadingState) {
              posts = state.oldPosts;
              isLoading = true;
            } else if (state is PostsLoadedState) {
              posts = state.posts;
            }
            return ListView.builder(
                controller: scrollController,
                itemCount: posts.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < posts.length)
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "$index - ",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                  textAlign: TextAlign.center,
                                ),
                                Expanded(
                                  child: Text(
                                    posts[index].title,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Text(posts[index].body,
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    );
                  else {
                    Timer(Duration(milliseconds: 30), () {
                      scrollController
                          .jumpTo(scrollController.position.maxScrollExtent);
                    });
                    return Center(child: CircularProgressIndicator());
                  }
                });
          },
        ),
      ),
    );
  }
}
