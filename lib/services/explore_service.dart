import '../models/requests/community_post_request.dart';
import '../models/requests/name_request.dart';
import '../models/requests/reel_request.dart';
import '../models/requests/status_request.dart';
import '../models/responses/base_response_model.dart';
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

    return model;
  }

  @override
  Future<BaseResponse> createReel(CreateReelRequest reel) async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.explorerReels,
      requestType: RequestType.post,
      requestBody: reel,
    );
    final model = BaseResponse.fromJson(response, (json) => json);

    return model;
  }

  @override
  Future<BaseResponse> updateReelStatus(int id, String status) async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.updateReel,
      requestType: RequestType.patch,
      pathParams: {'id': id.toString()},
      requestBody: StatusRequest(status: status),
    );
    final model = BaseResponse.fromJson(response, (json) => json);

    return model;
  }

  @override
  Future<BaseResponse> deleteReel(int id) async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.updateReel,
      requestType: RequestType.delete,
      pathParams: {'id': id.toString()},
    );
    final model = BaseResponse.fromJson(response, (json) => json);

    return model;
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
        if (category != null && category.isNotEmpty) 'category': category,
      },
    );

    final model = CommunityPostsListResponse.fromJson(response);

    return model;
  }

  @override
  Future<BaseResponse> createPost(CreateCommunityPostRequest post) async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.explorerCommunity,
      requestType: RequestType.post,
      requestBody: post,
    );
    final model = BaseResponse.fromJson(response, (json) => json);

    return model;
  }

  @override
  Future<BaseResponse> updatePostStatus(int id, String status) async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.updatePost,
      requestType: RequestType.patch,
      pathParams: {'id': id.toString()},
      requestBody: StatusRequest(status: status),
    );
    final model = BaseResponse.fromJson(response, (json) => json);

    return model;
  }

  @override
  Future<BaseResponse> deletePost(int id) async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.updatePost,
      requestType: RequestType.delete,
      pathParams: {'id': id.toString()},
    );
    final model = BaseResponse.fromJson(response, (json) => json);

    return model;
  }

  @override
  Future<List<PostCategoryModel>> fetchPostCategories() async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.postCategories,
      requestType: RequestType.get,
    );

    final model = PostCategoryListResponse.fromJson(response);

    return model.data ?? [];
  }

  @override
  Future<BaseResponse> createPostCategory(String name) async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.postCategories,
      requestType: RequestType.post,
      requestBody: NameRequest(name: name),
    );
    final model = BaseResponse.fromJson(response, (json) => json);

    return model;
  }
}
