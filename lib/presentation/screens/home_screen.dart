import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/business_logic/cubit/quiz_cubit.dart';
import 'package:quiz_app/constants/quiz_constants.dart';
import 'package:quiz_app/data/repositories/quiz_repo.dart';
import 'package:quiz_app/data/web_services/quiz_service.dart';
import 'package:quiz_app/presentation/screens/quiz_screen.dart';
import 'package:quiz_app/presentation/widgets/custom_NextButton.dart';
import 'package:quiz_app/presentation/widgets/custom_drobdown.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String category = 'Any Category';
  String level = 'Any Difficulty';
  String limit = '10';
  String timer = 'OFF';
  // test area

  // test area
  @override
  Widget build(BuildContext context) {
    var quizSercive = QuizSercive();
    var quizRepositiory = QuizRepositiory(quizSercive);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 60,
                ),
                Image.asset(
                  'assets/images/q3.png',
                  scale: 7,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Computer Science \nQuiz',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 30,
                ),
                customDropdownWidget(
                  title: 'Category',
                  value: category,
                  items: categorys,
                  onChanged: onCategoryChanged,
                  context: context,
                ),
                // const SizedBox(
                //   height: 5,
                // ),
                customDropdownWidget(
                  title: 'Difficulty',
                  value: level,
                  items: levels,
                  onChanged: onDifficultyChanged,
                  context: context,
                ),
                // const SizedBox(
                //   height: 5,
                // ),
                customDropdownWidget(
                  title: 'Number of questions',
                  value: limit.toString(),
                  items: limits,
                  onChanged: onLimitChanged,
                  context: context,
                ),
                // const SizedBox(
                //   height: 5,
                // ),
                customDropdownWidget(
                  title: 'Timer in minutes',
                  value: timer.toString(),
                  items: minutes,
                  onChanged: onTimerChanged,
                  context: context,
                ),
                const SizedBox(
                  height: 50,
                ),
                BlocProvider(
                  create: (context) => QuizCubit(quizRepositiory),
                  child: BlocConsumer<QuizCubit, QuizState>(
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: state is QuizDataLoadingState
                            ? const CircularProgressIndicator(
                                color: Colors.black,
                              )
                            : customNextButton(
                                title: 'Start',
                                onPressed: () {
                                  var snackBar = SnackBar(
                                    elevation: 0,
                                    padding: const EdgeInsets.only(
                                        bottom: 350, top: 100),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    content: AwesomeSnackbarContent(
                                      title: 'Remember !',
                                      message: '  Each mistake cost -0.5',
                                      contentType: ContentType.warning,
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);

                                  Timer(const Duration(seconds: 3), () {
                                    BlocProvider.of<QuizCubit>(context)
                                        .getQuestions(
                                            category: category,
                                            difficulty: level,
                                            limit: limit);
                                  });
                                }),
                      );
                    },
                    listener: (context, state) {
                      if (state is QuizDataLoadedState) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizScreen(
                                questions: state.questions,
                                timer: timer,
                              ),
                            ));
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onCategoryChanged(value) {
    setState(() {
      category = value.toString();
    });
  }

  void onDifficultyChanged(value) {
    setState(() {
      level = value.toString();
    });
  }

  void onLimitChanged(value) {
    setState(() {
      limit = value;
    });
  }

  void onTimerChanged(value) {
    setState(() {
      timer = value;
    });
  }
}
