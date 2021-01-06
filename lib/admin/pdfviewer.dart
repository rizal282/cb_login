import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';

class Pdfviewerpage extends StatelessWidget {
  final String path;

  const Pdfviewerpage({Key key, this.path}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      path: path,
    );
  }
}