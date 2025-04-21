import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

enum PDFViewSource {
  asset,
  network,
  file,
}

class BasePDFViewer extends StatefulWidget {
  final String source;
  final PDFViewSource sourceType;
  final bool enableDocumentLinkAnnotation;
  final bool enableTextSelection;
  final bool enableDoubleTapZooming;
  final int initialPage;
  final Color? backgroundColor;
  final PdfInteractionMode interactionMode;
  final PdfScrollDirection scrollDirection;
  final PdfPageLayoutMode pageLayoutMode;
  final Function(PdfTextSelectionChangedDetails)? onTextSelectionChanged;
  final Function(PdfDocumentLoadedDetails)? onDocumentLoaded;
  final Function(PdfPageChangedDetails)? onPageChanged;
  final Function(PdfZoomDetails)? onZoomLevelChanged;
  final Widget Function(BuildContext, PdfViewerController)? builder;

  const BasePDFViewer({
    Key? key,
    required this.source,
    required this.sourceType,
    this.enableDocumentLinkAnnotation = true,
    this.enableTextSelection = true,
    this.enableDoubleTapZooming = true,
    this.initialPage = 1,
    this.backgroundColor,
    this.interactionMode = PdfInteractionMode.pan,
    this.scrollDirection = PdfScrollDirection.horizontal,
    this.pageLayoutMode = PdfPageLayoutMode.single,
    this.onTextSelectionChanged,
    this.onDocumentLoaded,
    this.onPageChanged,
    this.onZoomLevelChanged,
    this.builder,
  }) : super(key: key);

  @override
  State<BasePDFViewer> createState() => _BasePDFViewerState();
}

class _BasePDFViewerState extends State<BasePDFViewer> {
  late final PdfViewerController _pdfViewerController;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildPdfViewer(),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
        if (_errorMessage != null)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Không thể tải file PDF',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  _errorMessage!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildPdfViewer() {
    try {
      Widget pdfViewer;

      switch (widget.sourceType) {
        case PDFViewSource.asset:
          pdfViewer = SfPdfViewer.asset(
            widget.source,
            controller: _pdfViewerController,
            enableDocumentLinkAnnotation: widget.enableDocumentLinkAnnotation,
            enableTextSelection: widget.enableTextSelection,
            enableDoubleTapZooming: widget.enableDoubleTapZooming,
            initialZoomLevel: 1.0,
            initialScrollOffset: Offset.zero,
            initialPageNumber: widget.initialPage,
            canShowScrollHead: true,
            canShowScrollStatus: true,
            canShowPaginationDialog: true,
            pageSpacing: 4,
            interactionMode: widget.interactionMode,
            scrollDirection: widget.scrollDirection,
            pageLayoutMode: widget.pageLayoutMode,
            onTextSelectionChanged: widget.onTextSelectionChanged,
            onDocumentLoaded: (PdfDocumentLoadedDetails details) {
              setState(() => _isLoading = false);
              if (widget.onDocumentLoaded != null) {
                widget.onDocumentLoaded!(details);
              }
            },
            onPageChanged: widget.onPageChanged,
            onZoomLevelChanged: widget.onZoomLevelChanged,
            onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
              setState(() {
                _isLoading = false;
                _errorMessage = details.error;
              });
            },
          );
          break;
        case PDFViewSource.network:
          pdfViewer = SfPdfViewer.network(
            widget.source,
            controller: _pdfViewerController,
            enableDocumentLinkAnnotation: widget.enableDocumentLinkAnnotation,
            enableTextSelection: widget.enableTextSelection,
            enableDoubleTapZooming: widget.enableDoubleTapZooming,
            initialZoomLevel: 1.0,
            initialScrollOffset: Offset.zero,
            initialPageNumber: widget.initialPage,
            canShowScrollHead: true,
            canShowScrollStatus: true,
            canShowPaginationDialog: true,
            pageSpacing: 4,
            interactionMode: widget.interactionMode,
            scrollDirection: widget.scrollDirection,
            pageLayoutMode: widget.pageLayoutMode,
            onTextSelectionChanged: widget.onTextSelectionChanged,
            onDocumentLoaded: (PdfDocumentLoadedDetails details) {
              setState(() => _isLoading = false);
              if (widget.onDocumentLoaded != null) {
                widget.onDocumentLoaded!(details);
              }
            },
            onPageChanged: widget.onPageChanged,
            onZoomLevelChanged: widget.onZoomLevelChanged,
            onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
              setState(() {
                _isLoading = false;
                _errorMessage = details.error;
              });
            },
          );
          break;
        case PDFViewSource.file:
          pdfViewer = SfPdfViewer.file(
            File(widget.source),
            controller: _pdfViewerController,
            enableDocumentLinkAnnotation: widget.enableDocumentLinkAnnotation,
            enableTextSelection: widget.enableTextSelection,
            enableDoubleTapZooming: widget.enableDoubleTapZooming,
            initialZoomLevel: 1.0,
            initialScrollOffset: Offset.zero,
            initialPageNumber: widget.initialPage,
            canShowScrollHead: true,
            canShowScrollStatus: true,
            canShowPaginationDialog: true,
            pageSpacing: 4,
            interactionMode: widget.interactionMode,
            scrollDirection: widget.scrollDirection,
            pageLayoutMode: widget.pageLayoutMode,
            onTextSelectionChanged: widget.onTextSelectionChanged,
            onDocumentLoaded: (PdfDocumentLoadedDetails details) {
              setState(() => _isLoading = false);
              if (widget.onDocumentLoaded != null) {
                widget.onDocumentLoaded!(details);
              }
            },
            onPageChanged: widget.onPageChanged,
            onZoomLevelChanged: widget.onZoomLevelChanged,
            onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
              setState(() {
                _isLoading = false;
                _errorMessage = details.error;
              });
            },
          );
          break;
      }

      if (widget.builder != null) {
        return widget.builder!(context, _pdfViewerController);
      }

      return Container(
        color: widget.backgroundColor,
        child: pdfViewer,
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
      return const SizedBox.shrink();
    }
  }
}