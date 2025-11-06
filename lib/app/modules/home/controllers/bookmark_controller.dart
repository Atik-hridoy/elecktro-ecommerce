// lib/app/modules/home/controllers/bookmark_controller.dart
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/modules/home/services/bookmark_service.dart';

class BookmarkController extends GetxController {
  final BookmarkService _bookmarkService = Get.find<BookmarkService>();
  final RxSet<String> _bookmarkedIds = <String>{}.obs;
  final RxSet<String> _loadingIds = <String>{}.obs;
  final RxBool _isLoading = false.obs;
  final RxList<Map<String, dynamic>> bookmarks = <Map<String, dynamic>>[].obs;

  bool get isBookmarksLoading => _isLoading.value;
  Set<String> get bookmarkedIds => _bookmarkedIds.toSet();

  bool isBookmarked(String productId) => _bookmarkedIds.contains(productId);
  bool isLoading(String productId) => _loadingIds.contains(productId);

  Future<void> toggleBookmark(String productId) async {
    if (_loadingIds.contains(productId)) return;

    _loadingIds.add(productId);
    update();

    try {
      final success = await _bookmarkService.toggleBookmark(productId);
      if (success) {
        if (_bookmarkedIds.contains(productId)) {
          _bookmarkedIds.remove(productId);
        } else {
          _bookmarkedIds.add(productId);
        }
      }
    } finally {
      _loadingIds.remove(productId);
      update();
    }
  }

  /// Fetches all bookmarks for the current user
  Future<void> getBookmarks() async {
    if (_isLoading.value) return;
    
    _isLoading.value = true;
    update();
    
    try {
      final result = await _bookmarkService.getBookmarks();
      bookmarks.assignAll(result);
      // Update the _bookmarkedIds set with the latest bookmarks
      _bookmarkedIds.clear();
      _bookmarkedIds.addAll(result.map((b) => b['productId'].toString()));
    } catch (e) {
      print('Error fetching bookmarks: $e');
    
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  /// Delete a bookmark by ID
  Future<bool> deleteBookmark(String bookmarkId, String productId) async {
    try {
      final success = await _bookmarkService.deleteBookmark(bookmarkId);
      
      if (success) {
        // Remove from bookmarks list
        bookmarks.removeWhere((bookmark) => bookmark['_id'] == bookmarkId);
        // Remove from bookmarked IDs
        _bookmarkedIds.remove(productId);
        update();
        
        Get.snackbar(
          'success'.tr,
          'bookmark_removed'.tr,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
      
      return success;
    } catch (e) {
      print('Error deleting bookmark: $e');
      Get.snackbar(
        'error'.tr,
        'failed_to_remove_bookmark'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Load bookmarks when controller initializes
    getBookmarks();
  }
}