import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_study_app/controllers/question_paper/questions_controller.dart';
import 'package:get/get.dart';

import '../../firebase_ref/references.dart';
import '../auth_controller.dart';

extension QuestionsControllerExtension on QuestionsController {
  int get correctQuestionsCount => allQuestions
      .where((element) => element.selectedAnswer == element.correctAnswer)
      .toList()
      .length;

  String get correctAnsweredQuestions {
    return '$correctQuestionsCount out of ${allQuestions.length} are correct';
  }

  String get points {
    var points = (correctQuestionsCount / allQuestions.length) *
        (remainSeconds / questionPaperModel.timeSeconds) *
        10000;
    return points.toStringAsFixed(2);
  }

  Future<void> saveTestResults() async {
    var batch = fireStore.batch();
    User? user = Get.find<AuthController>().getUser();
    if (user == null) return;
    batch.set(
      userRf
          .doc(user.email)
          .collection('my_recent_tests')
          .doc(questionPaperModel.id),
      {
        "points": points,
        "correct_answer": '$correctQuestionsCount/${allQuestions.length}',
        "question_id": questionPaperModel.id,
        "time": questionPaperModel.timeSeconds - remainSeconds,
      },
    );
    batch.commit();
    navigateToHome();
  }
}
