import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BannerCard extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final int currentIndex;
  final ValueChanged<int>? onPageChanged;
  
  const BannerCard({
    super.key,
    required this.items,
    required this.currentIndex,
    this.onPageChanged,
  });

  @override
  State<BannerCard> createState() => _BannerCardState();
}

class _BannerCardState extends State<BannerCard> {
  late final PageController _pageController;
  late int _currentPage;
  Timer? _autoScrollTimer;
  bool _isUserScrolling = false;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.currentIndex;
    _pageController = PageController(initialPage: _currentPage);
    // Start auto-scroll after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }
  
  @override
  void didUpdateWidget(BannerCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != _currentPage && !_isUserScrolling) {
      _currentPage = widget.currentIndex;
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel(); // Cancel any existing timer
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      if (_pageController.hasClients && !_isUserScrolling && widget.items.length > 1) {
        int nextPage = _currentPage + 1;
        if (nextPage >= widget.items.length) {
          nextPage = 0;
        }
        
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        ).then((_) {
          if (mounted) {
            setState(() {
              _currentPage = nextPage;
            });
            widget.onPageChanged?.call(_currentPage);
          }
        });
      }
    });
  }

  void _restartAutoScroll() {
    _autoScrollTimer?.cancel();
    _startAutoScroll();
  }

  Widget _buildPageIndicator() {
  if (widget.items.isEmpty) return const SizedBox.shrink();
  
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List<Widget>.generate(
      widget.items.length,
      (index) => _buildIndicator(index == _currentPage, index), // Pass index as second parameter
    ),
  );
}

Widget _buildIndicator(bool isActive, int index) {
  return GestureDetector(
    onTap: () {
      if (_currentPage != index) {
        _isUserScrolling = true;
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ).then((_) {
          if (mounted) {
            setState(() {
              _currentPage = index;
              _isUserScrolling = false;
            });
            widget.onPageChanged?.call(index);
            _restartAutoScroll();
          }
        });
      }
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? 24 : 8,
      height: 4,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: isActive ? const Color(0xFF044D37) : Colors.grey.shade300,
      ),
    ),
  );
}

  Widget _buildPageView() {
    if (widget.items.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: const Center(
          child: Text('No banners available', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return PageView.builder(
      controller: _pageController,
      itemCount: widget.items.length,
      onPageChanged: (index) {
        if (!_isUserScrolling) return;
        setState(() {
          _currentPage = index;
        });
        widget.onPageChanged?.call(index);
        _restartAutoScroll();
      },
      itemBuilder: (context, index) {
        final banner = widget.items[index];
        final imageUrl = banner['image_url']?.toString() ?? '';
        
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => _buildErrorWidget(),
                  )
                : _buildErrorWidget(),
          ),
        );
      },
    );
  }
  
  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.broken_image, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text('Failed to load image', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Main Image with smooth sliding and gesture detection
          SizedBox(
            height: 200,
            child: GestureDetector(
              onPanDown: (_) {
                _isUserScrolling = true;
                _autoScrollTimer?.cancel();
              },
              onPanEnd: (_) {
                _isUserScrolling = false;
                _startAutoScroll();
              },
              child: _buildPageView(),
            ),
          ),
          const SizedBox(height: 12),
          // Page indicators
          _buildPageIndicator(),

        ],
      ),
    );
  }
}
