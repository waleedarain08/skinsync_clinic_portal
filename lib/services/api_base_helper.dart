import 'dart:convert';
import 'dart:developer';
import 'dart:io' as io;

import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

import '../app_init.dart';
import '../exceptions/app_exception.dart';
import '../models/requests/base_request.dart';
import '../models/requests/multi_part_model.dart';
import '../models/responses/refresh_token_response.dart';
import '../screens/sign_in_screen.dart';
import '../utils/enums.dart';
import '../utils/http_utils.dart';
import '../utils/string_utils.dart';
import 'locator.dart';
import 'storage_service.dart';

class ApiBaseService {
  final _secureStorage = locator<SecureStorageService>();
  final String _baseUrl = BaseUrls.api.url;
  String? authToken;

  Future<Map<String, dynamic>> httpRequest({
    required Endpoint endPoint,
    required RequestType requestType,
    BaseRequest? requestBody,
    Map<String, String?>? queryParams,
    Map<String, String>? pathParams,
    List<MultiPartImageModel>? imagePath,
  }) async {
    try {
      await _refreshToken();
      final params = queryParams?.entries
          .map((entry) {
            return '${entry.key}=${entry.value}';
          })
          .join('&')
          .addStringToStart('?');
      // final String? params = queryParams?.entries
      //     .map(((entry) {
      //       if (entry.value == null) {
      //         return null;
      //       }
      //       return '${entry.key}=${entry.value}';
      //     }))
      //     .nonNulls
      //     .join('&')
      //     .addStringToStart('?');
      // final path = pathParams != null ? '/${pathParams.join('/')}' : '';
      final uri = Uri.parse(
        '$_baseUrl${endPoint.withParams(pathParams ?? {})}${params ?? ''}',
      );
      late http.Response response;
      final headers = await getHeaders(endPoint, requestType);
      final body = requestBody != null
          ? jsonEncode(requestBody.toJson())
          : null;
      log('URL: $uri');
      if (requestType != RequestType.multipartPost &&
          requestType != RequestType.multipartPatch) {
        log('BODY: $body');
      }
      switch (requestType) {
        case RequestType.get:
          response = await http.get(uri, headers: headers);
          break;
        case RequestType.post:
          response = await http.post(uri, headers: headers, body: body);
          break;
        case RequestType.put:
          response = await http.put(uri, headers: headers, body: body);
          break;
        case RequestType.patch:
          response = await http.patch(uri, headers: headers, body: body);
          break;
        case RequestType.delete:
          response = await http.delete(uri, headers: headers, body: body);
          break;
        case RequestType.multipartPost:
          response = await _sendMultipart(
            uri,
            requestBody,
            imagePath,
            requestType,
            headers,
          );
        case RequestType.multipartPatch:
          response = await _sendMultipart(
            uri,
            requestBody,
            imagePath,
            requestType,
            headers,
          );
      }
      log('RESPONSE: ${response.body}');
      final Map<String, dynamic> json = jsonDecode(response.body);

      return json;
    } on UnauthorizedException {
      await locator<SecureStorageService>().clearToken();
      GoRouter.of(navigatorKey.currentContext!).go(SignInScreen.routeName);
      rethrow;
    } on io.SocketException catch (e, s) {
      log(e.toString(), stackTrace: s);
      throw NetworkException(originalError: e);
    } on io.HttpException catch (e, s) {
      log(e.toString(), stackTrace: s);
      throw NetworkException(
        message: 'Network error occurred. Please try again.',
        originalError: e,
      );
    } on FormatException catch (e, s) {
      log(e.toString(), stackTrace: s);
      throw FormatException(originalError: e);
    } on TimeoutException catch (e, s) {
      log(e.toString(), stackTrace: s);
      throw TimeoutException(originalError: e);
    } on AppException catch (e, s) {
      log(e.toString(), stackTrace: s);
      rethrow;
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      throw UnknownException(
        message: 'An unexpected error occurred: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Future<http.Response> _sendMultipart(
    Uri uri,
    BaseRequest? requestBody,
    List<MultiPartImageModel>? imagePath,
    RequestType requestType,
    Map<String, String> headers,
  ) async {
    final request = http.MultipartRequest(requestType.method, uri);
    request.headers.addAll(headers);

    if (requestBody != null) {
      final Map<String, dynamic> json = requestBody.toJson().cast();
      for (final entry in json.entries) {
        if (entry.value != null) {
          request.fields[entry.key] = entry.value!.toString();
        }
      }
    }
    log('MULTIPART BODY: ${jsonEncode(request.fields)}');

    if (imagePath != null) {
      for (var multiPartData in imagePath) {
        if (multiPartData.path != "") {
          final String? mimeType = lookupMimeType(multiPartData.path);
          log('MIME: $mimeType');
          final http.MultipartFile file = await http.MultipartFile.fromPath(
            multiPartData.name,
            multiPartData.path,
            contentType: mimeType != null
                ? http.MediaType.parse(mimeType)
                : null,
          );
          request.files.add(file);
        }
      }
    }

    final response = await request.send();
    return http.Response.fromStream(response);
  }

  Future<Map<String, String>> getHeaders(
    Endpoint endpoint,
    RequestType requestType,
  ) async {
    // final authToken = _secureStorage.token;
    final authToken = endpoint == Endpoint.refreshToken
        ? await _secureStorage.getRefreshToken()
        : _secureStorage.token;
    log('ACCESS TOKEN: $authToken');
    final data = {
      'Content-Type':
          requestType == RequestType.multipartPost ||
              requestType == RequestType.multipartPatch
          ? 'multipart/form-data'
          : 'application/json',
      'Accept': 'application/json',
    };
    if (authToken != null) {
      data['Authorization'] = 'Bearer $authToken';
    }
    log('HEADERS: $data');
    return data;
  }

  Future<void> _refreshToken() async {
    if (_secureStorage.token == null) {
      return;
    }
    final expiry = await _secureStorage.getAccessTokenExpiry();
    final now = DateTime.now();
    if (expiry?.isAfter(now) ?? false) {
      return;
    }
    final refreshExpiry = await _secureStorage.getRefreshTokenExpiry();
    if (refreshExpiry?.isBefore(now) ?? true) {
      throw const UnauthorizedException(message: 'Unauthorized');
    }
    final refreshToken = await _secureStorage.getRefreshToken();
    if (refreshToken == null) {
      throw const UnauthorizedException(message: 'Unauthorized');
    }
    log('EXPIRY: $expiry');
    log('REFRESH EXPIRY: $refreshExpiry');
    final uri = Uri.parse('$_baseUrl${Endpoint.refreshToken.path}');
    log('URL: $uri');
    final request = {'refresh_token': refreshToken};
    log('REQUEST: $request');
    final response = await http.post(uri, body: jsonEncode(request));
    log('RESPONSE: ${response.body}');
    final model = RefreshTokenResponse.fromJson(jsonDecode(response.body));
    if (!model.success) {
      throw const UnauthorizedException(message: 'Unauthorized');
    }
    final secureStorage = locator<SecureStorageService>();
    await secureStorage.saveToken(model.data!.accessToken);
    await secureStorage.saveRefreshToken(model.data!.refreshToken);
    await secureStorage.saveAccessTokenExpiry(
      DateTime.fromMillisecondsSinceEpoch(model.data!.accessExpiresAt * 1000),
    );
    await secureStorage.saveRefreshTokenExpiry(
      DateTime.fromMillisecondsSinceEpoch(model.data!.refreshExpiresAt * 1000),
    );
    log('TOKEN REFRESHED');
  }
}
