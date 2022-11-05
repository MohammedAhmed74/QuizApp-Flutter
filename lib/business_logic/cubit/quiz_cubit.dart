import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/data/models/question.dart';
import 'package:quiz_app/data/repositories/quiz_repo.dart';
part 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizRepositiory quizRepositiory;
  QuizCubit(this.quizRepositiory) : super(QuizInitialState());

  void getQuestions(
      {String category = '',
      String difficulty = '',
      String limit = '10'}) async {
    emit(QuizDataLoadingState());
    await quizRepositiory
        .getQuestions(category: category, difficulty: difficulty, limit: limit)
        .then((questions) => {
              if (questions.isNotEmpty)
                {emit(QuizDataLoadedState(questions: questions))}
            });
  }

  Map<int, double> getQuestionsGrade(List<Question> questions) {
    return quizRepositiory.getQuestionsGrade(questions);
  }

  double claculateScore(List<Question> questions) {
    return quizRepositiory.claculateScore(getQuestionsGrade(questions));
  }

  int getNumberOfCorrectAnswers(Map<int, double> questionsGrade) {
    return quizRepositiory.getNumberOfCorrectAnswers(questionsGrade);
  }

  bool isCorrectButNotSelected(
      {required String isSelected,
      required String isCorrect,
      required bool isMultiAnswers}) {
    if (isSelected == 'false' && isCorrect == 'true' && isMultiAnswers) {
      return true;
    }
    return false;
  }

  bool isCorrectButNoSelectedAnswer(
      {required String isCorrect, required bool noAnswer}) {
    if (isCorrect == 'true' && noAnswer) {
      return true;
    }
    return false;
  }

  bool isNotCorrectButSelected({
    required String isCorrect,
    required String isSelected,
  }) {
    if (isCorrect != 'true' && isSelected == 'true') {
      return true;
    }
    return false;
  }

  Color getAnswerColor(Question question, int index) {
    Color answerColor;
    if (question.correctAnswers[index] == 'true') {
      answerColor = Colors.greenAccent;
    } else if (isNotCorrectButSelected(
        isCorrect: question.correctAnswers[index],
        isSelected: question.selectedAnswers[index])) {
      answerColor = Colors.amber.withOpacity(0.6);
    } else {
      return Colors.white;
    }
    return answerColor;
  }

  bool isMissedAnswer(Question question, int index) {
    if (isCorrectButNotSelected(
            isSelected: question.selectedAnswers[index],
            isCorrect: question.correctAnswers[index],
            isMultiAnswers: question.multipleCorrectAnswers!) ||
        isCorrectButNoSelectedAnswer(
            isCorrect: question.correctAnswers[index],
            noAnswer: question.noAnswer)) {
      return true;
    }
    return false;
  }
}
