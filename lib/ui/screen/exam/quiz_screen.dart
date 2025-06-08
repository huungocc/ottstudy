import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/registration/update_test_cubit.dart';
import 'package:ottstudy/res/colors.dart';
import 'package:ottstudy/ui/widget/base_network_image.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';
import 'package:ottstudy/ui/widget/common_widget.dart';
import 'package:ottstudy/ui/widget/custom_text_label.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../blocs/base_bloc/timer_state.dart';
import '../../../blocs/question/list_question_cubit.dart';
import '../../../blocs/test/test_info_cubit.dart';
import '../../../blocs/timer_cubit.dart';
import '../../../blocs/base_bloc/base_state.dart';
import '../../../data/models/question_model.dart';
import '../../../data/models/test_model.dart';
import '../../../util/common.dart';
import '../../widget/base_button.dart';
import '../../widget/base_progress_indicator.dart';
import '../../widget/custom_dialog.dart';

class QuizScreen extends StatelessWidget {
  final TestModel? arg;

  const QuizScreen({Key? key, this.arg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TestInfoCubit(),
        ),
        BlocProvider(
          create: (context) => ListQuestionCubit(),
        ),
        BlocProvider(
          create: (context) => UpdateTestCubit(),
        )
      ],
      child: QuizBody(arg: arg),
    );
  }
}

class QuizBody extends StatefulWidget {
  final TestModel? arg;

  const QuizBody({Key? key, this.arg}) : super(key: key);

  @override
  State<QuizBody> createState() => _QuizBodyState();
}

class _QuizBodyState extends State<QuizBody> {
  int currentQuestionIndex = 0;
  List<QuestionModel> questions = [];
  TestModel? testInfo;
  TimerCubit? timerCubit;

  int answeredQuestions = 0;
  Map<int, String> userAnswers = {};
  bool isQuizStarted = false;
  bool isQuizFinished = false;

  @override
  void initState() {
    super.initState();
    _loadTestInfo();
  }

  @override
  void dispose() {
    timerCubit?.close();
    super.dispose();
  }

  void _loadTestInfo() {
    context.read<TestInfoCubit>().testInfo({
      'id': widget.arg!.id,
    });
  }

  void _loadQuestions(List<String> questionIds) {
    context.read<ListQuestionCubit>().getListQuestion({
      'questionIds': questionIds,
    });
  }

  void _showReadyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonWidget.studentInfoText(title: 'Số câu hỏi: ', value: '${questions.length}'),
              CommonWidget.studentInfoText(title: 'Thời gian: ', value: '${testInfo?.time} phút'),
              CommonWidget.studentInfoText(title: 'Điểm yêu cầu: ', value: '${testInfo?.minimumScore}'),
              if (widget.arg!.isFinalTest == true && widget.arg!.finalTestStatus == true)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomTextLabel(
                  'Lưu ý: Bạn đã làm bài kiểm tra này trước đây. Kết quả mới sẽ không được tính.',
                  fontStyle: FontStyle.italic,
                ),
              )
            ],
          ),
          titleSubmit: 'Bắt đầu',
          onSubmit: () {
            Navigator.of(context).pop();
            _startQuiz();
          },
          hasCloseButton: true,
          onClose: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _startQuiz() {
    setState(() {
      isQuizStarted = true;
    });
    timerCubit = TimerCubit(initialTime: (testInfo?.time ?? 30) * 60);
    timerCubit?.startTimer();
  }

  void goToQuestion(int index) {
    setState(() {
      currentQuestionIndex = index;
    });
  }

  void selectOption(String selectedAnswer) {
    if (isQuizFinished) return;

    setState(() {
      if (!userAnswers.containsKey(currentQuestionIndex)) {
        answeredQuestions++;
      }
      userAnswers[currentQuestionIndex] = selectedAnswer;
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      goToQuestion(currentQuestionIndex + 1);
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex > 0) {
      goToQuestion(currentQuestionIndex - 1);
    }
  }

  void submitQuiz() {
    timerCubit?.stopTimer();

    setState(() {
      isQuizFinished = true;
    });

    int correctAnswers = 0;
    for (int i = 0; i < questions.length; i++) {
      if (userAnswers[i] == questions[i].answer) {
        correctAnswers++;
      }
    }

    double score = (correctAnswers / questions.length * 10);
    bool isPassed = score >= (testInfo?.minimumScore ?? 0);

    if (isPassed && widget.arg!.isFinalTest == true && widget.arg!.finalTestStatus == false) {
      context.read<UpdateTestCubit>().approveRegistration({
        'registration_id': widget.arg!.registrationId,
        'final_test_score': score,
        'final_test_passed': true
      });
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialog(
          content: Column(
            children: [
              CustomTextLabel(isPassed ? 'Chúc mừng!' : 'Kết quả bài kiểm tra', fontSize: 20, fontWeight: FontWeight.bold,),
              const SizedBox(height: 20,),
              CommonWidget.studentInfoText(title: 'Số câu đúng: ', value: '$correctAnswers/${questions.length}'),
              CommonWidget.studentInfoText(title: 'Điểm số: ', value: '${score.toStringAsFixed(1)}/10'),
              CommonWidget.studentInfoText(title: 'Điểm yêu cầu: ', value: '${testInfo?.minimumScore}'),
              CustomTextLabel(
                isPassed ? 'Bạn đã đạt yêu cầu!' : 'Bạn chưa đạt yêu cầu.',
                color: isPassed ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          titleSubmit: 'Đóng',
          onSubmit: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  bool isAnswerCorrect(int questionIndex) {
    if (!isQuizFinished) return false;
    return userAnswers[questionIndex] == questions[questionIndex].answer;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TestInfoCubit, BaseState>(
          listener: (context, state) {
            if (state is LoadedState<TestModel>) {
              testInfo = state.data;
              if (testInfo?.questions != null && testInfo!.questions!.isNotEmpty) {
                _loadQuestions(testInfo!.questions!);
              }
            }
          },
        ),
        BlocListener<ListQuestionCubit, BaseState>(
          listener: (context, state) {
            if (state is LoadedState<List<QuestionModel>>) {
              setState(() {
                questions = state.data;
              });
              _showReadyDialog();
            }
          },
        ),
      ],
      child: BlocBuilder<TestInfoCubit, BaseState>(
        builder: (context, testInfoState) {
          return BlocBuilder<ListQuestionCubit, BaseState>(
            builder: (context, questionState) {
              if (testInfoState is LoadingState || questionState is LoadingState) {
                return const BaseScreen(
                  title: 'Bài kiểm tra',
                  body: Center(
                    child: BaseProgressIndicator(color: AppColors.black,),
                  ),
                );
              }

              if (!isQuizStarted) {
                return const BaseScreen(
                  title: 'Bài kiểm tra',
                  body: Center(
                    child: CustomTextLabel('Đang chuẩn bị bài kiểm tra...'),
                  ),
                );
              }

              if (questions.isEmpty) {
                return const BaseScreen(
                  title: 'Bài kiểm tra',
                  body: Center(
                    child: CustomTextLabel('Không có câu hỏi nào'),
                  ),
                );
              }

              return BlocProvider(
                create: (context) => timerCubit!,
                child: BaseScreen(
                  title: 'Bài kiểm tra',
                  colorBackground: AppColors.background_white,
                  rightWidgets: [
                    IconButton(
                      icon: PhosphorIcon(
                        PhosphorIcons.calculator(),
                        color: AppColors.black,
                      ),
                      onPressed: () {
                        Common.showCalculator(context);
                      },
                    )
                  ],
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        questionList(),
                        const SizedBox(height: 20),
                        questionContent(),
                        BlocListener<TimerCubit, TimerState>(
                          listenWhen: (previous, current) => !previous.isTimeUp && current.isTimeUp,
                          listener: (context, state) {
                            if (state.isTimeUp) {
                              submitQuiz();
                            }
                          },
                          child: const SizedBox.shrink(),
                        )
                      ],
                    ),
                  ),
                  bottomBar: BottomAppBar(
                      color: AppColors.white,
                      height: 230,
                      child: Column(
                        children: [
                          answerOptions(),
                          const SizedBox(height: 20),
                          bottomAppBar(),
                        ],
                      )
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget questionList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: questions.length,
        itemBuilder: (context, index) {
          bool isSelected = index == currentQuestionIndex;
          bool isAnswered = userAnswers.containsKey(index);

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () => goToQuestion(index),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: isSelected ? AppColors.base_gradient_1 : null,
                      color: !isSelected ? AppColors.white : null,
                      border: isAnswered
                          ? Border.all(color: AppColors.base_pink, width: 1)
                          : Border.all(color: Colors.grey.shade300), // Default border
                    ),
                    child: Center(
                      child: CustomTextLabel(
                        'Câu ${index + 1}',
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (isQuizFinished && isAnswered)
                    Positioned(
                      top: -6,
                      right: -6,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isAnswerCorrect(index) ? Colors.green : Colors.red,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          isAnswerCorrect(index) ? Icons.check : Icons.close,
                          color: Colors.white,
                          size: 10,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget questionContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: BaseNetworkImage(
        url: questions[currentQuestionIndex].questionImage ?? '',
        isFromDatabase: true
      ),
    );
  }

  Widget answerOptions() {
    final List<String> options = ['A', 'B', 'C', 'D'];
    String? selectedAnswer = userAnswers[currentQuestionIndex];
    String? correctAnswer = questions[currentQuestionIndex].answer;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(4, (index) {
        String option = options[index];
        bool isSelected = selectedAnswer == option;
        bool isCorrect = option == correctAnswer;
        bool showCorrectAnswer = isQuizFinished && isCorrect;

        return Expanded(
          child: AspectRatio(
            aspectRatio: 1.5,
            child: GestureDetector(
              onTap: () => selectOption(option),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColors.base_gradient_1 : null,
                  color: isSelected ? null : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: showCorrectAnswer
                        ? Colors.green
                        : AppColors.gray_border,
                    width: showCorrectAnswer ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: CustomTextLabel(
                    option,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? AppColors.white : AppColors.black,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget bottomAppBar() {
    return BlocBuilder<TimerCubit, TimerState>(
      builder: (context, state) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextLabel(
                      'Đã hoàn thành: $answeredQuestions/${questions.length}',
                      fontWeight: FontWeight.bold,
                    ),
                    CustomTextLabel(
                      isQuizFinished
                          ? 'Đã kết thúc bài kiểm tra'
                          : 'Thời gian còn lại: ${Common.formatTimeGps(state.timeLeft)}',
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BaseButton(
                      child: const Icon(Icons.arrow_back, color: AppColors.white),
                      onTap: previousQuestion,
                      gradient: AppColors.base_gradient_1,
                      borderRadius: 20,
                    ),
                    const SizedBox(width: 20),
                    BaseButton(
                      child: const Icon(Icons.arrow_forward, color: AppColors.white),
                      onTap: nextQuestion,
                      gradient: AppColors.base_gradient_1,
                      borderRadius: 20,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: isQuizFinished ? 0 : (state.timeLeft / state.totalTime),
                      minHeight: 48,
                      backgroundColor: AppColors.gray_border,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          isQuizFinished ? AppColors.gray_border : AppColors.base_blue
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: BaseButton(
                    isDisable: isQuizFinished,
                    onTap: submitQuiz,
                    gradient: AppColors.base_gradient_2,
                    borderRadius: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextLabel(
                          isQuizFinished ? 'Đã nộp' : 'Nộp bài',
                          color: isQuizFinished ? AppColors.gray_title : AppColors.white,
                        ),
                        Icon(
                            isQuizFinished ? Icons.check : Icons.arrow_forward_rounded,
                            color: isQuizFinished ? AppColors.gray_title : AppColors.white
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}