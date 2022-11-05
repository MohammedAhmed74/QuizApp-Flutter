import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/data/models/question.dart';
import 'package:quiz_app/presentation/screens/home_screen.dart';
import 'package:quiz_app/presentation/screens/result_screen.dart';
import 'package:quiz_app/presentation/widgets/custom_NextButton.dart';
import 'package:slide_countdown/slide_countdown.dart';

class QuizScreen extends StatefulWidget {
  QuizScreen({
    Key? key,
    required this.questions,
    required this.timer,
  }) : super(key: key);
  List<Question> questions;
  String timer;
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
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
                  //remake
                  onDoubleTap: () {
                    widget.questions = [];
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ));
                  },
                  //warning before remake
                  onTap: () {
                    var snackBar = SnackBar(
                      elevation: 0,
                      padding: const EdgeInsets.only(bottom: 100, top: 100),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'Remake ??',
                        message: '  Douple press please..',
                        contentType: ContentType.help,
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: const Icon(
                    Icons.restart_alt,
                    size: 30,
                  ),
                )),
          ],
        ),
        body: Column(
          children: [
            Container(
              color: Colors.black,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    //            Category & Difficulty
                    Text(
                      '${widget.questions[currentQuestionNumber].category}  -  ${widget.questions[currentQuestionNumber].difficulty}',
                      style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    const Spacer(),

                    //              Timer
                    if (widget.timer == 'OFF')
                      const Text(
                        'OFF',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w400),
                      ),
                    if (widget.timer != 'OFF')
                      SlideCountdown(
                        onDone: () {
                          setState(() {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResultScreen(
                                      questions: widget.questions,
                                      ),
                                ));
                          });
                        },
                        duration: Duration(minutes: int.parse(widget.timer)),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Icon(
                        Icons.watch_later,
                        color: Colors.grey[400],
                      ),
                    )
                  ],
                ),
              ),
            ),
            //                         Question & Answers
            Expanded(
              child: PageView.builder(
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
          ],
        ),
      ),
    );
  }

  Widget buildQuestionWidget(Question question, int questionIndex) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
      child: Column(
        children: [
          const SizedBox(
            height: 5,
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
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        widget.questions[questionIndex].selectAnswer(index);
                      });
                    },
                    child: answerWidget(question.answers[index], index,
                        question.selectedAnswers),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                      height: 15,
                    ),
                itemCount: question.answers.length),
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
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultScreen(
                                questions: widget.questions,
                                ),
                          ));
                    });
                  }),
            ),
        ],
      ),
    );
  }

  Widget answerWidget(
    String answer,
    int index,
    List<String> selectedAnswers,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: selectedAnswers[index] == 'true'
            ? Colors.amber.withOpacity(0.3)
            : Colors.white,
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
