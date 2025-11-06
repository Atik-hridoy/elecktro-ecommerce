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
      // Validate inputs
      if (bookmarkId.isEmpty) {
        print('❌ Cannot delete bookmark: Invalid bookmark ID');
        Get.snackbar(
          'error'.tr,
          'Invalid bookmark ID',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        return false;
      }
      
      print('🗑️ Attempting to delete bookmark: $bookmarkId for product: $productId');
      
      final success = await _bookmarkService.deleteBookmark(bookmarkId);
      
      if (success) {
        // Remove from bookmarks list
        bookmarks.removeWhere((bookmark) => bookmark['_id'] == bookmarkId);
        // Remove from bookmarked IDs
        _bookmarkedIds.remove(productId);
        update();
        
        print('✅ Bookmark removed successfully from local state');
        
        Get.snackbar(
          'success'.tr,
          'bookmark_removed'.tr,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        print('⚠️ Bookmark deletion returned false');
      }
      
      return success;
    } catch (e) {
      print('❌ Error deleting bookmark: $e');
      
      // Check if it's a 404 error (bookmark already deleted)
      if (e.toString().contains('404')) {
        print('⚠️ Bookmark not found on server, removing from local state');
        // Remove from local state anyway
        bookmarks.removeWhere((bookmark) => bookmark['_id'] == bookmarkId);
        _bookmarkedIds.remove(productId);
        update();
        
        Get.snackbar(
          'info'.tr,
          'Bookmark already removed',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        return true;
      }
      
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