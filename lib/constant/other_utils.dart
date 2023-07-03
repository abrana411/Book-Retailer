//Function to opich images for a product while the admin is adding them:-
import 'dart:io';

import 'package:file_picker/file_picker.dart';

Future<List<File>> pickProductImages() async {
  List<File> images = [];
  try {
    //using the file picker package to pick the images now
    var picked = await FilePicker.platform.pickFiles(
      type: FileType
          .image, //Doing this so that it only shows us the file of the image formats to select
      allowMultiple:
          true, //as there can be multiple images of a product so allowing multiple files
    );
    //now this picked.files will have a list of files which we want
    //so if it is not empty then itrating over them and getting the path of the file converted to file format and added to the list as shown below
    if (picked != null && picked.files.isNotEmpty) {
      for (int i = 0; i < picked.files.length; i++) {
        images.add(File(picked.files[i].path!));
      }
    }
  } catch (error) {
    print(error.toString());
  }
  return images;
}
