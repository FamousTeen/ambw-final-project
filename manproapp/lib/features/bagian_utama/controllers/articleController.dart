import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:manpro/features/bagian_utama/models/articleModel.dart';
import 'package:manpro/utils/constants/api_constants.dart';

/// Controller for managing article-related operations
class ArticleController extends GetxController {
  // Observable states
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final articles = <Article>[].obs;
  final filteredArticles = <Article>[].obs;
  final currentArticle = Rxn<Article>();
  final hasError = false.obs;
  final errorMessage = RxString('');
  final hasConnection = true.obs;
  final hasMoreData = true.obs;
  final currentPage = 1.obs;
  final searchQuery = ''.obs;

  // Cache management
  final _articleCache = <int, Article>{};
  DateTime? _lastFetch;
  static const _cacheValidDuration = Duration(minutes: 5);
  static const _timeout = Duration(seconds: 10);
  static const _perPage = 10;

  @override
  void onInit() {
    super.onInit();
    ever(searchQuery, (_) => _performSearch());
    _initializeController();
  }

  @override
  void onClose() {
    clearCache();
    super.onClose();
  }

  Future<void> _initializeController() async {
    await fetchArticles();
  }

  /// Checks if the cache is still valid
  bool get _isCacheValid =>
      _lastFetch != null &&
      DateTime.now().difference(_lastFetch!) < _cacheValidDuration;

  /// Fetches articles with proper error handling and caching
  Future<void> fetchArticles() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      currentPage.value = 1;
      hasMoreData.value = true;

      if (_isCacheValid && articles.isNotEmpty) {
        return;
      }

      final response = await http.get(
        Uri.parse('${url}articles/list?page=1&per_page=$_perPage'),
        headers: {'Accept': 'application/json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        _validateResponse(responseData);

        final Map<String, dynamic> meta = responseData['meta'];
        currentPage.value = meta['current_page'];
        hasMoreData.value = currentPage.value < meta['last_page'];

        final List<dynamic> articlesJson = responseData['data'];
        final List<Article> newArticles = articlesJson.map((json) {
          _sanitizeContent(json);
          return Article.fromJson(json);
        }).toList();

        articles.value = newArticles;
        _performSearch();
        _lastFetch = DateTime.now();

        // Fetch details in background
        _fetchArticleDetails(newArticles);
      } else {
        _handleHttpError(response.statusCode);
      }
    } catch (e) {
      print('Error fetching articles: $e');
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches detailed information for articles
  Future<void> _fetchArticleDetails(List<Article> basicArticles) async {
    if (basicArticles.isEmpty) return;

    try {
      isLoadingMore.value = true;

      for (var article in basicArticles) {
        if (_articleCache.containsKey(article.id)) continue;

        try {
          if (!hasConnection.value) break;

          final detailResponse = await http.get(
            Uri.parse('${url}articles/${article.id}'),
            headers: {
              'Accept': 'application/json',
            },
          ).timeout(_timeout);

          if (detailResponse.statusCode == 200) {
            final detailJson = json.decode(detailResponse.body)['data'];
            _sanitizeContent(detailJson);
            final detailedArticle = Article.fromJson(detailJson);

            _articleCache[article.id] = detailedArticle;

            final index = articles.indexWhere((a) => a.id == article.id);
            if (index != -1) {
              articles[index] = detailedArticle;
            }
          }
        } catch (e) {
          print('Error fetching details for article ${article.id}: $e');
          continue;
        }
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// Fetches a single article's details
  Future<Article?> fetchArticleDetails(int articleId) async {
    try {
      if (_articleCache.containsKey(articleId)) {
        return _articleCache[articleId];
      }

      if (!hasConnection.value) {
        throw 'No internet connection';
      }

      isLoading.value = true;
      final response = await http.get(
        Uri.parse('${url}articles/$articleId'),
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final articleJson = json.decode(response.body)['data'];
        _sanitizeContent(articleJson);
        final article = Article.fromJson(articleJson);

        _articleCache[articleId] = article;
        currentArticle.value = article;

        return article;
      } else {
        _handleHttpError(response.statusCode);
        return null;
      }
    } catch (e) {
      _handleError(e);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Validates response data structure
  void _validateResponse(Map<String, dynamic> response) {
    if (!response.containsKey('data')) {
      throw 'Invalid response format';
    }
  }

  /// Sanitizes content to prevent XSS
  void _sanitizeContent(Map<String, dynamic> json) {
    json['content'] = _sanitizeString(json['content'] as String? ?? '');
    json['title'] = _sanitizeString(json['title'] as String? ?? '');
  }

  /// Sanitizes a string to prevent XSS
  String _sanitizeString(String input) {
    return input
        .replaceAll('<script>', '')
        .replaceAll('</script>', '')
        .replaceAll('javascript:', '');
  }

  /// Checks internet connection
  Future<bool> _checkConnection() async {
    try {
      final result = await http.get(Uri.parse('${url}ping')).timeout(
            const Duration(seconds: 3), // Reduced timeout for faster feedback
            onTimeout: () => throw 'Connection timeout',
          );
      return result.statusCode == 200;
    } catch (e) {
      print('Connection check failed: $e');
      return false;
    }
  }

  /// Handles HTTP errors
  void _handleHttpError(int statusCode) {
    switch (statusCode) {
      case 401:
        throw 'Unauthorized access';
      case 403:
        throw 'Access forbidden';
      case 404:
        throw 'Article not found';
      case 500:
        throw 'Server error';
      default:
        throw 'Network error: $statusCode';
    }
  }

  /// Handles general errors
  void _handleError(dynamic error) {
    print('Error: $error');
    hasError.value = true;

    if (error.toString().contains('timeout')) {
      errorMessage.value =
          'Connection timeout. Please check your internet connection.';
    } else if (!hasConnection.value) {
      errorMessage.value = 'No internet connection';
    } else {
      errorMessage.value = 'Failed to load articles. Please try again.';
    }
  }

  /// Clears the cache
  void clearCache() {
    _articleCache.clear();
    _lastFetch = null;
  }

  /// Retries the last failed operation
  Future<void> retry() async {
    clearCache();
    await fetchArticles();
  }

  Future<void> searchArticles(String query) async {
    searchQuery.value = query;
  }

  void _performSearch() {
    if (searchQuery.value.isEmpty) {
      filteredArticles.value = articles;
      return;
    }

    final query = searchQuery.value.toLowerCase();
    filteredArticles.value = articles
        .where((article) =>
            article.title.toLowerCase().contains(query) ||
            article.content.toLowerCase().contains(query))
        .toList();
  }

  Future<void> loadMoreArticles() async {
    if (isLoadingMore.value || !hasMoreData.value) return;

    try {
      isLoadingMore.value = true;
      final nextPage = currentPage.value + 1;

      final response = await http.get(
        Uri.parse('${url}articles/list?page=$nextPage&per_page=$_perPage'),
        headers: {'Accept': 'application/json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final Map<String, dynamic> meta = responseData['meta'];

        currentPage.value = meta['current_page'];
        hasMoreData.value = currentPage.value < meta['last_page'];

        final List<dynamic> newArticlesJson = responseData['data'];
        if (newArticlesJson.isEmpty) {
          hasMoreData.value = false;
          return;
        }

        final List<Article> newArticles = newArticlesJson.map((json) {
          _sanitizeContent(json);
          return Article.fromJson(json);
        }).toList();

        articles.addAll(newArticles);
        _performSearch();

        _fetchArticleDetails(newArticles);
      }
    } catch (e) {
      print('Error loading more articles: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }
}
