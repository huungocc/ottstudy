import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ottstudy/blocs/auth/signup_cubit.dart';
import 'package:ottstudy/blocs/upload_file_cubit.dart';
import 'package:ottstudy/data/models/signup_model.dart';
import 'package:ottstudy/data/models/upload_file_model.dart';
import 'package:ottstudy/ui/widget/base_button.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';
import 'package:ottstudy/ui/widget/custom_text_label.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../blocs/base_bloc/base_state.dart';
import '../../../gen/assets.gen.dart';
import '../../../res/colors.dart';
import '../../../util/common.dart';
import '../../../util/routes.dart';
import '../../widget/widget.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UploadFileCubit(),
        ),
        BlocProvider(
          create: (_) => SignupCubit(),
        ),
      ],
      child: SignupBody(),
    );
  }
}

class SignupBody extends StatefulWidget {
  const SignupBody({super.key});

  @override
  State<SignupBody> createState() => _SignupBodyState();
}

class _SignupBodyState extends State<SignupBody> {
  final _keyEmail = GlobalKey<TextFieldState>();
  final _keyPassword = GlobalKey<TextFieldState>();
  final _keyConfirmPassword = GlobalKey<TextFieldState>();
  final _keyName = GlobalKey<TextFieldState>();
  final _keyDateOfBirth = GlobalKey<TextFieldState>();
  final _keyPhone = GlobalKey<TextFieldState>();
  final _keyGrade = GlobalKey<TextFieldState>();

  File? _image;
  final picker = ImagePicker();
  String? imageUrl;

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
        context.read<UploadFileCubit>().uploadFile(_image!);
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
          context.read<UploadFileCubit>().uploadFile(_image!);
        });
      }
    } else if (status.isPermanentlyDenied) {
      CustomSnackBar.showMessage(context, mess: "Quyền truy cập camera bị từ chối");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Đăng ký tài khoản',
      colorBackground: AppColors.background_white,
      resizeToAvoidBottomInset: true,
      loadingWidget: Stack(
        children: [
          CustomLoading<UploadFileCubit>(),
          CustomLoading<SignupCubit>(),
        ],
      ),
      messageNotify: Stack(
        children: [
          CustomSnackBar<UploadFileCubit>(),
          CustomSnackBar<SignupCubit>(),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Align(alignment: Alignment.center, child: Assets.images.imgSign.image(scale: 2.5)),
              const SizedBox(
                height: 30,
              ),
              const CustomTextLabel(
                'Thông tin đăng nhập',
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 15,
              ),
              CustomTextInput(
                key: _keyEmail,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.white, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.white, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: "Nhập email",
                validator: (String value) {
                  if (value.isEmpty) {
                    return "Email không được để trống";
                  } else if (!Common.validateEmail(value)) {
                    return "Vui lòng nhập đúng định dạng email";
                  } else {
                    return "";
                  }
                },
              ),
              const SizedBox(
                height: 15,
              ),
              CustomTextInput(
                key: _keyPassword,
                isPasswordTF: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.white, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.white, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: "Nhập mật khẩu",
                validator: (String value) {
                  if (value.isEmpty) {
                    return "Mật khẩu không được để trống";
                  } else if (!Common.validatePassword(value)) {
                    return "Vui lòng nhập mật khẩu có ít nhất 8 ký tự, bao gồm chữ hoa, số và ký tự đặc biệt";
                  } else {
                    return "";
                  }
                },
              ),
              const SizedBox(
                height: 15,
              ),
              CustomTextInput(
                key: _keyConfirmPassword,
                isPasswordTF: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.white, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.white, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: "Nhập lại mật khẩu",
                validator: (String value) {
                  if (value != _keyPassword.currentState!.value) {
                    return "Mật khẩu không trùng khớp";
                  } else {
                    return "";
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              const CustomTextLabel(
                'Thông tin cá nhân',
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: showPickImageOptions,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: ClipOval(
                          child: _image == null
                              ? Container(
                                  color: AppColors.gray,
                                  child: PhosphorIcon(
                                    size: 40,
                                    PhosphorIcons.user(),
                                    color: AppColors.white,
                                  ))
                              : Image.file(
                                  _image!,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[200],
                                    );
                                  },
                                ),
                        ),
                      ),
                      Positioned(
                          bottom: 5,
                          child: ClipOval(
                            child: Container(
                              width: 25,
                              height: 25,
                              color: AppColors.black,
                              child: const Icon(
                                size: 15,
                                Icons.camera_alt,
                                color: AppColors.white,
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              CustomTextInput(
                key: _keyName,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.white, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.white, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: "Họ và tên",
                validator: (String value) {
                  if (value.isEmpty) {
                    return "Họ và tên không được để trống";
                  }
                },
              ),
              const SizedBox(
                height: 15,
              ),
              CustomTextInput(
                key: _keyDateOfBirth,
                isDateTimeTF: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.white, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.white, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: "Ngày sinh",
              ),
              const SizedBox(
                height: 15,
              ),
              CustomTextInput(
                key: _keyPhone,
                keyboardType: TextInputType.phone,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.white, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.white, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: "Số điện thoại",
                validator: (String value) {
                  if (!Common.validatePhone(value)) {
                    return "Vui lòng nhập đúng định dạng số điện thoại";
                  } else {
                    return "";
                  }
                },
              ),
              const SizedBox(
                height: 15,
              ),
              CustomTextInput(
                key: _keyGrade,
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
                dropdownItems: [
                  DropdownItem(id: 1, value: 'Lớp 1'),
                  DropdownItem(id: 2, value: 'Lớp 2'),
                  DropdownItem(id: 3, value: 'Lớp 3'),
                  DropdownItem(id: 4, value: 'Lớp 4'),
                  DropdownItem(id: 5, value: 'Lớp 5')
                ],
              ),
              BlocListener<UploadFileCubit, BaseState>(
                listener: (_, state) {
                  if (state is LoadedState<UploadFileModel>) {
                    imageUrl = state.data.path;
                  }
                },
                child: Container(),
              ),
              BlocListener<SignupCubit, BaseState>(
                listener: (_, state) {
                  if (state is LoadedState<bool>) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomDialog(
                          content: 'Đăng ký thành công',
                          onSubmit: () {
                            Navigator.pushNamedAndRemoveUntil(context, Routes.loginScreen, (route) => false);
                          }
                        );
                      }
                    );
                  }
                },
                child: Container(),
              ),
            ],
          ),
        ),
      ),
      bottomBar: BottomAppBar(
        height: 70,
        color: AppColors.background_white,
        child: BaseButton(
          title: 'Đăng ký',
          gradient: AppColors.base_gradient_1,
          borderRadius: 20,
          onTap: () {
            if (_keyEmail.currentState!.isValid == true &&
                _keyConfirmPassword.currentState!.isValid == true &&
                _keyName.currentState!.isValid == true &&
                _keyGrade.currentState!.selectedDropdownItem!.value.isNotEmpty) {
              SignupModel model = SignupModel(
                email: _keyEmail.currentState!.value,
                password: _keyConfirmPassword.currentState!.value,
                avatarUrl: imageUrl ?? '',
                fullName: _keyName.currentState!.value,
                birthDate: Common.convertDateToIsoFormat(_keyDateOfBirth.currentState!.value),
                phoneNumber: _keyPhone.currentState?.value ?? '',
                grade: _keyGrade.currentState!.selectedDropdownItem!.id);
              context.read<SignupCubit>().doSignup(model);
            }
          },
        ),
      ),
    );
  }
}
