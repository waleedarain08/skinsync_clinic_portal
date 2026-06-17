import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../utils/theme.dart';

class PdfPreviewScreen extends StatefulWidget {
  final String formName;
  final XFile file;

  const PdfPreviewScreen({
    super.key,
    required this.formName,
    required this.file,
  });

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  final PdfViewerController _pdfViewerController = PdfViewerController();

  @override
  Widget build(BuildContext context) {
    log('PATH: ${widget.file.path}');
    return Scaffold(
      backgroundColor: CustomColors.softGrey,
      appBar: AppBar(
        title: Text(
          "Preview: ${widget.formName}",
          style: CustomFonts.black18w600,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              // Printing logic could be added here
            },
            tooltip: "Print",
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Sharing logic could be added here
            },
            tooltip: "Share",
          ),
        ],
      ),
      body: Column(
        children: [
          _buildToolbar(),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: kIsWeb
                  ? SfPdfViewer.network(
                      widget.file.path,
                      controller: _pdfViewerController,
                      canShowSignaturePadDialog: true,
                      onDocumentLoadFailed: (details) {
                        log('DETAILS: ${details.description}');
                      },
                      canShowPaginationDialog: true,
                    )
                  : SfPdfViewer.file(
                      File(widget.file.path),
                      controller: _pdfViewerController,
                      canShowPaginationDialog: true,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.zoom_out),
            onPressed: () => _pdfViewerController.zoomLevel -= 0.25,
          ),
          Text(
            "${(_pdfViewerController.zoomLevel * 100).toInt()}%",
            style: CustomFonts.black14w600,
          ),
          IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: () => _pdfViewerController.zoomLevel += 0.25,
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_left),
            onPressed: () => _pdfViewerController.previousPage(),
          ),
          Text(
            "Page ${_pdfViewerController.pageNumber} of ${_pdfViewerController.pageCount}",
            style: CustomFonts.grey12w400,
          ),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_right),
            onPressed: () => _pdfViewerController.nextPage(),
          ),
        ],
      ),
    );
  }
}
