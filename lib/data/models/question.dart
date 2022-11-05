class Question {
  late int id;
  late String text;
  late Map<String, dynamic> answersMap;
  late List<String> answers = [];
  late List<String> correctAnswers = [];
  bool? multipleCorrectAnswers;
  late String? correctAnswer;
  late String category;
  late String difficulty;
  late List<String> selectedAnswers = [];
  bool noAnswer = true;
  Question({
    required this.id,
    required this.text,
    required this.answersMap,
    required this.correctAnswers,
    required this.multipleCorrectAnswers,
    required this.correctAnswer,
    required this.category,
    required this.difficulty,
  });
  Question.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['question'];
    answersMap = json['answers'];
    category = json['category'];
    difficulty = json['difficulty'];
    answersMap.forEach((key, value) {
      if (value != null) {
        answers.add(value);
        selectedAnswers.add('false');
      }
    });
    json['correct_answers'].forEach((key, value) {
      correctAnswers.add(value);
    });
    int count = 0;
    for (var element in correctAnswers) {
      if (element == 'true') {
        count++;
      }
    }
    if (count > 1) {
      multipleCorrectAnswers = true;
    } else {
      multipleCorrectAnswers = false;
    }
  }

  selectAnswer(int answerIndex) {
    if (multipleCorrectAnswers == false) {
      if (selectedAnswers[answerIndex] == 'false') {
        for (int i = 0; i < selectedAnswers.length; i++) {
          selectedAnswers[i] = 'false';
        }
        selectedAnswers[answerIndex] = 'true';
      } else {
        selectedAnswers[answerIndex] = 'false';
      }
    } else {
      if (selectedAnswers[answerIndex] == 'true') {
        selectedAnswers[answerIndex] = 'false';
      } else {
        selectedAnswers[answerIndex] = 'true';
      }
    }
  }

  double calcQuestionGrade() {
    int rightAnswers = 0;
    int acceptedAnswers = 0;
    int wrongAnswer = 0;
    int counter = 0;
    for (var answer in selectedAnswers) {
      if (answer == 'true') {
        noAnswer = false;
      }
      if (correctAnswers[counter] == 'true') {
        acceptedAnswers++;
      }
      if (correctAnswers[counter] == answer &&
          correctAnswers[counter] == 'true') {
        rightAnswers++;
      }
      if (answer == 'true' && correctAnswers[counter] == 'false') {
        wrongAnswer++;
      }
      counter++;
    }

    return (rightAnswers / acceptedAnswers) - (0.5 * wrongAnswer);
  }
  // double calcSingleAnswerQuestionGrade(int answerKey) {
  //   //correctAnswer value like "answer_a" the key of the correctAnswer from correctAnswers map
  //   if (correctAnswer == answerKey) {
  //     return 1;
  //   } else {
  //     return 0;
  //   }
  // }
}
