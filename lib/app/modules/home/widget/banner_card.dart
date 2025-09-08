import 'dart:async';
import 'package:flutter/material.dart';

class BannerCard extends StatefulWidget {
  final List<String> items;
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
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  if (_currentPage != index) {
                    setState(() {
                      _currentPage = index;
                    });
                    widget.onPageChanged?.call(index);
                    // Restart auto-scroll timer after user interaction
                    _autoScrollTimer?.cancel();
                    if (!_isUserScrolling) {
                      _startAutoScroll();
                    }
                  }
                },
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        widget.items[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.error_outline, size: 40, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Page indicators
          if (widget.items.length > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.items.length,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentPage = index;
                    });
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ).then((_) {
                      widget.onPageChanged?.call(index);
                      // Restart auto-scroll after manual navigation
                      _autoScrollTimer?.cancel();
                      _startAutoScroll();
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _currentPage == index ? 24 : 8,
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: _currentPage == index 
                          ? const Color(0xFF044D37) // Using app's primary color
                          : Colors.grey.shade300,
                    ),
                  ),
                ),
              ).toList(),
            ),
        ],
      ),
    );
  }
}
