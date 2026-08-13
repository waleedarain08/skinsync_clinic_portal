import '../models/requests/community_post_request.dart';
import '../models/requests/reel_request.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/community_posts_list_response.dart';
import '../models/responses/post_category_list_response.dart';
import '../models/responses/reels_list_response.dart';

abstract class ExploreRepository {
  Future<ReelsListResponse> fetchReels({
    int page = 1,
    int limit = 20,
    String? search,
  });
  Future<BaseResponse> createReel(CreateReelRequest reel);
  Future<BaseResponse> updateReelStatus(int id, String status);
  Future<BaseResponse> deleteReel(int id);
  Future<CommunityPostsListResponse> fetchPosts({
    int page = 1,
    int limit = 20,
    String? search,
    String? category,
  });
  Future<BaseResponse> createPost(CreateCommunityPostRequest post);
  Future<BaseResponse> updatePostStatus(int id, String status);
  Future<BaseResponse> deletePost(int id);
  Future<List<PostCategoryModel>> fetchPostCategories();
  Future<BaseResponse> createPostCategory(String name);
}
