import 'package:dio/dio.dart';
import 'package:quiz_app/constants/api_constants.dart';

class QuizSercive {
  late Dio dio;

  QuizSercive() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: 90 * 1000, //90s
      receiveTimeout: 90 * 1000, //20s
    );
    dio = Dio(options);
  }

  Future<List<dynamic>> getQuestions(
      {String category = '',
      String difficulty = '',
      String limit = '10'}) async {
    if (category == 'Any Category') {
      category = '';
    }
    if (difficulty == 'Any Difficulty') {
      difficulty = '';
    }
    final questions = await dio.get(quizEndPoint, queryParameters: {
      'apiKey': apiKey,
      'category': category,
      'difficulty': difficulty,
      'limit': limit,
    });
    return questions.data;
  }
}
