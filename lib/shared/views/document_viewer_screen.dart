import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pdfx/pdfx.dart';
import 'package:collection_agent/core/constants/app_colors.dart';
import 'package:collection_agent/core/constants/app_strings.dart';
import 'package:collection_agent/core/theme/app_text_styles.dart';

/// Full-screen in-app document viewer supporting interactive PDFs and images
class DocumentViewerScreen extends StatefulWidget {
  final String url;
  final String title;
  final String? subtitle;

  const DocumentViewerScreen({
    super.key,
    required this.url,
    required this.title,
    this.subtitle,
  });

  @override
  State<DocumentViewerScreen> createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
  Key _viewerKey = UniqueKey();
  bool _hasError = false;
  String _errorMessage = '';

  // PDF state
  PdfControllerPinch? _pdfController;
  bool _isLoadingPdf = false;
  int _pageCount = 0;
  int _currentPage = 1;

  bool get _isPdf => widget.url.toLowerCase().contains('.pdf');

  bool get _isImage {
    final lower = widget.url.toLowerCase();
    return lower.contains('.png') ||
        lower.contains('.jpg') ||
        lower.contains('.jpeg') ||
        lower.contains('.webp');
  }

  @override
  void initState() {
    super.initState();
    if (_isPdf) {
      _loadPdf();
    }
  }

  Future<void> _loadPdf() async {
    setState(() {
      _isLoadingPdf = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      final response = await Dio().get<List<int>>(
        widget.url,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.data != null) {
        final doc = await PdfDocument.openData(Uint8List.fromList(response.data!));
        _pdfController?.dispose();
        _pdfController = PdfControllerPinch(document: Future.value(doc));
        if (mounted) {
          setState(() {
            _pageCount = doc.pagesCount;
            _isLoadingPdf = false;
          });
        }
      } else {
        throw Exception('Empty document response');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingPdf = false;
          _hasError = true;
          _errorMessage = 'Failed to load PDF document. Please check your connection.';
        });
      }
    }
  }

  void _reload() {
    if (_isPdf) {
      _loadPdf();
    } else {
      setState(() {
        _hasError = false;
        _errorMessage = '';
        _viewerKey = UniqueKey();
      });
    }
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: AppTextStyles.titleMedium.copyWith(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (widget.subtitle != null && widget.subtitle!.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                widget.subtitle!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: const Color(0xFF94A3B8),
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 22),
            onPressed: _reload,
            tooltip: AppStrings.retry,
          ),
        ],
      ),
      body: SafeArea(
        child: _hasError ? _buildErrorView() : _buildDocumentContent(),
      ),
    );
  }

  Widget _buildDocumentContent() {
    if (_isPdf) {
      if (_isLoadingPdf) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 3,
              ),
              const SizedBox(height: 14),
              Text(
                'Loading PDF pages...',
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
              ),
            ],
          ),
        );
      }

      if (_pdfController != null) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PdfViewPinch(
              controller: _pdfController!,
              onPageChanged: (page) {
                if (mounted) {
                  setState(() => _currentPage = page);
                }
              },
            ),
            if (_pageCount > 0)
              Positioned(
                bottom: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xCC0F172A),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24, width: 0.8),
                  ),
                  child: Text(
                    'Page $_currentPage of $_pageCount',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ],
        );
      }
    }

    if (_isImage) {
      return Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.network(
            widget.url,
            key: _viewerKey,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              final total = loadingProgress.expectedTotalBytes;
              final loaded = loadingProgress.cumulativeBytesLoaded;
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      value: total != null ? loaded / total : null,
                      color: AppColors.primary,
                      strokeWidth: 3,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Loading image...',
                      style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return _buildErrorView(errorText: 'Failed to load image');
            },
          ),
        ),
      );
    }

    // Default fallback: Try loading as image with zoom
    return Center(
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: Image.network(
          widget.url,
          key: _viewerKey,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorView(errorText: 'Unsupported file preview format');
          },
        ),
      ),
    );
  }

  Widget _buildErrorView({String? errorText}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.broken_image_outlined,
                color: Color(0xFFEF4444),
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.failedToLoadDocument,
              style: AppTextStyles.titleMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              (errorText != null && errorText.isNotEmpty)
                  ? errorText
                  : (_errorMessage.isNotEmpty
                      ? _errorMessage
                      : 'Please check your internet connection and try again.'),
              style: AppTextStyles.bodySmall.copyWith(
                color: const Color(0xFF94A3B8),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _reload,
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(
                AppStrings.retry,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
