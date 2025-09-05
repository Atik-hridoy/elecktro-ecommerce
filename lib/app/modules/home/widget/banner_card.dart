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

  @override
  void initState() {
    super.initState();
    _currentPage = widget.currentIndex;
    _pageController = PageController(initialPage: _currentPage);
    _startAutoScroll();
  }
  
  @override
  void didUpdateWidget(BannerCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != _currentPage) {
      _currentPage = widget.currentIndex;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      if (_pageController.hasClients) {
        if (widget.items.isEmpty) return;
        if (_currentPage < widget.items.length - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _pageController.jumpToPage(0);
          _currentPage = 0;
          widget.onPageChanged?.call(_currentPage);
        }
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
          // Main Image with smooth sliding
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                if (_currentPage != index) {
                  _currentPage = index;
                  widget.onPageChanged?.call(index);
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
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Clean indicators without shadow
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.items.length,
              (index) => GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _currentPage == index ? 24 : 8,
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: _currentPage == index 
                        ? Colors.orange 
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
