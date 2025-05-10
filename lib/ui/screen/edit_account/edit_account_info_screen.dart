import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ottstudy/blocs/auth/update_profile_cubit.dart';
import 'package:ottstudy/blocs/upload_file_cubit.dart';
import 'package:ottstudy/ui/widget/widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../blocs/auth/user_info_cubit.dart';
import '../../../blocs/base_bloc/base_state.dart';
import '../../../data/models/upload_file_model.dart';
import '../../../data/models/user_model.dart';
import '../../../res/colors.dart';
import '../../../util/common.dart';

class EditAccountInfoScreen extends StatelessWidget {
  const EditAccountInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => UpdateProfileCubit(),
          ),
          BlocProvider(
            create: (_) => UploadFileCubit(),
          ),
          BlocProvider(
            create: (_) => UserInfoCubit(),
          ),
        ],
        child: EditAccountInfoBody()
    );
  }
}

class EditAccountInfoBody extends StatefulWidget {
  const EditAccountInfoBody({super.key});

  @override
  State<EditAccountInfoBody> createState() => _EditAccountInfoBodyState();
}

class _EditAccountInfoBodyState extends State<EditAccountInfoBody> {
  final _keyName = GlobalKey<TextFieldState>();
  final _keyDateOfBirth = GlobalKey<TextFieldState>();
  final _keyPhone = GlobalKey<TextFieldState>();
  final _keyGrade = GlobalKey<TextFieldState>();

  File? _image;
  final picker = ImagePicker();
  String? imageUrl;
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    context.read<UserInfoCubit>().getUserInfo(null);
  }

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
      title: 'Thông tin cá nhân',
      colorBackground: AppColors.background_white,
      resizeToAvoidBottomInset: true,
      loadingWidget: Stack(
        children: [
          CustomLoading<UpdateProfileCubit>(),
          CustomLoading<UserInfoCubit>(),
          CustomLoading<UploadFileCubit>(),
        ],
      ),
      messageNotify: Stack(
        children: [
          CustomSnackBar<UpdateProfileCubit>(),
          CustomSnackBar<UserInfoCubit>(),
          CustomSnackBar<UploadFileCubit>(),
        ],
      ),
      body: BlocConsumer<UserInfoCubit, BaseState>(
        listener: (context, state) {
          if (state is LoadedState<UserModel>) {
            setState(() {
              userModel = state.data;
              imageUrl = userModel?.avatarUrl;
            });
          }
        },
        builder: (context, state) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 40),
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
                              child: BaseNetworkImage(
                                url: imageUrl,
                                width: 80,
                                height: 80,
                                boxFit: BoxFit.cover,
                                borderRadius: 100,
                                isFromDatabase: true,
                                errorBuilder: Container(
                                  color: AppColors.gray,
                                  child: PhosphorIcon(
                                    size: 40,
                                    PhosphorIcons.user(),
                                    color: AppColors.white,
                                  ),
                                ),
                              )
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                CustomTextInput(
                  key: _keyName,
                  isRequired: true,
                  initData: userModel?.fullName ?? '',
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
                      return "Vui lòng nhập họ và tên";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CustomTextInput(
                  key: _keyDateOfBirth,
                  isDateTimeTF: true,
                  initData: userModel != null ? Common.convertDateToFormat(
                    userModel!.birthDate,
                    inputFormat: 'yyyy-MM-ddTHH:mm:ss.SSS',
                    outputFormat: 'dd/MM/yyyy',
                  ) : '',
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
                const SizedBox(height: 15),
                CustomTextInput(
                  key: _keyPhone,
                  initData: userModel?.phoneNumber ?? '',
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
                    if (value.isNotEmpty && !Common.validatePhone(value)) {
                      return "Vui lòng nhập đúng định dạng số điện thoại";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CustomTextInput(
                  key: _keyGrade,
                  initData: userModel?.grade != null ? 'Lớp ${userModel!.grade!}' : '',
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
                  isRequired: true,
                  selectedDropdownItem: userModel?.grade != null
                      ? DropdownItem(id: userModel!.grade!, value: 'Lớp ${userModel!.grade!}')
                      : null,
                  dropdownItems: [
                    DropdownItem(id: 1, value: 'Lớp 1'),
                    DropdownItem(id: 2, value: 'Lớp 2'),
                    DropdownItem(id: 3, value: 'Lớp 3'),
                    DropdownItem(id: 4, value: 'Lớp 4'),
                    DropdownItem(id: 5, value: 'Lớp 5'),
                  ],
                ),
                BlocListener<UploadFileCubit, BaseState>(
                  listener: (_, state) {
                    if (state is LoadedState<UploadFileModel>) {
                      setState(() {
                        print(state.data.path);
                        imageUrl = state.data.path;
                      });
                    }
                  },
                  child: Container(),
                ),
                BlocListener<UpdateProfileCubit, BaseState>(
                  listener: (_, state) {
                    if (state is LoadedState<bool>) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomDialog(
                            content: 'Cập nhật thông tin thành công',
                            onSubmit: () {
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    }
                  },
                  child: Container(),
                ),
              ],
            ),
          );
        },
      ),
      bottomBar: BottomAppBar(
        color: AppColors.background_white,
        height: 70,
        child: BaseButton(
          title: 'Lưu',
          borderRadius: 20,
          onTap: () {
            if (_keyName.currentState?.isValid == true &&
                _keyGrade.currentState?.selectedDropdownItem != null &&
                _keyGrade.currentState!.selectedDropdownItem!.value.isNotEmpty) {
              _saveUserInfo();
            } else {
              CustomSnackBar.showMessage(context, mess: "Vui lòng nhập đầy đủ thông tin bắt buộc");
            }
          },
        ),
      ),
    );
  }

  void _saveUserInfo() {
    final selectedGrade = _keyGrade.currentState?.selectedDropdownItem;
    if (selectedGrade == null) {
      CustomSnackBar.showMessage(context, mess: "Vui lòng chọn lớp học");
      return;
    }

    String? birthDate;
    if (_keyDateOfBirth.currentState?.value != null && _keyDateOfBirth.currentState!.value.isNotEmpty) {
      birthDate = Common.convertDateToFormat(
          _keyDateOfBirth.currentState!.value,
          inputFormat: 'dd/MM/yyyy',
          outputFormat: 'yyyy-MM-dd'
      );
    }

    final updateData = {
      'full_name': _keyName.currentState!.value,
      'birth_date': birthDate,
      'phone_number': _keyPhone.currentState!.value,
      'grade': selectedGrade.id,
      'avatar_url': imageUrl ?? '',
    };

    context.read<UpdateProfileCubit>().updateProfile(updateData);
  }
}