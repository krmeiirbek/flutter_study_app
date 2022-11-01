import 'package:flutter_study_app/firebase_ref/references.dart';
import 'package:flutter_study_app/utils/logger.dart';
import 'package:get/get.dart';


class FirebaseStorageService extends GetxService {
  Future<String?> getImage(String? imgName) async{
    if (imgName == null) {
      return null;
    }
    try {
      var urlRef = firebaseStorage
          .child("question_paper_images")
          .child('${imgName.toLowerCase()}.png');
      var imgUrl = await urlRef.getDownloadURL();
      return imgUrl;
    } catch (e) {
      AppLogger.e(e);
      return null;
    }
  }
}
