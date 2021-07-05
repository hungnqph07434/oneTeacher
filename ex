
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
