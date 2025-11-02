import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/helpers/user.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/blogs/controllers/blog_controller.dart';
import 'package:gps_app/features/blogs/models/blog_model/blog_model.dart';
import 'package:gps_app/features/blogs/models/blog_model/comment_model.dart';

class BlogsCubit extends Cubit<ApiResponseModel<List<BlogModel>>> {
  BlogsCubit() : super(ApiResponseModel());
  final BlogController controller = serviceLocator<BlogController>();
  Future blogs() async {
    final t = prt('blogs - BlogsCubit');
    emit(state.copyWith(errorMessage: null, response: ResponseEnum.loading));
    final ApiResponseModel<List<BlogModel>> response = await controller.blogs();
    pr(response, t);
    emit(response);
  }

  Future likeBlog({required BlogModel blog}) async {
    if (blog.id == null) return;
    blog.likesCount = (blog.likesCount ?? 0) + 1;
    emit(state.copyWith());
    final ApiResponseModel<bool> response = await controller.likeBlog(blogId: blog.id!);
    blogs();
  }

  Future addComment({required BlogModel blog, required String content}) async {
    if (blog.id == null) return;
    final newComment = CommentModel(
      comment: content,
      createdAt: DateTime.now(),
      type: 'comment',
      user: userInMemory(),
      userId: userInMemory()?.id,
      blogId: blog.id,
    );
    blog.comments ??= [];
    blog.comments!.add(newComment);
    blog.commentsCount = (blog.commentsCount ?? 0) + 1;
    emit(state.copyWith());
    final ApiResponseModel<bool> response = await controller.addComment(
      blogId: blog.id!,
      content: content,
    );
    blogs();
  }

  Future updateComment({required CommentModel comment, required String content}) async {
    if (comment.blogId == null) return;
    comment.comment = content;
    emit(state.copyWith());
    final ApiResponseModel<bool> response = await controller.updateComment(
      commentId: comment.id!,
      content: content,
    );
    blogs();
  }
}
