// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import '../../controllers/account_edit_controller.dart';
// import 'package:elecktro_ecommerce/app/core/network/app_urls.dart';

// class ProfileImageUpload extends StatelessWidget {
//   final double size;
//   final double iconSize;
//   final bool showEditIcon;

//   const ProfileImageUpload({
//     Key? key,
//     this.size = 100,
//     this.iconSize = 24,
//     this.showEditIcon = true,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final AccountController controller = Get.find<AccountController>();
    
//     return Obx(() {
//       final hasLocalImage = controller.profileImage.value != null;
//       final hasNetworkImage = controller.profileImageUrl.value.isNotEmpty;
//       // Check if the image is a local file (for web compatibility)
//       final isLocalImage = hasLocalImage && 
//           (controller.profileImage.value!.path.startsWith('/') ||
//            controller.profileImage.value!.path.startsWith('C:'));
      
//       return Stack(
//         children: [
//           // Profile image with border
//           Container(
//             width: size,
//             height: size,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(
//                 color: Theme.of(context).primaryColor,
//                 width: 2.0,
//               ),
//             ),
//             child: ClipOval(
//               child: hasLocalImage
//                   ? Image.file(
//                       controller.profileImage.value!,
//                       width: size,
//                       height: size,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) => _buildPlaceholder(context),
//                     )
//                   : hasNetworkImage
//                       ? CachedNetworkImage(
//                           imageUrl: '${AppUrls.baseImageUrl}${controller.profileImageUrl.value}',
//                           width: size,
//                           height: size,
//                           fit: BoxFit.cover,
//                           placeholder: (context, url) => _buildPlaceholder(context),
//                           errorWidget: (context, url, error) => _buildPlaceholder(context),
//                         )
//                       : _buildPlaceholder(context),
//             ),
//           ),
          
//           // Edit icon
//           if (showEditIcon)
//             Positioned(
//               right: 0,
//               bottom: 0,
//               child: Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).primaryColor,
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: Theme.of(context).scaffoldBackgroundColor,
//                     width: 2.0,
//                   ),
//                 ),
//                 child: GestureDetector(
//                   onTap: () => _showImageSourceDialog(controller, context),
//                   child: Icon(
//                     Icons.camera_alt,
//                     size: iconSize,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       );
//     });
//   }

//   Widget _buildPlaceholder(BuildContext context) {
//     return Container(
//       color: Colors.grey[200],
//       child: Icon(
//         Icons.person,
//         size: size * 0.6,
//         color: Colors.grey[400],
//       ),
//     );
//   }

//   void _showImageSourceDialog(AccountController controller, BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               ListTile(
//                 leading: const Icon(Icons.photo_library),
//                 title: const Text('Choose from Gallery'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   controller.pickImage();
//                 },
//               ),
//               if (controller.profileImage.value != null || 
//                   controller.profileImageUrl.value.isNotEmpty)
//                 ListTile(
//                   leading: const Icon(Icons.delete, color: Colors.red),
//                   title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
//                   onTap: () {
//                     Navigator.pop(context);
//                     controller.removeImage();
//                   },
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
