import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/res/colors.dart';
import 'package:ottstudy/ui/widget/base_network_image.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';
import 'package:ottstudy/ui/widget/custom_text_label.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../blocs/base_bloc/timer_state.dart';
import '../../../blocs/timer_cubit.dart';
import '../../../util/common.dart';
import '../../widget/base_button.dart';

class QuizQuestion {
  final String questionUrl;
  final List<String> answersUrl;
  int? selectedAnswer;

  QuizQuestion({
    required this.questionUrl,
    required this.answersUrl,
    this.selectedAnswer,
  });
}

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimerCubit(initialTime: 36)..startTimer(),
      child: QuizBody(),
    );
  }
}

class QuizBody extends StatefulWidget {
  const QuizBody({super.key});

  @override
  State<QuizBody> createState() => _QuizBodyState();
}

class _QuizBodyState extends State<QuizBody> {
  int currentQuestionIndex = 0;
  List<QuizQuestion> questions = [
    QuizQuestion(
      questionUrl: 'https://img.loigiaihay.com/picture/2024/0201/20_22.png',
        answersUrl: [
        'https://www.vietjack.com/toan-5-kn/images/trac-nghiem-chia-so-do-thoi-gian-voi-mot-so-1.PNG',
        'https://www.vietjack.com/toan-5-kn/images/trac-nghiem-chia-so-do-thoi-gian-voi-mot-so-1.PNG',
        'https://www.vietjack.com/toan-5-kn/images/trac-nghiem-chia-so-do-thoi-gian-voi-mot-so-1.PNG',
        'https://www.vietjack.com/toan-5-kn/images/trac-nghiem-chia-so-do-thoi-gian-voi-mot-so-1.PNG',
      ]
    ),
    QuizQuestion(
      questionUrl: 'https://img.loigiaihay.com/picture/2024/0201/20_22.png',
        answersUrl: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQtnAHUu2JuKIhFsahwCakJ20WmS-MtGE34jA&s',
        'https://www.vietjack.com/toan-5-kn/images/trac-nghiem-chia-so-do-thoi-gian-voi-mot-so-1.PNG',
        'https://www.vietjack.com/toan-5-kn/images/trac-nghiem-chia-so-do-thoi-gian-voi-mot-so-1.PNG',
        'https://www.vietjack.com/toan-5-kn/images/trac-nghiem-chia-so-do-thoi-gian-voi-mot-so-1.PNG',
      ]
    ),
  ];

  int answeredQuestions = 0;

  void goToQuestion(int index) {
    setState(() {
      currentQuestionIndex = index;
    });
  }

  void selectOption(int index) {
    setState(() {
      if (questions[currentQuestionIndex].selectedAnswer == null) {
        answeredQuestions ++;
      }
      questions[currentQuestionIndex].selectedAnswer = index;
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

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Bài kiểm tra 02',
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
            const SizedBox(height: 20),
            answerOptions(),
            BlocListener<TimerCubit, TimerState>(
              listenWhen: (previous, current) => !previous.isTimeUp && current.isTimeUp,
              listener: (context, state) {
                if (state.isTimeUp) {
                  //Todo: when time up
                }
              },
              child: const SizedBox.shrink(),
            )
          ],
        ),
      ),
      bottomBar: BottomAppBar(
        color: AppColors.white,
        height: 150,
        child: bottomAppBar()
      ),
    );
  }

  Widget questionList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: questions.length,
        itemBuilder: (context, index) {
          bool isSelected = index == currentQuestionIndex;
          bool isAnswered = questions[index].selectedAnswer != null;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () => goToQuestion(index),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: isSelected ? AppColors.base_gradient_1 : null,
                  color: !isSelected ? AppColors.white : null,
                  border: isAnswered
                      ? Border.all(color: AppColors.base_pink, width: 1)
                      : null,
                ),
                child: Center(
                  child: CustomTextLabel(
                    'Câu ${index + 1}',
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget questionContent() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: BaseNetworkImage(
        url: questions[currentQuestionIndex].questionUrl,
      ),
    );
  }

  Widget answerOptions() {
    return Column(
      children: List.generate(4, (index) {
        String option = String.fromCharCode(65 + index);
        int? answerSelected = questions[currentQuestionIndex].selectedAnswer;

        return InkWell(
          onTap: () => selectOption(index),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: answerSelected == index
                  ? AppColors.base_gradient_1
                  : null,
              color: answerSelected == index ? null : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.gray_border,
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextLabel(
                  option,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: answerSelected == index ? AppColors.white : AppColors.black,
                ),
                SizedBox(width: 15,),
                Expanded(
                  child: BaseNetworkImage(
                    url: questions[currentQuestionIndex].answersUrl[index],
                  ),
                )
              ],
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
                      'Thời gian còn lại: ${Common.formatTimeGps(state.timeLeft)}',
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
                    ),
                    const SizedBox(width: 20),
                    BaseButton(
                      child: const Icon(Icons.arrow_forward, color: AppColors.white),
                      onTap: nextQuestion,
                      gradient: AppColors.base_gradient_1,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: state.timeLeft / state.totalTime,
                      minHeight: 48,
                      backgroundColor: AppColors.gray_border,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.base_blue),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: BaseButton(
                    onTap: () {},
                    gradient: AppColors.base_gradient_2,
                    borderRadius: 20,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextLabel(
                          'Nộp bài',
                          color: AppColors.white,
                        ),
                        Icon(Icons.arrow_forward_rounded, color: Colors.white),
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
