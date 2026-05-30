import 'dart:io';
import 'dart:developer' as developer;
import 'package:path_provider/path_provider.dart';

/// Service for storing captured photos on device
class PhotoStorageService {
  /// Get app documents directory
  static Future<Directory> getAppDocumentsDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  /// Get or create photos directory
  static Future<Directory> getPhotosDirectory() async {
    final appDir = await getAppDocumentsDirectory();
    final photosDir = Directory('${appDir.path}/MuseCamPhotos');
    
    // Create directory if it doesn't exist
    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
    }
    
    return photosDir;
  }

  /// Save photo bytes to device storage
  /// Returns the file path if successful, null if failed
  static Future<String?> savePhoto(List<int> bytes, {String? filename}) async {
    try {
      final photosDir = await getPhotosDirectory();
      
      // Generate filename if not provided
      final fileName = filename ?? 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File('${photosDir.path}/$fileName');
      
      // Write bytes to file
      await file.writeAsBytes(bytes);
      
      developer.log('Photo saved: ${file.path}', name: 'PhotoStorageService');
      return file.path;
    } catch (e) {
      developer.log('Error saving photo: $e', error: e, name: 'PhotoStorageService');
      return null;
    }
  }

  /// Get all saved photos
  static Future<List<File>> getAllPhotos() async {
    try {
      final photosDir = await getPhotosDirectory();
      final files = photosDir.listSync();
      
      return files
          .where((f) => f is File && (f.path.endsWith('.jpg') || f.path.endsWith('.png')))
          .cast<File>()
          .toList();
    } catch (e) {
      developer.log('Error getting photos: $e', error: e, name: 'PhotoStorageService');
      return [];
    }
  }

  /// Delete a photo file
  static Future<bool> deletePhoto(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        developer.log('Photo deleted: $filePath', name: 'PhotoStorageService');
        return true;
      }
      return false;
    } catch (e) {
      developer.log('Error deleting photo: $e', error: e, name: 'PhotoStorageService');
      return false;
    }
  }
}
