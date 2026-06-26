// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../theme/app_theme.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

class AppImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? errorWidget;

  const AppImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorWidget,
  });

  @override
  State<AppImage> createState() => _AppImageState();
}

class _AppImageState extends State<AppImage> {
  late String _viewId;
  bool _isWebUrl = false;

  @override
  void initState() {
    super.initState();
    _initWebImage();
  }

  @override
  void didUpdateWidget(AppImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _initWebImage();
    }
  }

  void _initWebImage() {
    _isWebUrl = kIsWeb && widget.imageUrl.startsWith('http');
    if (_isWebUrl) {
      _viewId =
          'img-view-${DateTime.now().millisecondsSinceEpoch}-${widget.imageUrl.hashCode}';

      ui_web.platformViewRegistry.registerViewFactory(_viewId, (int viewId) {
        final img = html.ImageElement()
          ..src = widget.imageUrl
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.objectFit = widget.fit == BoxFit.cover ? 'cover' : 'contain';
        return img;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrl.isEmpty) {
      return _buildError();
    }

    if (widget.imageUrl.startsWith('data:image')) {
      try {
        final base64String = widget.imageUrl.split(',').last;
        return Image.memory(
          base64Decode(base64String),
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          errorBuilder: (context, error, stackTrace) => _buildError(),
        );
      } catch (e) {
        return _buildError();
      }
    }

    if (_isWebUrl) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: HtmlElementView(viewType: _viewId),
      );
    }

    return Image.network(
      widget.imageUrl,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      errorBuilder: (context, error, stackTrace) => _buildError(),
    );
  }

  Widget _buildError() {
    if (widget.errorWidget != null) return widget.errorWidget!;
    return Container(
      width: widget.width,
      height: widget.height,
      color: AppTheme.bgSurface,
      child: Icon(Icons.broken_image_outlined, color: AppTheme.textMuted),
    );
  }
}
