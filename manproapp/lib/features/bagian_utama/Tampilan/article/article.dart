import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manpro/common/widgets/background_app.dart';
import 'package:manpro/navbar.dart';
import 'package:manpro/utils/constants/image_string.dart';
import 'package:manpro/features/bagian_utama/Tampilan/article/article_detail/article_detail.dart';
import 'package:manpro/features/bagian_utama/controllers/articleController.dart';

/// Halaman Artikel yang menampilkan daftar artikel
/// Menggunakan StatefulWidget dengan AutomaticKeepAliveClientMixin untuk menjaga state
class Article extends StatefulWidget {
  const Article({super.key});

  @override
  State<Article> createState() => _ArticleState();
}

class _ArticleState extends State<Article> with AutomaticKeepAliveClientMixin {
  //================ CONTROLLER & STATE ================//

  // Controller untuk artikel dan pencarian
  late final ArticleController articleController;
  final TextEditingController _searchController = TextEditingController();

  // Key untuk refresh indicator dan scroll
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  final _scrollController = ScrollController();

  // Timer untuk debounce pencarian
  Timer? _debounceTimer;

  // Constants untuk timeout dan debounce
  static const Duration _debounceDelay = Duration(milliseconds: 500);
  static const Duration _timeoutDuration = Duration(seconds: 30);
  static const double _scrollThreshold = 500.0;
  static const int _maxSearchLength = 100;

  //================ LIFECYCLE METHODS ================//

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    // Inisialisasi controller
    if (!Get.isRegistered<ArticleController>()) {
      articleController = Get.put(ArticleController());
    } else {
      articleController = Get.find<ArticleController>();
    }

    // Muat data artikel jika belum ada
    if (articleController.articles.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        articleController.fetchArticles();
      });
    }

    // Setup scroll listener untuk infinite loading
    _scrollController.addListener(() {
      if (!_scrollController.hasClients) return;

      // Muat artikel lebih banyak saat scroll mendekati bawah
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - _scrollThreshold) {
        articleController.loadMoreArticles();
      }
    });
  }

  @override
  void dispose() {
    // Bersihkan resources saat widget di-dispose
    _searchController.dispose();
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background aplikasi
          const BackgroundAPP(),

          // Konten utama dengan refresh indicator
          SafeArea(
            child: RefreshIndicator(
              key: _refreshKey,
              onRefresh: () async {
                articleController.clearCache();
                await articleController
                    .fetchArticles()
                    .timeout(_timeoutDuration);
              },
              child: Obx(() {
                //================ LOADING STATE ================//

                // Tampilkan loading spinner saat pertama kali memuat data
                if (articleController.isLoading.value &&
                    articleController.articles.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Loading articles...',
                          style: TextStyle(
                            fontFamily: 'NunitoSans',
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                //================ ERROR STATE ================//

                // Tampilkan pesan error jika ada
                if (articleController.hasError.value) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                size: 48, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(
                              articleController.errorMessage.value,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () async {
                                articleController.clearCache();
                                await articleController.fetchArticles();
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Try Again'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                //================ MAIN CONTENT ================//

                return SingleChildScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tombol kembali ke navbar
                        IconButton(
                          onPressed: () => Get.to(() => const Navbar()),
                          icon: const ImageIcon(
                            AssetImage(YPKImages.icon_back_button),
                            size: 32.0,
                            semanticLabel: 'Kembali ke halaman utama',
                          ),
                        ),
                        const SizedBox(height: 25.0),

                        // Judul halaman
                        const Text(
                          'Articles',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            fontSize: 24.0,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Kolom pencarian
                        TextField(
                          controller: _searchController,
                          maxLength: _maxSearchLength,
                          buildCounter: (context,
                                  {required currentLength,
                                  required isFocused,
                                  maxLength}) =>
                              null,
                          decoration: InputDecoration(
                            hintText: 'Search for an article...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          onChanged: (value) {
                            // Tunda pencarian untuk menghindari terlalu banyak request
                            _debounceTimer?.cancel();
                            _debounceTimer = Timer(
                              _debounceDelay,
                              () {
                                // Bersihkan input dari karakter berbahaya
                                final sanitizedValue = value
                                    .trim()
                                    .replaceAll(RegExp(r'[^\w\s]'), '');
                                articleController
                                    .searchArticles(sanitizedValue);
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 20),

                        // Daftar artikel
                        Obx(() {
                          final articles = articleController.filteredArticles;

                          // Tampilkan pesan jika tidak ada artikel
                          if (articles.isEmpty) {
                            return Center(
                              child: Text(
                                articleController.articles.isEmpty
                                    ? 'Belum ada artikel'
                                    : 'Tidak ada artikel yang sesuai pencarian',
                                style: const TextStyle(
                                  fontFamily: 'NunitoSans',
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }

                          // Tampilkan daftar artikel
                          return Column(
                            children: [
                              // List artikel
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: articles.length,
                                itemBuilder: (context, index) {
                                  final article = articles[index];

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.all(16),
                                        // Gambar artikel
                                        leading: Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: article.isAsset == 'true'
                                                ? Image.asset(
                                                    article.image,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      debugPrint(
                                                          'Error loading image: $error');
                                                      return Container(
                                                        color: Colors.grey[300],
                                                        child: const Icon(
                                                          Icons.error,
                                                          semanticLabel:
                                                              'Gambar gagal dimuat',
                                                        ),
                                                      );
                                                    },
                                                  )
                                                : Image.network(
                                                    article.image,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      debugPrint(
                                                          'Error loading image: $error');
                                                      return Container(
                                                        color: Colors.grey[300],
                                                        child: const Icon(
                                                          Icons.error,
                                                          semanticLabel:
                                                              'Gambar gagal dimuat',
                                                        ),
                                                      );
                                                    },
                                                    loadingBuilder: (context,
                                                        child,
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return Container(
                                                        color: Colors.grey[200],
                                                        child: Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            value: loadingProgress
                                                                        .expectedTotalBytes !=
                                                                    null
                                                                ? loadingProgress
                                                                        .cumulativeBytesLoaded /
                                                                    loadingProgress
                                                                        .expectedTotalBytes!
                                                                : null,
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                    Color>(
                                                              Colors.grey
                                                                  .shade400,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                          ),
                                        ),
                                        // Tanggal artikel
                                        title: Text(
                                          article.date,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontFamily: 'NunitoSans',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        // Judul artikel
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 8),
                                            Text(
                                              article.title,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontFamily: 'NunitoSans',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: const Icon(
                                          Icons.arrow_forward,
                                          semanticLabel: 'Lihat detail artikel',
                                        ),
                                        // Navigasi ke detail artikel
                                        onTap: () {
                                          Get.to(() => ArticleDetail(
                                                title: article.title,
                                                content: article.content,
                                                image: article.image,
                                                date: article.date,
                                                additionalImages:
                                                    article.additionalImages,
                                              ));
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                              // Loading indicator saat memuat artikel tambahan
                              if (articleController.isLoadingMore.value)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.grey.shade400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
