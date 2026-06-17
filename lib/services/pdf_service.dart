import 'dart:io' show File;

import 'package:camera/camera.dart' show XFile;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/form_component.dart';

class PdfService {
  static const double baseCanvasWidth = 500.0;

  static Future<XFile> generateFormPdf(
    String formName,
    List<FormComponent> components, {
    String documentText = "",
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [_buildDocumentContent(documentText, components)];
        },
      ),
    );

    final bytes = await pdf.save();
    final fileName =
        "${formName.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf";

    if (kIsWeb) {
      return XFile.fromData(bytes, name: fileName, mimeType: 'application/pdf');
    } else {
      final output = await getApplicationDocumentsDirectory();
      final file = File("${output.path}/$fileName");
      await file.writeAsBytes(bytes);
      return XFile(file.path, name: fileName, mimeType: 'application/pdf');
    }
  }

  static pw.Widget _buildDocumentContent(
    String text,
    List<FormComponent> components,
  ) {
    // Regex to find [[type:id]] placeholders
    final regex = RegExp(r'\[\[([^:]+):([^\]]+)\]\]');
    final matches = regex.allMatches(text);

    if (matches.isEmpty) {
      return pw.Paragraph(
        text: text,
        style: const pw.TextStyle(fontSize: 12, lineSpacing: 4),
      );
    }

    final List<pw.InlineSpan> spans = [];
    int lastMatchEnd = 0;

    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        spans.add(pw.TextSpan(text: text.substring(lastMatchEnd, match.start)));
      }

      final typeStr = match.group(1);
      final id = match.group(2);

      final component = components.firstWhere(
        (c) => c.id == id,
        orElse: () => FormComponent(
          id: id ?? 'unknown',
          type: _typeFromString(typeStr),
          boxWidth: 100,
        ),
      );

      spans.add(
        pw.WidgetSpan(
          child: _buildInteractiveComponent(component),
          baseline: 0,
        ),
      );

      lastMatchEnd = match.end;
    }

    // Add remaining text
    if (lastMatchEnd < text.length) {
      spans.add(pw.TextSpan(text: text.substring(lastMatchEnd)));
    }

    return pw.RichText(
      text: pw.TextSpan(
        children: spans,
        style: const pw.TextStyle(fontSize: 12, lineSpacing: 4),
      ),
    );
  }

  static FormComponentType _typeFromString(String? typeStr) {
    return FormComponentType.values.firstWhere(
      (e) => e.name == typeStr,
      orElse: () => FormComponentType.textField,
    );
  }

  static pw.Widget _buildInteractiveComponent(FormComponent comp) {
    switch (comp.type) {
      case FormComponentType.textField:
      case FormComponentType.textArea:
        return pw.Container(
          width: comp.boxWidth,
          height: comp.type == FormComponentType.textArea ? 40 : 15,
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(color: PdfColors.black, width: 0.5),
            ),
          ),
          child: pw.TextField(name: comp.id, defaultValue: ""),
        );

      case FormComponentType.checkbox:
        return pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 2),
          child: pw.Checkbox(name: comp.id, value: false),
        );

      case FormComponentType.toggle:
        return pw.Checkbox(name: comp.id, value: false);

      case FormComponentType.dropdown:
        return pw.Container(
          width: 80,
          height: 15,
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(color: PdfColors.black, width: 0.5),
            ),
          ),
          child: pw.ChoiceField(
            name: comp.id,
            items: comp.options.isNotEmpty ? comp.options : ["Select..."],
          ),
        );

      case FormComponentType.datePicker:
        return pw.Text('__/__/____');
      // return pw.Container(
      //   width: 70,
      //   height: 15,
      //   decoration: const pw.BoxDecoration(
      //     border: pw.Border(
      //       bottom: pw.BorderSide(color: PdfColors.black, width: 0.5),
      //     ),
      //   ),
      //
      //   // child: pw.TextField(name: comp.id, defaultValue: "__/__/____"),
      // );

      case FormComponentType.signaturePad:
        return pw.Signature(
          name: 'signature',
          child: pw.Container(
            width: comp.boxWidth,
            height: 60,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1),
            ),
            child: pw.Center(),
          ),
        );

      case FormComponentType.imagePlaceholder:
        return pw.Container(
          width: comp.boxWidth,
          height: comp.boxWidth,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey, width: 0.5),
          ),
          child: pw.Center(
            child: pw.Text("Image", style: const pw.TextStyle(fontSize: 8)),
          ),
        );

      case FormComponentType.divider:
        return pw.SizedBox(
          width: PdfPageFormat.a4.width,
          child: pw.Divider(thickness: 1),
        );

      default:
        return pw.SizedBox(width: 10);
    }
  }
}
