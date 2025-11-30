import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manpro/common/widgets/background_app.dart';
import 'package:manpro/utils/constants/image_string.dart';

// Halaman Detail Artikel yang menampilkan informasi lengkap tentang sebuah artikel
class ArticleDetail extends StatefulWidget {
  // Data yang diperlukan untuk menampilkan detail artikel
  final String title; // Judul artikel
  final String content; // Isi artikel
  final String image; // Gambar utama artikel
  final String date; // Tanggal artikel
  final List<String>? additionalImages; // Gambar-gambar tambahan (opsional)

  const ArticleDetail({
    super.key,
    required this.title,
    required this.content,
    required this.image,
    required this.date,
    this.additionalImages,
  });

  @override
  State<ArticleDetail> createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<ArticleDetail>
    with AutomaticKeepAliveClientMixin {
  // Controller untuk mengatur tampilan gambar
  final _pageController = PageController();

  // State untuk mengatur tampilan
  final _currentPage = 0.obs; // Halaman gambar yang sedang aktif
  final _images = <String>[].obs; // List semua gambar yang akan ditampilkan
  final _imageErrors = <int, bool>{}.obs; // Tracking error loading gambar

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Inisialisasi daftar gambar saat widget pertama kali dibuat
    _setupImages();
  }

  // Menyiapkan daftar gambar yang akan ditampilkan
  void _setupImages() {
    try {
      // Tambahkan gambar utama jika valid
      if (widget.image.isNotEmpty) {
        _images.add(widget.image);
      }

      // Tambahkan gambar tambahan jika ada
      if (widget.additionalImages != null &&
          widget.additionalImages!.isNotEmpty) {
        _images.addAll(widget.additionalImages!);
      }
    } catch (e) {
      print('Error setting up images: $e');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
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

          // Konten utama
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tombol kembali
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const ImageIcon(
                        AssetImage(YPKImages.icon_back_button),
                        size: 32.0,
                      ),
                    ),
                    const SizedBox(height: 25.0),

                    // Header "Articles"
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Articles',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            fontSize: 24.0,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Bagian galeri gambar
                    Obx(() {
                      // Tampilkan pesan jika tidak ada gambar
                      if (_images.isEmpty) {
                        return const SizedBox(
                          height: 200,
                          child: Center(child: Text('No images available')),
                        );
                      }

                      // Tampilan galeri gambar dengan PageView
                      return SizedBox(
                        height: 500,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // PageView untuk slide gambar
                            PageView.builder(
                              controller: _pageController,
                              itemCount: _images.length,
                              onPageChanged: (index) =>
                                  _currentPage.value = index,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                // Tampilkan error icon jika gambar gagal dimuat
                                if (_imageErrors[index] == true) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Icon(
                                        Icons.error_outline,
                                        color: Colors.grey,
                                        size: 50,
                                      ),
                                    ),
                                  );
                                }

                                // Tampilan gambar
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 0,
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      _images[index],
                                      fit: BoxFit.fill,
                                      // Optimasi ukuran gambar
                                      cacheWidth: MediaQuery.of(context)
                                          .size
                                          .width
                                          .toInt(),
                                      // Loading indicator
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                      // Error handler
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        _imageErrors[index] = true;
                                        return Container(
                                          color: Colors.grey[300],
                                          child: const Center(
                                            child: Icon(
                                              Icons.error_outline,
                                              color: Colors.grey,
                                              size: 50,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),

                            // Indikator halaman (dots)
                            if (_images.length > 1)
                              Positioned(
                                bottom: 16,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    _images.length,
                                    (index) => Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      width:
                                          _currentPage.value == index ? 12 : 8,
                                      height:
                                          _currentPage.value == index ? 12 : 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _currentPage.value == index
                                            ? Colors.black.withOpacity(0.9)
                                            : Colors.grey.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 20),

                    // Konten artikel (tanggal, judul, dan isi)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tanggal artikel
                          Text(
                            widget.date,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontFamily: 'NunitoSans',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Judul artikel
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontFamily: 'NunitoSans',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Isi artikel
                          Text(
                            widget.content,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'NunitoSans',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
