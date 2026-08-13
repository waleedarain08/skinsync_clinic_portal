import '../models/requests/community_post_request.dart';
import '../models/requests/name_request.dart';
import '../models/requests/reel_request.dart';
import '../models/requests/status_request.dart';
import '../models/responses/community_posts_list_response.dart';
import '../models/responses/post_category_list_response.dart';
import '../models/responses/reels_list_response.dart';
import '../repositories/explore_repository.dart';
import '../utils/enums.dart';
import 'api_base_helper.dart';
import 'locator.dart';

class ExploreService implements ExploreRepository {
  @override
  Future<ReelsListResponse> fetchReels({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.explorerReels,
      requestType: RequestType.get,
      queryParams: {
        'page': page.toString(),
        'limit': limit.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );

    final model = ReelsListResponse.fromJson(response);

    if (!model.success) {
      throw Exception(model.message);
    }

    return model;
  }

  @override
  Future<void> createReel(CreateReelRequest reel) async {
     await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.explorerReels,
      requestType: RequestType.post,
      requestBody: reel,
    );

    // If your create response doesn't need parsing,
    // nothing else is required here.
  }

  @override
  Future<void> updateReelStatus(int id, String status) async {
    await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.updateReel,
      requestType: RequestType.patch,
      pathParams: {
        'id': id.toString(),
      },
      requestBody: StatusRequest(
        status: status,
      ),
    );
  }

  @override
  Future<void> deleteReel(int id) async {
    await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.deleteReel,
      requestType: RequestType.delete,
      pathParams: {
        'id': id.toString(),
      },
    );
  }

  @override
  Future<CommunityPostsListResponse> fetchPosts({
    int page = 1,
    int limit = 20,
    String? search,
    String? category,
  }) async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.explorerCommunity,
      requestType: RequestType.get,
      queryParams: {
        'page': page.toString(),
        'limit': limit.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
        if (category != null && category.isNotEmpty)
          'category': category,
      },
    );

    final model = CommunityPostsListResponse.fromJson(response);

    if (!model.success) {
      throw Exception(model.message);
    }

    return model;
  }

  @override
  Future<void> createPost(
    CreateCommunityPostRequest post,
  ) async {
    await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.explorerCommunity,
      requestType: RequestType.post,
      requestBody: post,
    );
  }

  @override
  Future<void> updatePostStatus(
    int id,
    String status,
  ) async {
    await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.updatePost,
      requestType: RequestType.patch,
      pathParams: {
        'id': id.toString(),
      },
      requestBody: StatusRequest(
        status: status,
      ),
    );
  }

  @override
  Future<void> deletePost(int id) async {
    await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.deletePost,
      requestType: RequestType.delete,
      pathParams: {
        'id': id.toString(),
      },
    );
  }

  @override
  Future<List<PostCategoryModel>> fetchPostCategories() async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.postCategories,
      requestType: RequestType.get,
    );

    final model = PostCategoryListResponse.fromJson(response);

    if (!model.success) {
      throw Exception(model.message);
    }

    return model.data ?? [];
  }

  @override
  Future<void> createPostCategory(String name) async {
    await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.postCategories,
      requestType: RequestType.post,
      requestBody: NameRequest(
        name: name,
      ),
    );
  }
}