import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/firebase_service.dart';
import '../theme/app_theme.dart';
import 'app_image.dart';

class ImageUploadField extends StatefulWidget {
  final String label;
  final String? currentImageUrl;
  final String folderName;
  final ValueChanged<String> onImageUploaded;

  const ImageUploadField({
    super.key,
    required this.label,
    required this.folderName,
    required this.onImageUploaded,
    this.currentImageUrl,
  });

  @override
  State<ImageUploadField> createState() => _ImageUploadFieldState();
}

class _ImageUploadFieldState extends State<ImageUploadField> {
  final FirebaseService _fs = FirebaseService();
  final ImagePicker _picker = ImagePicker();

  bool _isUploading = false;
  String? _uploadedUrl;

  @override
  void initState() {
    super.initState();
    _uploadedUrl = widget.currentImageUrl;
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      setState(() => _isUploading = true);

      final bytes = await image.readAsBytes();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${image.name}';

      final downloadUrl = await _fs.uploadImage(
        bytes,
        widget.folderName,
        fileName,
      );

      if (downloadUrl != null) {
        setState(() => _uploadedUrl = downloadUrl);
        widget.onImageUploaded(downloadUrl);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('فشل رفع الصورة')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = _uploadedUrl != null && _uploadedUrl!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTheme.smallText.copyWith(color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.bgSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _isUploading
                    ? const Center(child: CircularProgressIndicator())
                    : hasImage
                    ? AppImage(
                        imageUrl: _uploadedUrl!,
                        fit: BoxFit.cover,
                        errorWidget: Icon(
                          Icons.broken_image_outlined,
                          color: AppTheme.textMuted,
                        ),
                      )
                    : Icon(
                        Icons.image_outlined,
                        color: AppTheme.textMuted,
                        size: 32,
                      ),
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isUploading ? null : _pickAndUploadImage,
                icon: const Icon(Icons.upload_file),
                label: Text(hasImage ? 'تغيير الصورة' : 'رفع صورة'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: BorderSide(color: AppTheme.borderColor),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
