import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';
import 'package:ottstudy/ui/widget/custom_text_label.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../res/colors.dart';
import '../../widget/widget.dart';

class AdminCourseEditScreen extends StatefulWidget {
  const AdminCourseEditScreen({super.key});

  @override
  State<AdminCourseEditScreen> createState() => _AdminCourseEditScreenState();
}

class _AdminCourseEditScreenState extends State<AdminCourseEditScreen> {
  File? _image;
  final picker = ImagePicker();

  Future showPickImageOptions() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const CustomTextLabel(
                  'Camera',
                  fontWeight: FontWeight.bold,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  getImageFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.image_outlined),
                title: const CustomTextLabel(
                  'Thư viện',
                  fontWeight: FontWeight.bold,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  pickImagesFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future pickImagesFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future getImageFromCamera() async {
    var status = await Permission.camera.status;

    if (status.isDenied) {
      status = await Permission.camera.request();
    }

    if (status.isGranted) {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } else if (status.isPermanentlyDenied) {
      CustomSnackBar.showMessage(context, mess: "Quyền truy cập camera bị từ chối");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      hideAppBar: true,
      colorBackground: AppColors.background_white,
      //title: 'Tạo khóa học',
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextLabel('Hình ảnh khóa học', fontWeight:  FontWeight.bold,),
                  BaseButton(
                    onTap: () {
                      showPickImageOptions();
                    },
                    gradient: AppColors.base_gradient_1,
                    borderRadius: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomTextLabel(
                          'Tải ảnh lên',
                          color: AppColors.white,
                        ),
                        const SizedBox(width: 20,),
                        Icon(PhosphorIcons.image(), color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              _image != null
              ?Image.file(
                _image!,
              ) : const SizedBox.shrink(),
              const SizedBox(height: 20,),
              CustomTextLabel('Thông tin cơ bản', fontWeight:  FontWeight.bold,),
              const SizedBox(height: 10,),
              CustomTextInput(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.white, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.white, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: "Tên khóa học",
                validator: (String value) {
                  if (value.isEmpty) {
                    return "Loi";
                  }
                },
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    child: CustomTextInput(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.white, width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.white, width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: "Môn học",
                      isDropdownTF: true,
                      suffixIconMargin: 0,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: CustomTextInput(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.white, width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.white, width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: "Lớp",
                      isDropdownTF: true,
                      suffixIconMargin: 0,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20,),
              CustomTextLabel('Danh sách bài học', fontWeight:  FontWeight.bold,),
              const SizedBox(height: 10,),
            ],
          ),
        ),
      ),
      bottomBar: BottomAppBar(
        color: AppColors.background_white,
        height: 70,
        child: BaseButton(
          title: 'Gửi yêu cầu',
          borderRadius: 20,
        ),
      ),
    );
  }
}
