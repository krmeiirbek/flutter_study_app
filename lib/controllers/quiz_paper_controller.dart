import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_study_app/controllers/auth_controller.dart';
import 'package:flutter_study_app/firebase_ref/references.dart';
import 'package:flutter_study_app/models/question_paper_model.dart';
import 'package:flutter_study_app/screens/question/questions_screen.dart';
import 'package:flutter_study_app/services/firebase_storage_service.dart';
import 'package:flutter_study_app/utils/logger.dart';
import 'package:get/get.dart';

class QuizPaperController extends GetxController {
  final allPapers = <QuestionPaperModel>[].obs;

  @override
  void onReady() {
    getAllPapers();
    super.onReady();
  }

  Future<void> getAllPapers() async {
    try {
      QuerySnapshot<Map<String, dynamic>> data = await questionPaperRF.get();
      final paperList = data.docs
          .map((paper) => QuestionPaperModel.fromSnapshot(paper))
          .toList();
      allPapers.assignAll(paperList);
      for (var paper in paperList) {
        final imgUrl =
            await Get.find<FirebaseStorageService>().getImage(paper.title);
        paper.imageUrl = imgUrl;
      }
      allPapers.assignAll(paperList);
    } catch (e) {
      AppLogger.e(e);
    }
  }

  void navigateToQuestions({required QuestionPaperModel paper, bool tryAgain = false}){
    AuthController authController = Get.find();
    if(authController.isLoggedIn()){
      if(tryAgain){
        Get.back();
        Get.toNamed(QuestionsScreen.routeName, arguments: paper,preventDuplicates: false);
      }else{
        Get.toNamed(QuestionsScreen.routeName, arguments: paper);
      }
      }else{
      authController.showLoginAlertDialogue();
    }
  }
}
