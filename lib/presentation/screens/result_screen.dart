import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/business_logic/cubit/quiz_cubit.dart';
import 'package:quiz_app/data/models/question.dart';
import 'package:quiz_app/data/repositories/quiz_repo.dart';
import 'package:quiz_app/data/web_services/quiz_service.dart';
import 'package:quiz_app/presentation/screens/quiz_review_screen.dart';
import 'package:quiz_app/presentation/widgets/custom_NextButton.dart';

class ResultScreen extends StatelessWidget {
  ResultScreen({
    Key? key,
    required this.questions,
  }) : super(key: key);
  List<Question> questions;
  late Map<int, double> questionsGrade;
  double score = 0;
  int correctAnswers = 0;
  String congratsWord = '';
  Color scoreColor = Colors.greenAccent;
  String scoreImage = '';

  @override
  Widget build(BuildContext context) {
    var quizSercive = QuizSercive();
    var quizRepositiory = QuizRepositiory(quizSercive);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Column(
          children: [
            const Expanded(flex: 2, child: SizedBox()),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: BlocProvider(
                    create: (context) => QuizCubit(quizRepositiory),
                    child: BlocBuilder<QuizCubit, QuizState>(
                      builder: (context, state) {
                        QuizCubit cubit = BlocProvider.of<QuizCubit>(context);
                        score = cubit.claculateScore(questions);
                        correctAnswers =
                            cubit.getNumberOfCorrectAnswers(questionsGrade);
                        if (score > 75) {
                          scoreColor = Colors.greenAccent;
                          congratsWord = 'Congrats !';
                          scoreImage = 'assets/images/congrats.gif';
                        } else if (score >= 50) {
                          scoreColor = Colors.amber;
                          congratsWord = 'Passed';
                          scoreImage = 'assets/images/success.gif';
                        } else {
                          scoreColor = Colors.red;
                          congratsWord = 'Failed';
                          scoreImage = 'assets/images/fail.gif';
                        }
                        return Column(
                          children: [
                            Image.asset(
                              scoreImage,
                              scale: 3,
                            ),
                            Text(
                              congratsWord,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              score > 0
                                  ? '${score.toStringAsFixed(2)}% Score'
                                  : '0% Score',
                              style: TextStyle(
                                  color: scoreColor,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Quiz completed successfully,',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'You attempt ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '${questions.length} questions',
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$correctAnswers answers ',
                                  style: TextStyle(
                                      color: scoreColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                const Text(
                                  'is correct',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                width: 200,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12)),
                                child: customNextButton(
                                    title: 'Preview',
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                QuizReviewScreen(
                                                    questions: questions),
                                          ));
                                    })),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const Expanded(flex: 2, child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
