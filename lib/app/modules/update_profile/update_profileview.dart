import 'package:elecktro_ecommerce/app/modules/update_profile/update_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class ProfileInfoView extends GetView<ProfileInfoController> {
  const ProfileInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 12.w : 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isSmallScreen),
                SizedBox(height: isSmallScreen ? 16.h : 24.h),
                _buildForm(isSmallScreen),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 14.w : 20.w),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'profile_information'.tr,
            style: TextStyle(
              fontSize: isSmallScreen ? 20.sp : 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade600,
            ),
          ),
          SizedBox(height: isSmallScreen ? 4.h : 8.h),
          Text(
            'confirm_real_info'.tr,
            style: TextStyle(
              fontSize: isSmallScreen ? 12.sp : 14.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 14.w : 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(5),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: controller.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFirstNameField(isSmallScreen),
            SizedBox(height: isSmallScreen ? 14.h : 20.h),
            _buildLastNameField(isSmallScreen),
            SizedBox(height: isSmallScreen ? 14.h : 20.h),
            _buildGenderField(isSmallScreen),
            SizedBox(height: isSmallScreen ? 14.h : 20.h),
            _buildDateField(),
            SizedBox(height: isSmallScreen ? 14.h : 20.h),
            _buildAddressField(isSmallScreen),
            SizedBox(height: isSmallScreen ? 16.h : 24.h),
            _buildConfirmButton(isSmallScreen),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool isSmallScreen) {
    return Text(
  text.endsWith('*') 
      ? '${text.substring(0, text.length - 1)}*'.tr 
      : text.tr,
  style: TextStyle(
    fontSize: isSmallScreen ? 12.sp : 14.sp,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  ),
);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    String? Function(String?)? validator,
    required bool isSmallScreen,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText.tr,
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: isSmallScreen ? 12.sp : 14.sp,
        ),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.teal.shade300, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12.w : 16.w, 
          vertical: isSmallScreen ? 10.h : 12.h
        ),
      ),
    );
  }

  Widget _buildFirstNameField(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('first_name', isSmallScreen),
        SizedBox(height: isSmallScreen ? 6.h : 8.h),
        _buildTextField(
          controller: controller.firstNameController,
          hintText: 'John',
          validator: controller.validateFirstName,
          isSmallScreen: isSmallScreen,
        ),
      ],
    );
  }

  Widget _buildLastNameField(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('last_name', isSmallScreen),
        SizedBox(height: isSmallScreen ? 6.h : 8.h),
        _buildTextField(
          controller: controller.lastNameController,
          hintText: 'Doe',
          validator: controller.validateLastName,
          isSmallScreen: isSmallScreen,
        ),
      ],
    );
  }

  Widget _buildGenderField(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('gender', isSmallScreen),
        SizedBox(height: isSmallScreen ? 6.h : 8.h),
        Obx(() => _buildDropdown(
          value: controller.selectedGender.value.isNotEmpty
              ? controller.selectedGender.value
              : null,
          items: controller.genderOptions,
          onChanged: (value) => controller.selectedGender.value = value ?? '',
          hintText: 'Select Gender'.tr,
          isSmallScreen: isSmallScreen,
        )),
      ],
    );
  }

  Widget _buildDateField() {
    return const SizedBox.shrink(); // Date field removed as per requirements
  }

  Widget _buildAddressField(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('address', isSmallScreen),
        SizedBox(height: isSmallScreen ? 6.h : 8.h),
        _buildTextField(
          controller: controller.addressController,
          hintText: 'enter_full_address'.tr,
          maxLines: isSmallScreen ? 2 : 3,
          validator: controller.validateAddress,
          isSmallScreen: isSmallScreen,
        ),
      ],
    );
  }

  Widget _buildConfirmButton(bool isSmallScreen) {
    return SizedBox(
      width: double.infinity,
      height: isSmallScreen ? 44 : 50,
      child: Obx(() => ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.updateProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          elevation: 0,
          minimumSize: Size(double.infinity, isSmallScreen ? 44 : 50),
        ),
        child: controller.isLoading.value
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'confirm'.tr,
                style: TextStyle(
                  fontSize: isSmallScreen ? 14.sp : 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      )),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required String hintText,
    required bool isSmallScreen,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item.tr,
            style: TextStyle(fontSize: isSmallScreen ? 12.sp : 14.sp),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: isSmallScreen ? 12.sp : 14.sp,
        ),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.teal.shade300, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12.w : 16.w, 
          vertical: isSmallScreen ? 10.h : 12.h
        ),
      ),
    );
  }

}