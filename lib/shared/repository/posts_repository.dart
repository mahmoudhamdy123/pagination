import 'package:pagination/models/post/post_model.dart';
import 'package:pagination/shared/network/dio_helper.dart';


class PostsRepository {
  static const FETCH_LIMIT = 15;

  static init() {

  }

  Future<List<PostModel>> fetchPosts(int page) async {
    final response =
        await DioHelper.getData(url: "posts?_limit=$FETCH_LIMIT&_page=$page");
    var data = response.data;
    List<PostModel> posts = List<PostModel>.from(
        data.map((x) => PostModel.fromJson(x)));
    return posts;
  }

}
