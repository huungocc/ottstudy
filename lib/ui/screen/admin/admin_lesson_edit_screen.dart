import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ottstudy/blocs/lesson/create_lesson_cubit.dart';
import 'package:ottstudy/data/models/question_model.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../blocs/base_bloc/base_state.dart';
import '../../../blocs/delete_cubit.dart';
import '../../../blocs/question/create_question_cubit.dart';
import '../../../blocs/test/create_test_cubit.dart';
import '../../../blocs/upload_file_cubit.dart';
import '../../../data/models/lesson_model.dart';
import '../../../data/models/test_model.dart';
import '../../../data/models/upload_file_model.dart';
import '../../../res/colors.dart';
import '../../../util/constants.dart';
import '../../widget/base_button.dart';
import '../../widget/base_loading.dart';
import '../../widget/base_progress_indicator.dart';
import '../../widget/base_text_input.dart';
import '../../widget/common_widget.dart';
import '../../widget/custom_dialog.dart';
import '../../widget/custom_snack_bar.dart';
import '../../widget/custom_text_label.dart';

enum UploadType { lessonFile, questionImage }

class AdminLessonEditScreen extends StatelessWidget {
  const AdminLessonEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UploadFileCubit(),
        ),
        BlocProvider(
          create: (_) => CreateLessonCubit(),
        ),
        BlocProvider(
          create: (_) => CreateTestCubit(),
        ),
        BlocProvider(
          create: (_) => CreateQuestionCubit(),
        ),
        BlocProvider(
          create: (_) => DeleteCubit(),
        ),
      ],
      child: AdminLessonEditBody(),
    );
  }
}

class AdminLessonEditBody extends StatefulWidget {
  const AdminLessonEditBody({super.key});

  @override
  State<AdminLessonEditBody> createState() => _AdminLessonEditBodyState();
}

class _AdminLessonEditBodyState extends State<AdminLessonEditBody> {
  final _keyLessonName = GlobalKey<TextFieldState>();
  final _keyTestTime = GlobalKey<TextFieldState>();
  final _keyMinimumScore = GlobalKey<TextFieldState>();
  final _keyAnswer = GlobalKey<TextFieldState>();

  TestModel? testModel;
  List<QuestionModel>? questionList;

  File? _lessonFile;
  String? _lessonFileUrl;
  String? _lessonFileType;
  File? _questionImage;
  String? _questionImageUrl;
  UploadType? _currentUploadType;

  final picker = ImagePicker();

  String? selectedAnswer;

  bool _isAddTestModalOpen = false;
  bool _isAddQuestionModalOpen = false;

  void _onAddTest() {
    if (_isAddTestModalOpen) return;

    _isAddTestModalOpen = true;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: context.read<CreateTestCubit>(),
          ),
          BlocProvider.value(
            value: context.read<CreateQuestionCubit>(),
          ),
          BlocProvider.value(
            value: context.read<UploadFileCubit>(),
          ),
        ],
        child: AddTest(),
      ),
    ).whenComplete(() {
      if (mounted) {
        _isAddTestModalOpen = false;
      }
    });
  }

  void _onAddQuestion({Function()? onQuestionAdded}) {
    if (_isAddQuestionModalOpen) return;

    _isAddQuestionModalOpen = true;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: context.read<CreateQuestionCubit>(),
          ),
          BlocProvider.value(
            value: context.read<UploadFileCubit>(),
          ),
        ],
        child: AddQuestion(onQuestionAdded: onQuestionAdded),
      ),
    ).whenComplete(() {
      if (mounted) {
        _isAddQuestionModalOpen = false;
      }
    });
  }

  Future<void> pickLessonFile() async {
    _currentUploadType = UploadType.lessonFile;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'mp4', 'mov', 'avi', 'mkv'],
    );

    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      final extension = result.files.single.extension?.toLowerCase() ?? '';

      String fileType;
      if (extension == 'pdf') {
        fileType = 'pdf';
      } else if (['mp4', 'mov', 'avi', 'mkv'].contains(extension)) {
        fileType = 'video';
      } else {
        fileType = 'unknown';
      }

      setState(() {
        _lessonFile = File(path);
        _lessonFileType = fileType;
      });

      context.read<UploadFileCubit>().uploadFile(_lessonFile!);
    }
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
    _currentUploadType = UploadType.questionImage;
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _questionImage = File(pickedFile.path);
        context.read<UploadFileCubit>().uploadFile(_questionImage!);
      });
    }
  }

  Future getImageFromCamera() async {
    var status = await Permission.camera.status;

    if (status.isDenied) {
      status = await Permission.camera.request();
    }

    if (status.isGranted) {
      _currentUploadType = UploadType.questionImage;
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _questionImage = File(pickedFile.path);
          context.read<UploadFileCubit>().uploadFile(_questionImage!);
        });
      }
    } else if (status.isPermanentlyDenied) {
      CustomSnackBar.showMessage(context, mess: "Quyền truy cập camera bị từ chối");
    }
  }

  void _removeQuestion(int index) {
    if (mounted) {
      // Map<String, dynamic> body = {
      //   'id': questionList![index].id,
      //   'category': 'question'
      // };
      // context.read<DeleteCubit>().doDelete(body);
      questionList!.removeAt(index);
    }
  }

  void _removeTest() {
    if (mounted) {
      // Map<String, dynamic> body = {
      //   'id': testModel!.id,
      //   'category': 'test'
      // };
      // context.read<DeleteCubit>().doDelete(body);
      testModel = null;
      questionList?.clear();
    }
  }

  Future<void> _createLesson() async {
    if (_keyLessonName.currentState!.isValid == true && _lessonFileUrl != null && testModel != null) {
      final lesson = LessonModel(
        lessonName: _keyLessonName.currentState!.value,
        fileUrl: _lessonFileUrl,
        fileType: _lessonFileType,
        testId: testModel!.id,
      );

      context.read<CreateLessonCubit>().createLesson(lesson.toJson());
    }
  }

  Future<void> _createTest() async {
    if (_keyTestTime.currentState!.isValid == true &&
        _keyMinimumScore.currentState!.isValid == true &&
        questionList != null && questionList!.isNotEmpty) {
      final test = TestModel(
        time: int.tryParse(_keyTestTime.currentState!.value),
        minimumScore: double.tryParse(_keyMinimumScore.currentState!.value),
        questions: questionList!.map((q) => q.id!).toList(),
      );

      context.read<CreateTestCubit>().createTest(test.toJson());
    }
  }

  Future<void> _createQuestion() async {
    if (_keyAnswer.currentState!.isValid == true && _questionImageUrl != null) {
      final question = QuestionModel(
        questionImage: _questionImageUrl,
        answer: selectedAnswer,
      );

      context.read<CreateQuestionCubit>().createQuestion(question.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      colorBackground: AppColors.background_white,
      title: 'Tạo bài học',
      loadingWidget: Stack(
        children: [
          CustomLoading<UploadFileCubit>(),
          CustomLoading<CreateLessonCubit>(),
        ],
      ),
      messageNotify: Stack(
        children: [
          CustomSnackBar<UploadFileCubit>(),
          CustomSnackBar<CreateLessonCubit>(),
          CustomSnackBar<CreateTestCubit>(),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocListener<UploadFileCubit, BaseState>(
              listener: (_, state) {
                if (mounted) {
                  if (state is LoadedState<UploadFileModel>) {
                    setState(() {
                      if (_currentUploadType == UploadType.lessonFile) {
                        _lessonFileUrl = state.data.path;
                      } else if (_currentUploadType == UploadType.questionImage) {
                        _questionImageUrl = state.data.path;
                      }
                    });
                  }
                }
              },
              child: Container(),
            ),
            BlocListener<CreateLessonCubit, BaseState>(
              listener: (_, state) {
                if (mounted) {
                  if (state is LoadedState<LessonModel>) {
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return CustomDialog(
                          content: 'Tạo bài kiểm tra thành công',
                          onSubmit: () {
                            Navigator.pop(dialogContext);
                            Navigator.pop(context, state.data);
                          }
                        );
                      }
                    );
                    //Navigator.pop(context, lessonModel);
                  }
                }
              },
              child: Container(),
            ),
            const SizedBox(height: 20,),
            CustomTextInput(
              key: _keyLessonName,
              isRequired: true,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.white, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.white, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              hintText: "Tên bài học",
              validator: (String value) {
                if (value.isEmpty) {
                  return "Vui lòng nhập tên bài học";
                }
                return null;
              },
            ),
            const SizedBox(height: 20,),
            Row(
              children: [
                CommonWidget.addButton(
                    title: 'File bài học',
                    onTap: () {
                      pickLessonFile();
                    }
                ),
                const SizedBox(width: 10,),
                if (_lessonFileUrl != null && _lessonFileUrl!.isNotEmpty)
                Expanded(child: CustomTextLabel(_lessonFileUrl, maxLines: 2))
              ],
            ),
            const SizedBox(height: 20,),
            testModel != null
                ? Slidable(
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        _removeTest();
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Xoá',
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ],
                ),
                child: CommonWidget.testInfo(testModel!)
            )
                : CommonWidget.addButton(
                title: 'Bài kiểm tra',
                onTap: () {
                  _onAddTest();
                }
            )
          ],
        ),
      ),
      bottomBar: BottomAppBar(
        color: AppColors.background_white,
        height: 70,
        child: BaseButton(
          title: 'Tạo bài học',
          borderRadius: 20,
          onTap: _createLesson,
        ),
      ),
    );
  }

  Widget AddTest() {
    return StatefulBuilder(
        builder: (context, setTestState) {
          return Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.7,
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              color: AppColors.background_white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            constraints: BoxConstraints(
              maxWidth: double.infinity,
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: Column(
              children: [
                BlocListener<CreateTestCubit, BaseState>(
                  listener: (_, state) {
                    if (!mounted) return;

                    if (state is LoadingState) {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Center(
                              child: BaseProgressIndicator(),
                            );
                          }
                      );
                    }
                    if (state is LoadedState<TestModel>) {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                      if (mounted) {
                        setState(() {
                          testModel = state.data;
                        });
                      }
                      showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return CustomDialog(
                                content: 'Tạo bài kiểm tra thành công',
                                onSubmit: () {
                                  if (Navigator.canPop(dialogContext)) {
                                    Navigator.pop(dialogContext);
                                  }
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }
                                }
                            );
                          }
                      );
                    } else if (state is ErrorState) {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                      showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return CustomDialog(
                                content: 'Đã có lỗi xảy ra',
                                onSubmit: () {
                                  if (Navigator.canPop(dialogContext)) {
                                    Navigator.pop(dialogContext);
                                  }
                                }
                            );
                          }
                      );
                    }
                  },
                  child: Container(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextInput(
                          key: _keyTestTime,
                          keyboardType: TextInputType.number,
                          isRequired: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: AppColors.white, width: 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: AppColors.white, width: 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: "Thời gian làm bài (phút)",
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Vui lòng nhập thời gian";
                            }
                            final intValue = int.tryParse(value);
                            if (intValue == null) {
                              return "Vui lòng nhập số hợp lệ";
                            }
                            if (intValue <= 0 || intValue > 120) {
                              return "Thời gian phải từ 1 đến 120 phút";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10,),
                        CustomTextInput(
                          key: _keyMinimumScore,
                          keyboardType: TextInputType.number,
                          isRequired: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: AppColors.white, width: 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: AppColors.white, width: 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: "Điểm yêu cầu",
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Vui lòng nhập điểm yêu cầu";
                            }
                            final doubleValue = double.tryParse(value);
                            if (doubleValue == null) {
                              return "Vui lòng nhập số hợp lệ";
                            }
                            if (doubleValue < 0 || doubleValue > 10) {
                              return "Điểm phải từ 0 đến 10";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20,),
                        const CustomTextLabel('Danh sách câu hỏi', fontWeight:  FontWeight.bold,),
                        const SizedBox(height: 10,),
                        if (questionList != null && questionList!.isNotEmpty) ...[
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: questionList!.length,
                            itemBuilder: (context, index) {
                              final question = questionList![index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: Slidable(
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) {
                                          _removeQuestion(index);
                                          setTestState(() {}); // Cập nhật UI ngay khi xóa
                                        },
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Xoá',
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ],
                                  ),
                                  child: CommonWidget.questionInfo(question, order: index + 1),
                                ),
                              );
                            },
                          ),
                        ] else ...[
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.grey[300]!,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Center(
                              child: CustomTextLabel(
                                'Chưa có câu hỏi nào',
                                color: AppColors.gray_title,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        CommonWidget.addButton(
                          title: 'Thêm câu hỏi',
                          onTap: () {
                            // Truyền callback để cập nhật UI khi thêm câu hỏi thành công
                            _onAddQuestion(onQuestionAdded: () {
                              setTestState(() {}); // Cập nhật UI của AddTest modal
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                BaseButton(
                  margin: EdgeInsets.only(top: 20),
                  title: 'Tạo bài kiểm tra',
                  borderRadius: 20,
                  onTap: () {
                    if (questionList == null || questionList!.isEmpty) {
                      showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return CustomDialog(
                                content: 'Vui lòng thêm ít nhất 1 câu hỏi',
                                onSubmit: () {
                                  if (Navigator.canPop(dialogContext)) {
                                    Navigator.pop(dialogContext);
                                  }
                                }
                            );
                          }
                      );
                      return;
                    }
                    _createTest();
                  },
                ),
              ],
            ),
          );
        }
    );
  }

  Widget AddQuestion({Function()? onQuestionAdded}) {
    return StatefulBuilder(
        builder: (context, setQuestionState) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: const BoxDecoration(
              color: AppColors.background_white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocListener<UploadFileCubit, BaseState>(
                  listener: (_, state) {
                    if (!mounted) return;

                    if (_currentUploadType == UploadType.questionImage) {
                      if (state is LoadingState) {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return Center(
                                child: BaseProgressIndicator(),
                              );
                            }
                        );
                      }
                      if (state is LoadedState<UploadFileModel>) {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                        if (mounted) {
                          setQuestionState(() {
                            _questionImageUrl = state.data.path;
                          });
                        }
                      }
                    }
                  },
                  child: Container(),
                ),
                BlocListener<CreateQuestionCubit, BaseState>(
                  listener: (_, state) {
                    if (!mounted) return;

                    if (state is LoadingState) {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Center(
                              child: BaseProgressIndicator(),
                            );
                          }
                      );
                    }
                    if (state is LoadedState<QuestionModel>) {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                      if (mounted) {
                        if (questionList == null) {
                          questionList = [];
                        }

                        questionList!.add(state.data);

                        _questionImage = null;
                        _questionImageUrl = null;
                        selectedAnswer = null;

                        onQuestionAdded?.call();
                      }
                      showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return CustomDialog(
                                content: 'Tạo câu hỏi thành công',
                                onSubmit: () {
                                  if (Navigator.canPop(dialogContext)) {
                                    Navigator.pop(dialogContext);
                                  }
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }
                                }
                            );
                          }
                      );
                    } else if (state is ErrorState) {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialog(
                                content: 'Đã có lỗi xảy ra',
                                onSubmit: () {
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }
                                }
                            );
                          }
                      );
                    }
                  },
                  child: Container(),
                ),
                CommonWidget.addButton(
                    title: 'File câu hỏi',
                    onTap: () {
                      showPickImageOptions();
                    }
                ),
                const SizedBox(height: 10,),
                if (_questionImageUrl != null) ...[
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Expanded(
                          child: CustomTextLabel(
                            'Ảnh đã được tải lên',
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),
                ],
                CustomTextInput(
                  key: _keyAnswer,
                  isRequired: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.white, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.white, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: "Đáp án đúng",
                  isDropdownTF: true,
                  dropdownItems: Constants.answer,
                  onDropdownChanged: (value) {
                    selectedAnswer = value!.value;
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Vui lòng chọn đáp án";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10,),
                BaseButton(
                  margin: EdgeInsets.only(top: 20),
                  title: 'Tạo câu hỏi',
                  borderRadius: 20,
                  onTap: _createQuestion,
                ),
              ],
            ),
          );
        }
    );
  }
}