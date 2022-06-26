import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

// ignore: lines_longer_than_80_chars
final imageViewModelProvider = ChangeNotifierProvider<ImageViewModel>(
  (ref) {
    return ImageViewModel();
  },
);

// imagePickerの種別
enum ImagePickType {
  camera,
  gallery,
}

class ImageViewModel extends ChangeNotifier {
  ImageViewModel();

  File? file;
  final picker = ImagePicker();
  String imagePath = '';
  String imageName = '';

  // ImagePicker（ギャラリー）
  Future getImageFromGallery() async {
    final image = await picker.pickImage(source: ImageSource.gallery);
    // 空の場合終了
    if (image == null) {
      return;
    }
    imagePath = image.path;
    imageName = image.name;
    file = File(imagePath);
    notifyListeners();
  }

  // ImagePicker（カメラ）
  Future getImageFromCamera() async {
    final image = await picker.pickImage(source: ImageSource.camera);
    // 空の場合終了
    if (image == null) {
      return;
    }
    imagePath = image.path;
    imageName = image.name;
    file = File(imagePath);
    notifyListeners();
  }

  Future storeYourChatImage(String storagePath) async {
    print('あなたのチャットで画像保存');

    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DateFormat fireStoreFormat = DateFormat('yyyy-M-dd hh:mm:ss.SSS');
      if (file != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          "iconPath": storagePath,
          "updatedAt": fireStoreFormat.format(DateTime.now()),
        });

        notifyListeners();
      }
      print('保存完了');
    } on Exception catch (e) {
      notifyListeners();
      print('テキスト登録中にエラーが発生しました');
      print(e);
    }
  }

  Future pickAndStoreImage(ImagePickType type) async {
    FirebaseStorage storage = FirebaseStorage.instance;

    // 画像取得の種別切り替え
    switch (type) {
      case ImagePickType.camera:
        await getImageFromCamera();
        break;
      case ImagePickType.gallery:
        await getImageFromGallery();
        break;
    }

    try {
      if (file != null) {
        // ファイルをStorageに保存
        final task = await storage.ref('images/$imageName').putFile(file!);
        // 保存したファイルのURLを取得
        String imageUrl = await task.ref.getDownloadURL();
        // URL情報をFirestoreに保存
        await storeYourChatImage(imageUrl);
      }
    } catch (e) {
      print(e);
    }
  }
}
