import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/photo_storage_service.dart';

/// Provider that returns the list of saved photo files.
final photoListProvider = FutureProvider<List<File>>((ref) async {
  final files = await PhotoStorageService.getAllPhotos();
  // Sort by modified time descending
  files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
  return files;
});
