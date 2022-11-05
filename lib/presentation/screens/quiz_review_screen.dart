
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/business_logic/cubit/quiz_cubit.dart';
import 'package:quiz_app/data/models/question.dart';
import 'package:quiz_app/data/repositories/quiz_repo.dart';
import 'package:quiz_app/data/web_services/quiz_service.dart';
import 'package:quiz_app/presentation/screens/home_screen.dart';
import 'package:quiz_app/presentation/widgets/custom_NextButton.dart';

class QuizReviewScreen extends StatefulWidget {
  QuizReviewScreen({
    Key? key,
    required this.questions,
  }) : super(key: key);
  List<Question> questions;
  Map<int, double> questionsGrade = {};
  @override
  State<QuizReviewScreen> createState() => _QuizReviewScreenState();
}

class _QuizReviewScreenState extends State<QuizReviewScreen> {
  int currentQuestionNumber = 0;
  var questionsViewCtrl = PageController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              if (currentQuestionNumber > 0) {
                setState(() {
                  currentQuestionNumber--;
                  questionsViewCtrl.previousPage(
                      duration: const Duration(milliseconds: 20),
                      curve: Curves.fastOutSlowIn);
                });
              }
            },
          ),
          title: Row(
            children: [
              Image.asset(
                widget.questions[currentQuestionNumber].selectedAnswers
                        .contains('true')
                    ? 'assets/images/q2.png'
                    : 'assets/images/q1.png',
                scale: 18,
                color: Colors.white,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                'Question number - ${currentQuestionNumber + 1} -',
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
          actions: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: InkWell(
                  onDoubleTap: () {
                    widget.questionsGrade = {};
                    widget.questions = [];
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ));
                  },
                  onTap: () {
                    Fluttertoast.showToast(
                        msg: "Douple press for remake..",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.green,
                        textColor: Colors.black,
                        fontSize: 16.0);
                  },
                  child: const Icon(
                    Icons.restart_alt,
                    size: 30,
                  ),
                )),
          ],
        ),
        body: PageView.builder(
          physics: const BouncingScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              currentQuestionNumber = index;
            });
          },
          controller: questionsViewCtrl,
          itemBuilder: (context, index) =>
              buildQuestionWidget(widget.questions[index], index),
          itemCount: widget.questions.length,
        ),
      ),
    );
  }

  Widget buildQuestionWidget(Question question, int questionIndex) {
    var quizSercive = QuizSercive();
    var quizRepositiory = QuizRepositiory(quizSercive);
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            question.text,
            style: const TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 60,
          ),
          Expanded(
            child: BlocProvider(
              create: (context) => QuizCubit(quizRepositiory),
              child: BlocBuilder<QuizCubit, QuizState>(
                builder: (context, state) {
                  QuizCubit cubit = BlocProvider.of<QuizCubit>(context);
                  return ListView.separated(
                      itemBuilder: (context, index) {
                        Color answerColor =
                            cubit.getAnswerColor(question, index);
                        if (cubit.isMissedAnswer(question, index)) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 10, bottom: 3),
                                child: Text(
                                  'Missed',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              answerWidget(
                                  question.answers[index], answerColor),
                            ],
                          );
                        }
                        return answerWidget(
                            question.answers[index], answerColor);
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 15,
                          ),
                      itemCount: question.answers.length);
                },
              ),
            ),
          ),
          if (questionIndex != widget.questions.length - 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: customNextButton(
                  title: 'Next',
                  onPressed: () {
                    setState(() {
                      currentQuestionNumber++;
                      questionsViewCtrl.nextPage(
                          duration: const Duration(milliseconds: 20),
                          curve: Curves.fastOutSlowIn);
                    });
                  }),
            ),
          if (questionIndex == widget.questions.length - 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: customNextButton(
                  title: 'Result',
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  }),
            ),
        ],
      ),
    );
  }

  Widget answerWidget(
    String answer,
    Color answerColor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: answerColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Text(
          answer,
          style: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
