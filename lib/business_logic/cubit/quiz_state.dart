// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'quiz_cubit.dart';

@immutable
abstract class QuizState {}

class QuizInitialState extends QuizState {}

class QuizDataLoadedState extends QuizState {
  List<Question> questions;
  QuizDataLoadedState({
    required this.questions,
  });
  
}

 class QuizDataLoadingState extends QuizState {}

// class QuizInitialState extends QuizState {}
