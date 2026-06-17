import 'dart:io' show File;
import 'dart:typed_data';

import 'package:camera/camera.dart' show XFile;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart' show TextAlign;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_kit_editor/pdf_kit_editor.dart';
import 'package:printing/printing.dart';

import '../models/form_component.dart';

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

  static Future<XFile> generateFormPdf(
    String formName,
    List<FormComponent> components,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          final pageWidth = PdfPageFormat.a4.width;
          final scale = pageWidth / baseCanvasWidth;

          return pw.Stack(
            children: components.map((comp) {
              return pw.Positioned(
                left: comp.dx * scale,
                top: comp.dy * scale,
                // width: comp.width * scale,
                // height: comp.height * scale,
                child: _buildComponent(comp),
              );
            }).toList(),
          );
        },
      ),
    );

    final bytes = await pdf.save();
    final fileName =
        "${formName.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf";

    if (kIsWeb) {
      // Trigger download on Web
      await Printing.sharePdf(bytes: bytes, filename: fileName);
      return XFile.fromData(bytes, name: fileName, mimeType: 'application/pdf');
    } else {
      // Save to local file system on Mobile/Desktop
      final output = await getApplicationDocumentsDirectory();
      final file = File("${output.path}/$fileName");
      await file.writeAsBytes(bytes);
      return XFile(file.path, name: fileName, mimeType: 'application/pdf');
    }
  }

  static pw.Widget _buildComponent(FormComponent comp) {
    switch (comp.type) {
      case FormComponentType.textLabel:
        return pw.Text(
          comp.label,
          textAlign: _convertTextAlign(comp.alignment),
          style: pw.TextStyle(
            fontSize: comp.fontSize,
            fontWeight: comp.isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            fontStyle: comp.isItalic
                ? pw.FontStyle.italic
                : pw.FontStyle.normal,
          ),
        );

      case FormComponentType.textField:
      case FormComponentType.textArea:
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (comp.label.isNotEmpty)
              pw.Text(
                comp.label,
                style: const pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            pw.SizedBox(height: 2),
            pw.Expanded(
              child: pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
                ),
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text(
                  comp.placeholder,
                  style: const pw.TextStyle(
                    color: PdfColors.grey,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        );

      case FormComponentType.checkbox:
        return pw.Row(
          children: [
            pw.Container(
              width: 12,
              height: 12,
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.black, width: 1),
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Text(comp.label),
          ],
        );

      case FormComponentType.toggle:
        return pw.Row(
          children: [
            pw.Container(
              width: 20,
              height: 10,
              decoration: const pw.BoxDecoration(
                color: PdfColors.grey300,
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(5)),
              ),
              child: pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Container(
                  width: 10,
                  height: 10,
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.white,
                    shape: pw.BoxShape.circle,
                  ),
                ),
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Text(comp.label),
          ],
        );

      case FormComponentType.dropdown:
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (comp.label.isNotEmpty)
              pw.Text(
                comp.label,
                style: const pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            pw.SizedBox(height: 2),
            pw.Expanded(
              child: pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
                ),
                padding: const pw.EdgeInsets.symmetric(horizontal: 8),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "Select option...",
                      style: const pw.TextStyle(
                        color: PdfColors.grey,
                        fontSize: 10,
                      ),
                    ),
                    pw.PdfLogo(),
                  ],
                ),
              ),
            ),
          ],
        );

      case FormComponentType.datePicker:
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (comp.label.isNotEmpty)
              pw.Text(
                comp.label,
                style: const pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            pw.SizedBox(height: 2),
            pw.Expanded(
              child: pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
                ),
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: pw.Text(
                  "__ / __ / ____",
                  style: const pw.TextStyle(
                    color: PdfColors.grey,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        );

      case FormComponentType.signaturePad:
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
                ),
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              comp.label.isNotEmpty ? comp.label : "Signature",
              style: const pw.TextStyle(fontSize: 8),
            ),
          ],
        );

      case FormComponentType.imagePlaceholder:
        return pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(
              color: PdfColors.grey400,
              width: 0.5,
              style: pw.BorderStyle.dashed,
            ),
          ),
          child: pw.Center(
            child: pw.Text(
              "Image Placeholder",
              style: const pw.TextStyle(color: PdfColors.grey, fontSize: 8),
            ),
          ),
        );

      case FormComponentType.divider:
        return pw.Divider(thickness: 1, color: PdfColors.grey300);

      case FormComponentType.pageBreak:
        return pw.SizedBox(height: 0);

      case FormComponentType.radioGroup:
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (comp.label.isNotEmpty)
              pw.Text(
                comp.label,
                style: const pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
              ),
            pw.SizedBox(height: 4),
            pw.Row(
              children: [
                pw.Container(
                  width: 10,
                  height: 10,
                  decoration: pw.BoxDecoration(
                    shape: pw.BoxShape.circle,
                    border: pw.Border.all(width: 0.5),
                  ),
                ),
                pw.SizedBox(width: 4),
                pw.Text("Option 1", style: const pw.TextStyle(fontSize: 10)),
                pw.SizedBox(width: 12),
                pw.Container(
                  width: 10,
                  height: 10,
                  decoration: pw.BoxDecoration(
                    shape: pw.BoxShape.circle,
                    border: pw.Border.all(width: 0.5),
                  ),
                ),
                pw.SizedBox(width: 4),
                pw.Text("Option 2", style: const pw.TextStyle(fontSize: 10)),
              ],
            ),
          ],
        );

      case FormComponentType.initialField:
        return pw.Row(
          children: [
            pw.Text(
              comp.label.isNotEmpty ? comp.label : "Initials:",
              style: const pw.TextStyle(fontSize: 10),
            ),
            pw.SizedBox(width: 4),
            pw.Container(
              width: 30,
              decoration: const pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(width: 0.5)),
              ),
            ),
          ],
        );

      case FormComponentType.sectionHeader:
        return pw.Text(
          comp.label,
          style: const pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        );

      case FormComponentType.staticText:
        return pw.Text(comp.label, style: const pw.TextStyle(fontSize: 10));
    }
  }

  static pw.TextAlign _convertTextAlign(TextAlign align) {
    switch (align) {
      case TextAlign.left:
        return pw.TextAlign.left;
      case TextAlign.right:
        return pw.TextAlign.right;
      case TextAlign.center:
        return pw.TextAlign.center;
      case TextAlign.justify:
        return pw.TextAlign.justify;
      default:
        return pw.TextAlign.left;
    }
  }
}
