import 'package:file_picker/file_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../exceptions/app_exception.dart';
import '../models/explore_models.dart';
import '../models/requests/community_post_request.dart';
import '../models/requests/reel_request.dart';
import '../models/responses/post_category_list_response.dart';
import '../repositories/explore_repository.dart';
import '../services/locator.dart';
import '../services/media_service.dart';
import '../utils/enums.dart';
import 'base_view_model.dart';

final exploreViewModelProvider =
    NotifierProvider.autoDispose<ExploreViewModel, ExploreState>(
      () => ExploreViewModel._(),
    );

class ExploreViewModel extends BaseViewModel<ExploreState> {
  ExploreViewModel._();

  final ExploreRepository _repository = locator<ExploreRepository>();
  final ImagePicker _picker = ImagePicker();
  final MediaService _mediaService = MediaService();

  @override
  ExploreState build() {
    init();
    ref.onDispose(dispose);
    return const ExploreState();
  }

  Future<void> fetchReels({int page = 1, bool showLoading = true}) async {
    return await runSafely(showLoading: false, () async {
      state = state.copyWith(loading: showLoading);

      final response = await _repository.fetchReels(
        page: page,
        limit: state.pageSize,
      );

      state = state.copyWith(
        loading: false,
        reels: response.data ?? [],
        reelsTotalPages: response.totalPages,
        reelsCurrentPage: response.page,
      );
    });
  }

  Future<void> fetchPosts({int page = 1, bool showLoading = true}) async {
    return await runSafely(showLoading: false, () async {
      state = state.copyWith(loading: showLoading);

      final response = await _repository.fetchPosts(
        page: page,
        limit: state.pageSize,
      );

      state = state.copyWith(
        loading: false,
        posts: response.data ?? [],
        postsTotalPages: response.totalPages,
        postsCurrentPage: response.page,
      );
    });
  }

  Future<void> pickAndUploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    return await runSafely(showLoading: true, () async {
      final String? url = await _mediaService.uploadImage(
        'explore/posts/',
        image,
      );

      if (url == null) {
        throw const UnknownException(message: 'Failed to upload image');
      }

      state = state.copyWith(pickedImageUrl: url);
    });
  }

  Future<void> pickAndUploadThumbnail() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    return await runSafely(showLoading: true, () async {
      final String? url = await _mediaService.uploadImage(
        'explore/reels/thumbnails/',
        image,
      );

      if (url == null) {
        throw const UnknownException(message: 'Failed to upload thumbnail');
      }

      state = state.copyWith(pickedThumbnailUrl: url);
    });
  }

  Future<void> pickAndUploadVideo() async {
    final PlatformFile? file = await FilePicker.pickFile(
      type: FileType.video,
    );

    if (file == null) return;

    return await runSafely(showLoading: true, () async {
      final String? url = await _mediaService.uploadMedia(
        path: 'explore/reels/',
        file: file,
      );

      if (url == null) {
        throw const UnknownException(message: 'Failed to upload video');
      }

      state = state.copyWith(pickedVideoUrl: url);
    });
  }

  void clearPickedImageOnly() {
    state = state.copyWith(clearPickedImage: true);
  }

  void clearPickedVideoOnly() {
    state = state.copyWith(clearPickedVideo: true);
  }

  void clearPickedThumbnailOnly() {
    state = state.copyWith(clearPickedThumbnail: true);
  }

  void clearPickedFiles() {
    state = state.clearFiles();
  }

  Future<bool> createReel(CreateReelRequest reel) async {
    return await runSafely(showLoading: true, () async {
          final response = await _repository.createReel(reel);
          if (response.success) {
            EasyLoading.showSuccess('Reel created successfully');
            clearPickedFiles();
            await fetchReels();
          }
          return true;
        }) ??
        false;
  }

  Future<bool> createPost(CreateCommunityPostRequest post) async {
    return await runSafely(() async {
          final response = await _repository.createPost(post);
          if (response.success) {
            EasyLoading.showSuccess('Post created successfully');
            clearPickedFiles();
            await fetchPosts();
          }
          return true;
        }) ??
        false;
  }

  Future<void> toggleReelVisibility(int id, String currentStatus) async {
    final current = currentStatus.toLowerCase();

    final newStatus = current == Status.active.name
        ? Status.inactive.name
        : Status.active.name;

    return await runSafely(() async {
      final response = await _repository.updateReelStatus(id, newStatus);
      if (response.success) {
        await EasyLoading.showSuccess('Reel status updated to $newStatus');
        await fetchReels(page: state.reelsCurrentPage, showLoading: false);
      }
    });
  }

  Future<void> togglePostVisibility(int id, String currentStatus) async {
    final current = currentStatus.toLowerCase();

    final newStatus = current == Status.active.name
        ? Status.inactive.name
        : Status.active.name;

    return await runSafely(() async {
      final response = await _repository.updatePostStatus(id, newStatus);
      if (response.success) {
        await EasyLoading.showSuccess('Post status updated to $newStatus');
        await fetchPosts(page: state.postsCurrentPage, showLoading: false);
      }
    });
  }

  Future<void> deleteReel(int id) async {
    return await runSafely(() async {
      final response = await _repository.deleteReel(id);
      if (response.success) {
        await EasyLoading.showSuccess('Reel deleted successfully');
        await fetchReels(page: state.reelsCurrentPage, showLoading: false);
      }
    });
  }

  Future<void> deletePost(int id) async {
    return await runSafely(() async {
      final response = await _repository.deletePost(id);
      if (response.success) {
        await EasyLoading.showSuccess('Post deleted successfully');

        await fetchPosts(page: state.postsCurrentPage, showLoading: false);
      }
    });
  }

  Future<void> fetchPostCategories() async {
    return await runSafely(() async {
      final categories = await _repository.fetchPostCategories();

      state = state.copyWith(postCategories: categories);
    });
  }

  Future<void> createPostCategory(String name) async {
    return await runSafely(showLoading: true, () async {
      final response = await _repository.createPostCategory(name);
      if (response.success) {
        EasyLoading.showSuccess('Category created successfully');

        await fetchPostCategories();
      }
    });
  }

  @override
  void onError(String message) {
    super.onError(message);
    state.copyWith(loading: false);
    EasyLoading.dismiss();
  }
}

class ExploreState {
  final List<ReelModel> reels;
  final List<CommunityPostModel> posts;
  final int reelsTotalPages;
  final int postsTotalPages;
  final int reelsCurrentPage;
  final int postsCurrentPage;
  final int pageSize;
  final String? pickedImageUrl;
  final String? pickedVideoUrl;
  final String? pickedThumbnailUrl;
  final List<PostCategoryModel> postCategories;
  final bool loading;

  const ExploreState({
    this.loading = false,
    this.reels = const [],
    this.posts = const [],
    this.reelsTotalPages = 1,
    this.postsTotalPages = 1,
    this.reelsCurrentPage = 1,
    this.postsCurrentPage = 1,
    this.pageSize = 20,
    this.pickedImageUrl,
    this.pickedVideoUrl,
    this.pickedThumbnailUrl,
    this.postCategories = const [],
  });

  ExploreState copyWith({
    bool? loading,
    List<ReelModel>? reels,
    List<CommunityPostModel>? posts,
    int? reelsTotalPages,
    int? postsTotalPages,
    int? reelsCurrentPage,
    int? postsCurrentPage,
    int? pageSize,
    String? pickedImageUrl,
    String? pickedVideoUrl,
    String? pickedThumbnailUrl,
    bool clearPickedImage = false,
    bool clearPickedVideo = false,
    bool clearPickedThumbnail = false,
    List<PostCategoryModel>? postCategories,
  }) {
    return ExploreState(
      loading: loading ?? this.loading,
      reels: reels ?? this.reels,
      posts: posts ?? this.posts,
      reelsTotalPages: reelsTotalPages ?? this.reelsTotalPages,
      postsTotalPages: postsTotalPages ?? this.postsTotalPages,
      reelsCurrentPage: reelsCurrentPage ?? this.reelsCurrentPage,
      postsCurrentPage: postsCurrentPage ?? this.postsCurrentPage,
      pageSize: pageSize ?? this.pageSize,
      pickedImageUrl: clearPickedImage
          ? null
          : (pickedImageUrl ?? this.pickedImageUrl),
      pickedVideoUrl: clearPickedVideo
          ? null
          : (pickedVideoUrl ?? this.pickedVideoUrl),
      pickedThumbnailUrl: clearPickedThumbnail
          ? null
          : (pickedThumbnailUrl ?? this.pickedThumbnailUrl),
      postCategories: postCategories ?? this.postCategories,
    );
  }

  ExploreState clearFiles() {
    return ExploreState(
      loading: loading,
      reels: reels,
      posts: posts,
      reelsTotalPages: reelsTotalPages,
      postsTotalPages: postsTotalPages,
      reelsCurrentPage: reelsCurrentPage,
      postsCurrentPage: postsCurrentPage,
      pageSize: pageSize,
      pickedImageUrl: null,
      pickedVideoUrl: null,
      pickedThumbnailUrl: null,
      postCategories: postCategories,
    );
  }
}
