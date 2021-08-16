import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination/models/post/post_model.dart';

import 'package:pagination/modules/mainPage/cubit/states.dart';
import 'package:pagination/shared/network/dio_helper.dart';
import 'package:pagination/shared/repository/posts_repository.dart';

class PostCubit extends Cubit<PostStates> {
  PostCubit() : super(PostInitialState());

  static PostCubit get(context) => BlocProvider.of(context);

  late List<PostModel> _posts;
  int page = 1;
  late final PostsRepository repository = PostsRepository();


  List<PostModel> get category => _posts;



  void loadPosts(){
    if(state is PostsLoadingState) return;

    final currentState = state;
    List<PostModel> oldPosts = [];

    if(currentState is PostsLoadedState){
      oldPosts = currentState.posts;
    }
    emit(PostsLoadingState(oldPosts,isFirstFetch: page==1));
    try{
      repository.fetchPosts(page).then((newPosts){
        page++;
        final posts = (state as PostsLoadingState).oldPosts;
        posts.addAll(newPosts);
        emit(PostsLoadedState(posts));
      });
    }catch(error){
      print(error);
    }
  }


  Future<void> getPosts(int fetchLimit,[int page = 1]) async {
    try {
      emit(GetPostsState());
      _posts = [];
      var response = await DioHelper.getData(url: "posts?_limit=$fetchLimit");
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        var data = response.data;
        _posts = List<PostModel>.from(
            data.map((x) => PostModel.fromJson(x)));
        emit(PostsLoadedState(_posts));
      } else {
        emit(ErrorPostsState());
      }
    } catch (error) {
      print(error);
      emit(ErrorPostsState());
    }
  }


}
