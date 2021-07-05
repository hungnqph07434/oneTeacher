import 'dart:io';
import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:onekidsteacher/data/data_const/config.dart';
import 'package:onekidsteacher/unit/constact/color.dart';
import 'package:onekidsteacher/unit/constact/string.dart';
import 'package:path_provider/path_provider.dart';

class Extension {
  /// check null
  dynamic checkNull(dynamic input, Type T, {bool initBool}) {
    if (T == String) {
      return input == null ? "" : input;
    }
    if (T == int) {
      return input == null ? 0 : input;
    }

    if (T == bool) {
      return input == null ? initBool : input;
    }

    if (T == List) {
      return input == null ? <dynamic>[] : input;
    }
  }

  ///TODO: Check is Number
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    s = s.replaceAll(RegExp(r','), ".");
    return double.parse(s, (e) => null) != null;
  }

  Future<String> createFolderInAppDocDir(String folderName) async {
    //Get this App Document Directory
    final Directory _appDocDir = await getApplicationDocumentsDirectory();
    //App Document Directory + folder name
    final Directory _appDocDirFolder =
        Directory('${_appDocDir.path}/$folderName/');

    if (await _appDocDirFolder.exists()) {
      //if folder already exists return path
      return _appDocDirFolder.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder =
          await _appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }
  }

  ///TODO: compressed file Image
  Future<File> compressedFileImage({Asset asset, File fileImage}) async {
    // convert Asset To File
    File file;
    if (asset == null) {
      file = fileImage;
    } else {
      String _filePath = await Extension().createFolderInAppDocDir("Onekids") +
          "${DateTime.now().microsecondsSinceEpoch}.jpg";
      ByteData byteData = await asset.getByteData();
      File newFile = await File(_filePath).writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      file = newFile;
    }

    // set witch and height in file
    int targetWidth;
    int targetHeight;

    ImageProperties properFile =
        await FlutterNativeImage.getImageProperties(file.path);

    var imFile = await decodeImageFromList(file.readAsBytesSync());

    if (properFile.width == imFile.width) {
      targetWidth = ConFig().withUpload;
      targetHeight =
          properFile.height * ConFig().withUpload ~/ properFile.width;
    } else {
      targetHeight = ConFig().withUpload;
      targetWidth = properFile.width * targetHeight ~/ properFile.height;
    }

    //crop file image
    File compressedFile = await FlutterNativeImage.compressImage(
      file.path,
      quality: ConFig().qualityUpload,
      targetWidth: targetWidth,
      targetHeight: targetHeight,
    );

    File(await Extension().createFolderInAppDocDir("Onekids"))
        .deleteSync(recursive: true);
    // return
    return compressedFile;
  }

  List<dynamic> search<E>(
    String name,
    listFilter,
    listDataFromServer,
  ) {
    return listDataFromServer
        .where((item) => removeUnicode(item.name).contains(removeUnicode(name)))
        .toList();
  }

  bool checkIsFileImage(String link) {
    String _lastLink = link.substring(link.lastIndexOf(".") + 1, link.length);
    if (_lastLink == "jpeg" || _lastLink == "png" || _lastLink == "jpg") {
      return true;
    } else {
      return false;
    }
  }

  List<dynamic> searchKidBirthDay<E>(
    String name,
    listDataFromServer,
  ) {
    return listDataFromServer
        .where((item) => removeUnicode(item.name).contains(removeUnicode(name)))
        .toList();
  }

  List<dynamic> searchTeacher<E>(
    String nameTeacher,
    listDataFromServer,
  ) {
    return listDataFromServer
        .where((item) => removeUnicode(item.nameTeacher)
            .contains(removeUnicode(nameTeacher)))
        .toList();
  }

  List<dynamic> searchParent<E>(
    String nameKid,
    listDataFromServer,
  ) {
    return listDataFromServer
        .where((item) =>
            removeUnicode(item.nameKid).contains(removeUnicode(nameKid)))
        .toList();
  }

  Future<bool> checkInternet() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  List<dynamic> searchChildName<E>(
    String name,
    listFilter,
    listDataFromServer,
  ) {
    return listDataFromServer
        .where((item) =>
            removeUnicode(item.childName).contains(removeUnicode(name)))
        .toList();
  }

  List<dynamic> searchNameKid<E>(
    String name,
    listDataFromServer,
  ) {
    return listDataFromServer
        .where(
            (item) => removeUnicode(item.nameKid).contains(removeUnicode(name)))
        .toList();
  }

  List<dynamic> searchHistoryNotification<E>(
    String content,
    listFilter,
    listDataFromServer,
  ) {
    return listDataFromServer
        .where((item) =>
            removeUnicode(item.content).contains(removeUnicode(content)))
        .toList();
  }

  List<dynamic> searchListComment<E>(
    String name,
    listDataFromServer,
  ) {
    return listDataFromServer
        .where((item) => removeUnicode(item.name).contains(removeUnicode(name)))
        .toList();
  }

  List<dynamic> searchNameChildComment<E>(String name, listComment) {
    return listComment
        .where((item) =>
            removeUnicode(item.nameChild).contains(removeUnicode(name)))
        .toList();
  }

  List<dynamic> searchNameChildCommentDay<E>(String name, listComment) {
    return listComment
        .where((item) =>
            removeUnicode(item.nameChild).contains(removeUnicode(name)))
        .toList();
  }

  showDialogError(BuildContext context, String title, String content) {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.SCALE,
        headerAnimationLoop: true,
        title: title,
        desc: content,
        btnOkOnPress: () {},
        btnOkText: "OK",
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red)
      ..show();
  }

  showDialogSuccess(BuildContext context, String title, String content,
      {Function onclickOK}) {
    AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        headerAnimationLoop: true,
        dialogType: DialogType.SUCCES,
        title: title,
        desc: content,
        btnOkText: "OK",
        btnOkOnPress: onclickOK != null ? onclickOK : () {},
        btnOkIcon: Icons.check_circle,
        onDissmissCallback: () {})
      ..show();
  }

  showDialogInformation(
    BuildContext context,
    String title,
    String content,
    DialogType dialogType, {
    bool isCompulsory = true,
    Function onDismiss,
    Function onClickOk,
    Function onClickCancel,
  }) {
    AwesomeDialog(
      context: context,
      headerAnimationLoop: true,
      dialogType: dialogType,
      animType: AnimType.SCALE,
      title: title,
      onDissmissCallback: onDismiss,
      dismissOnBackKeyPress: isCompulsory,
      dismissOnTouchOutside: isCompulsory,
      btnCancelOnPress: onClickCancel,
      btnCancelColor: clr_FA7A57,
      btnOkColor: clr_FA7A57,
      btnOkText: txt_content_button_update_dialog_new_version,
      btnCancelText: txt_content_button_close,
      btnOkOnPress: onClickOk,
      desc: content,
    )..show();
  }

  showDialogNoInternet(
      {BuildContext context,
      bool canClose = true,
      String content,
      Function onClickButtonReload}) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.SCALE,
      headerAnimationLoop: true,
      title: txt_connect_failed,
      desc: content,
      btnOkOnPress: onClickButtonReload == null ? () {} : onClickButtonReload,
      btnOkText: txt_content_button_refresh,
      dismissOnTouchOutside: canClose,
      dismissOnBackKeyPress: canClose,
      btnOkIcon: Icons.refresh,
      btnOkColor: clr_FA7A57,
      btnCancelOnPress: canClose == false ? null : () {},
      btnCancelIcon: canClose == false ? null : Icons.close,
      btnCancelText: txt_content_button_close,
      btnCancelColor: clr_FA7A57,
    )..show();
  }

  //TODO// Bỏ dấu tiếng việt
  String removeUnicode(String text) {
    var arr1 = [
      "á",
      "à",
      "ả",
      "ã",
      "ạ",
      "â",
      "ấ",
      "ầ",
      "ẩ",
      "ẫ",
      "ậ",
      "ă",
      "ắ",
      "ằ",
      "ẳ",
      "ẵ",
      "ặ",
      "đ",
      "é",
      "è",
      "ẻ",
      "ẽ",
      "ẹ",
      "ê",
      "ế",
      "ề",
      "ể",
      "ễ",
      "ệ",
      "í",
      "ì",
      "ỉ",
      "ĩ",
      "ị",
      "ó",
      "ò",
      "ỏ",
      "õ",
      "ọ",
      "ô",
      "ố",
      "ồ",
      "ổ",
      "ỗ",
      "ộ",
      "ơ",
      "ớ",
      "ờ",
      "ở",
      "ỡ",
      "ợ",
      "ú",
      "ù",
      "ủ",
      "ũ",
      "ụ",
      "ư",
      "ứ",
      "ừ",
      "ử",
      "ữ",
      "ự",
      "ý",
      "ỳ",
      "ỷ",
      "ỹ",
      "ỵ",
      "Á",
      "À",
      "Ả",
      "Ã",
      "Ạ",
      "Â",
      "Ấ",
      "Ầ",
      "Ẩ",
      "Ẫ",
      "Ậ",
      "Ă",
      "Ắ",
      "Ằ",
      "Ẳ",
      "Ẵ",
      "Ặ",
      "Đ",
      "É",
      "È",
      "Ẻ",
      "Ẽ",
      "Ẹ",
      "Ê",
      "Ế",
      "Ề",
      "Ể",
      "Ễ",
      "Ệ",
      "Í",
      "Ì",
      "Ỉ",
      "Ĩ",
      "Ị",
      "Ó",
      "Ò",
      "Ỏ",
      "Õ",
      "Ọ",
      "Ô",
      "Ố",
      "Ồ",
      "Ổ",
      "Ỗ",
      "Ộ",
      "Ơ",
      "Ớ",
      "Ờ",
      "Ở",
      "Ỡ",
      "Ợ",
      "Ú",
      "Ù",
      "Ủ",
      "Ũ",
      "Ụ",
      "Ư",
      "Ứ",
      "Ừ",
      "Ử",
      "Ữ",
      "Ự",
      "Ý",
      "Ỳ",
      "Ỷ",
      "Ỹ",
      "Ỵ"
    ];

    var arr2 = [
      "a",
      "a",
      "a",
      "a",
      "a",
      "a",
      "a",
      "a",
      "a",
      "a",
      "a",
      "a",
      "a",
      "a",
      "a",
      "a",
      "a",
      "d",
      "e",
      "e",
      "e",
      "e",
      "e",
      "e",
      "e",
      "e",
      "e",
      "e",
      "e",
      "i",
      "i",
      "i",
      "i",
      "i",
      "o",
      "o",
      "o",
      "o",
      "o",
      "o",
      "o",
      "o",
      "o",
      "o",
      "o",
      "o",
      "o",
      "o",
      "o",
      "o",
      "o",
      "u",
      "u",
      "u",
      "u",
      "u",
      "u",
      "u",
      "u",
      "u",
      "u",
      "u",
      "y",
      "y",
      "y",
      "y",
      "y",
      "a",
      "a",
      "a",
      "a",
      "a",
      "a",
      "a",
      "a",
      "a",
      "a",
      "a",
      "a",
      "a",
      "a",
      "a",
      "a",
      "a",
      "d",
      "e",
      "e",
      "e",
      "e",
      "e",
      "e",
      "e",
      "e",
      "e",
      "e",
      "e",
      "i",
      "i",
      "i",
      "i",
      "i",
      "o",
      "o",
      "o",
      "o",
      "o",
      "o",
      "o",
      "o",
      "o",
      "o",
      "o",
      "o",
      "o",
      "o",
      "o",
      "o",
      "o",
      "u",
      "u",
      "u",
      "u",
      "u",
      "u",
      "u",
      "u",
      "u",
      "u",
      "u",
      "y",
      "y",
      "y",
      "y",
      "y",
    ];
    for (int i = 0; i < arr1.length; i++) {
      text = text.replaceAll(arr1[i], arr2[i]);
      text = text.replaceAll(arr1[i].toLowerCase(), arr2[i].toLowerCase());
    }
    return text.toLowerCase();
  }
}
