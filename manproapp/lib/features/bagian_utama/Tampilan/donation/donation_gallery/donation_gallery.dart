import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manpro/common/widgets/background_app.dart';
import 'package:manpro/navbar.dart';
import 'package:manpro/features/bagian_utama/Controllers/donation_gallery_controller.dart';
import 'package:manpro/features/bagian_utama/Models/donation_gallery.dart'
    as model;
import 'package:manpro/utils/constants/image_string.dart';

/// DonationGallery menampilkan galeri foto donasi dalam bentuk grid
/// Menggunakan StatefulWidget untuk mengelola state loading dan error
class DonationGallery extends StatefulWidget {
  const DonationGallery({super.key});

  @override
  State<DonationGallery> createState() => _DonationGalleryState();
}

class _DonationGalleryState extends State<DonationGallery>
    with WidgetsBindingObserver {
  //================ CONTROLLER & STATE ================//

  // Controller untuk mengambil data galeri
  final DonationGalleryController _controller = DonationGalleryController();

  // Future untuk menyimpan data galeri
  late Future<List<model.DonationGallery>> _galleryFuture;

  // State untuk mengelola loading dan error
  bool _isLoading = false;
  String? _errorMessage;
  final ScrollController _scrollController = ScrollController();

  // State untuk pagination
  int _currentPage = 1;
  bool _hasMoreData = true;
  static const int _itemsPerPage = 20;

  // Cache untuk gambar yang sudah dimuat
  final Set<String> _loadedImages = {};

  //================ LIFECYCLE METHODS ================//

  @override
  void initState() {
    super.initState();
    // Daftarkan observer untuk lifecycle events
    WidgetsBinding.instance.addObserver(this);
    // Inisialisasi data galeri
    _initializeGallery();
    // Setup scroll listener untuk pagination
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    // Bersihkan resources saat widget di-dispose
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _loadedImages.clear();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Refresh data saat aplikasi kembali ke foreground
    if (state == AppLifecycleState.resumed) {
      _initializeGallery();
    }
  }

  //================ DATA LOADING ================//

  // Scroll listener untuk infinite loading
  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreData();
    }
  }

  // Inisialisasi galeri dengan error handling
  Future<void> _initializeGallery() async {
    if (_isLoading) return;

    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _currentPage = 1;
        _hasMoreData = true;
      });
    }

    try {
      // Muat data dengan timeout 30 detik
      _galleryFuture = _controller
          .getGalleryImages(
        page: _currentPage,
        limit: _itemsPerPage,
      )
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception(
              'Koneksi timeout, silakan periksa koneksi internet Anda');
        },
      );

      final data = await _galleryFuture;
      if (data.length < _itemsPerPage) {
        _hasMoreData = false;
      }
      _currentPage++;
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = _getErrorMessage(e);
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Load more data untuk pagination
  Future<void> _loadMoreData() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() => _isLoading = true);

    try {
      final newData = await _controller.getGalleryImages(
        page: _currentPage,
        limit: _itemsPerPage,
      );

      if (newData.length < _itemsPerPage) {
        _hasMoreData = false;
      }

      final List<model.DonationGallery> currentData = await _galleryFuture;
      currentData.addAll(newData);

      _galleryFuture = Future.value(currentData);
      _currentPage++;
    } catch (e) {
      debugPrint('Error loading more data: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  //================ HELPER METHODS ================//

  // Get user-friendly error message
  String _getErrorMessage(dynamic error) {
    String message = error.toString().replaceAll('Exception:', '').trim();
    if (message.isEmpty) {
      message = 'Terjadi kesalahan, silakan coba lagi';
    }
    return message;
  }

  // Validasi URL gambar
  bool _isValidImageUrl(String url) {
    if (url.isEmpty) return false;

    // Validasi format URL
    final validUrl = Uri.tryParse(url);
    if (validUrl == null || !validUrl.hasAbsolutePath) return false;

    // Validasi protocol
    if (!validUrl.scheme.startsWith('http')) return false;

    // Validasi ekstensi file
    final validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
    return validExtensions.any((ext) => url.toLowerCase().endsWith(ext));
  }

  // Membersihkan teks dari karakter berbahaya
  String _sanitizeText(String? text) {
    if (text == null || text.isEmpty) {
      return '';
    }
    String sanitized = text;

    // Hapus HTML tags
    sanitized = sanitized.replaceAll(RegExp("[<>]"), '');

    // Hapus karakter khusus
    sanitized = sanitized.replaceAll(RegExp("[\"'\\\\\$]"), '');

    // Trim whitespace
    return sanitized.trim();
  }

  // Preload image untuk smooth loading
  Future<void> _preloadImage(String imageUrl) async {
    if (_loadedImages.contains(imageUrl)) return;

    try {
      const configuration = ImageConfiguration();
      final image = NetworkImage(imageUrl);
      image.resolve(configuration);
      _loadedImages.add(imageUrl);
    } catch (e) {
      debugPrint('Error preloading image: $imageUrl');
    }
  }

  //================ BUILD METHOD ================//

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background aplikasi
          const BackgroundAPP(),

          // Konten utama
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 17.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tombol kembali dengan error handling
                  IconButton(
                    onPressed: () {
                      try {
                        Get.to(() => const Navbar());
                      } catch (e) {
                        Get.back(); // Fallback navigation
                      }
                    },
                    icon: const ImageIcon(
                      AssetImage(YPKImages.icon_back_button),
                      size: 32.0,
                      semanticLabel: 'Kembali ke halaman sebelumnya',
                    ),
                  ),

                  const SizedBox(height: 25.0),

                  // Judul halaman
                  const Text(
                    'Galeri',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 20.0),

                  // Kontainer galeri dengan refresh
                  Expanded(
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 2.0,
                          ),
                        ),
                        padding: const EdgeInsets.all(12.0),

                        // Refresh indicator untuk reload data
                        child: RefreshIndicator(
                          onRefresh: _initializeGallery,
                          child: FutureBuilder<List<model.DonationGallery>>(
                            future: _galleryFuture,
                            builder: (context, snapshot) {
                              // Tampilkan loading spinner
                              if (snapshot.connectionState ==
                                      ConnectionState.waiting &&
                                  _isLoading &&
                                  _currentPage == 1) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              // Tampilkan pesan error
                              if (_errorMessage != null || snapshot.hasError) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                        size: 48,
                                        semanticLabel: 'Terjadi kesalahan',
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        _errorMessage ??
                                            _getErrorMessage(snapshot.error),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: _isLoading
                                            ? null
                                            : _initializeGallery,
                                        child: const Text('Coba Lagi'),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              // Tampilkan pesan jika tidak ada foto
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Center(
                                  child: Text(
                                    'Belum ada foto',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }

                              // Tampilkan grid foto
                              return GridView.builder(
                                controller: _scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8.0,
                                  mainAxisSpacing: 8.0,
                                  childAspectRatio: 3 / 4,
                                ),
                                itemCount: snapshot.data!.length +
                                    (_hasMoreData ? 1 : 0),
                                itemBuilder: (context, index) {
                                  // Tampilkan loading indicator di akhir list
                                  if (index == snapshot.data!.length) {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.grey.shade300,
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  final gallery = snapshot.data![index];
                                  final bool isValidUrl =
                                      _isValidImageUrl(gallery.imageUrl);

                                  // Preload next image
                                  if (index < snapshot.data!.length - 1) {
                                    final nextGallery =
                                        snapshot.data![index + 1];
                                    if (_isValidImageUrl(
                                        nextGallery.imageUrl)) {
                                      _preloadImage(nextGallery.imageUrl);
                                    }
                                  }

                                  return Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          // Tampilkan foto dengan loading dan error handling
                                          if (isValidUrl)
                                            Image.network(
                                              gallery.imageUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  color: Colors.grey[200],
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.error_outline,
                                                      color: Colors.red,
                                                      semanticLabel:
                                                          'Gagal memuat gambar',
                                                    ),
                                                  ),
                                                );
                                              },
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return Center(
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
                                                      Colors.grey.shade300,
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          else
                                            Container(
                                              color: Colors.grey[200],
                                              child: const Center(
                                                child: Icon(
                                                  Icons.broken_image,
                                                  color: Colors.red,
                                                  semanticLabel:
                                                      'URL gambar tidak valid',
                                                ),
                                              ),
                                            ),

                                          // Tampilkan caption yang sudah dibersihkan
                                          if (gallery.caption?.isNotEmpty ==
                                              true)
                                            Positioned(
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin:
                                                        Alignment.bottomCenter,
                                                    end: Alignment.topCenter,
                                                    colors: [
                                                      Colors.black
                                                          .withOpacity(0.8),
                                                      Colors.transparent,
                                                    ],
                                                  ),
                                                ),
                                                child: Text(
                                                  _sanitizeText(
                                                      gallery.caption),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
