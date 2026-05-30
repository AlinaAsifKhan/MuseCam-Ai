import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/camera_provider.dart';

/// Permission request widget - shown when camera permission is needed
class PermissionRequestWidget extends ConsumerWidget {
  const PermissionRequestWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Camera Permission Required',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              'We need camera access to take photos and help you with composition guidance.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () async {
                final cameraNotifier = ref.read(cameraStateProvider.notifier);
                await cameraNotifier.requestPermission();
                // Delay to let state update
                await Future.delayed(const Duration(milliseconds: 500));
                await cameraNotifier.initialize();
              },
              icon: const Icon(Icons.check),
              label: const Text('Grant Permission'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
