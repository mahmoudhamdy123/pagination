import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination/models/post/post_model.dart';
import 'package:pagination/modules/mainPage/cubit/states.dart';
import 'package:pagination/shared/repository/posts_repository.dart';

class PostCubit extends Cubit<PostStates> {
  PostCubit() : super(PostInitialState());

  static PostCubit get(context) => BlocProvider.of(context);

  int page = 1;
  late final PostsRepository repository = PostsRepository();





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




}
