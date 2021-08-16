
import 'package:pagination/models/post/post_model.dart';

class PostsPagination{
  final List<PostModel> posts;
  final int page;
  final String errorMessage;

  PostsPagination(this.posts, this.page, this.errorMessage);

  bool get refreshError => errorMessage != '' && posts.length <= 20;
}
