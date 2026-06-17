import 'dart:io' show File;
import 'dart:typed_data';

import 'package:camera/camera.dart' show XFile;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:pdf_kit_editor/pdf_layout_kit.dart';

class PdfService {
  static const double baseCanvasWidth = 500.0;

  static Future<Uint8List> generateFromTemplate(
    PdfTemplate template,
    Map<String, dynamic> data,
  ) async {
    final generator = PdfLayoutGenerator();
    await generator.init();
    return await generator.generate(template, data);
  }

  static Future<XFile> savePdfToFile(Uint8List bytes, String name) async {
    final fileName = "${name.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf";
    
    if (kIsWeb) {
       return XFile.fromData(bytes, name: fileName, mimeType: 'application/pdf');
    }
    
    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/$fileName");
    await file.writeAsBytes(bytes);
    return XFile(file.path);
  }
}
