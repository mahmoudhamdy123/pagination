

import 'package:pagination/models/post/post_model.dart';

abstract class PostStates{}


class PostInitialState extends PostStates{}



class GetPostsState extends PostStates{}

class PostsLoadedState extends PostStates{
  final List<PostModel> posts;
  PostsLoadedState(this.posts);
}


class PostsLoadingState extends PostStates{
  final List<PostModel> oldPosts;
  final bool isFirstFetch;
  PostsLoadingState(this.oldPosts,{this.isFirstFetch = false});
}

class ErrorPostsState extends PostStates{}