import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:natural_encoder/domain/file_services/base_file_service.dart';
import 'dart:html' as webFile;


class FileService implements BaseFileService{
  @override
  Future<String> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: ['txt'],
        type: FileType.custom,
    );
    if (result != null) {
      PlatformFile file = result.files.first;

      if(file.bytes!=null){
        String decodedText = Utf8Decoder().convert(file.bytes!);
        print('Readed Text ${decodedText}');
        return Future.value(decodedText);
      }
    }
    return Future.value('Ошибка при прочтении файла');
  }

  @override
  saveFile(String textForSave) async{

    List<int> encodedText = utf8.encode(textForSave);

    final blob = webFile.Blob([encodedText]);

    final url = webFile.Url.createObjectUrlFromBlob(blob);
    final anchor = webFile.AnchorElement(href: url)
      ..setAttribute('download', 'result.txt')
      ..click();

    webFile.Url.revokeObjectUrl(url);
    print('file saved : result.txt');
  }

}