import 'package:quiz_app/data/models/question.dart';
import 'package:quiz_app/data/web_services/quiz_service.dart';

class QuizRepositiory {
  QuizSercive quizSercive;
  QuizRepositiory(this.quizSercive);
  Map<int, double> questionsGrade = {};

  Future<List<Question>> getQuestions(
      {String category = '',
      String difficulty = '',
      String limit = '10'}) async {
    final questions = await quizSercive.getQuestions(
        category: category, difficulty: difficulty, limit: limit);
    return questions.map((question) => Question.fromJson(question)).toList();
  }

  Map<int, double> getQuestionsGrade(List<Question> questions) {
    for (int i = 0; i < questions.length; i++) {
      questionsGrade.addAll({i + 1: questions[i].calcQuestionGrade()});
    }
    return questionsGrade;
  }

  double claculateScore(Map<int, double> questionsGrade) {
    double grades = 0;
    double score = 0;
    questionsGrade.forEach(
      (key, value) {
        grades += value;
      },
    );
    if (grades < 0) {
      grades = 0;
    }
    score = (grades / questionsGrade.length) * 100;
    return score;
  }

  int getNumberOfCorrectAnswers(Map<int, double> questionsGrade) {
    int correctAnswers = 0;
    questionsGrade.forEach(
      (key, value) {
        if (value == 1) {
          correctAnswers++;
        }
      },
    );
    return correctAnswers;
  }
}
