import 'package:flutter/material.dart';
import 'package:muse_cam_ai/core/constants/spacing.dart';
import 'package:muse_cam_ai/core/theme/colors.dart';
import 'package:muse_cam_ai/core/theme/typography.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/photo_list_provider.dart';
import 'dart:io';

class GalleryScreen extends ConsumerWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photosAsync = ref.watch(photoListProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF101114), Color(0xFF191C24), Color(0xFF0C0D10)],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    MuseSpacing.lg,
                    MuseSpacing.lg,
                    MuseSpacing.lg,
                    MuseSpacing.md,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_rounded),
                        color: Colors.white,
                      ),
                      const SizedBox(width: MuseSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gallery',
                              style: MuseTypography.displaySm.copyWith(
                                color: Colors.white,
                                fontSize: 28,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Browse your latest captures.',
                              style: MuseTypography.bodySm.copyWith(
                                color: MuseColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              photosAsync.when(
                data: (files) {
                  if (files.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(MuseSpacing.lg),
                        child: Text(
                          'No photos yet. Capture something!',
                          style: MuseTypography.bodySm.copyWith(color: MuseColors.textSecondary),
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: MuseSpacing.lg),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: MuseSpacing.md,
                        crossAxisSpacing: MuseSpacing.md,
                        mainAxisExtent: 220,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final file = files[index];
                          return _GalleryTile(
                            index: index,
                            file: file,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => _GalleryDetailScreen(file: file),
                                ),
                              );
                            },
                          );
                        },
                        childCount: files.length,
                      ),
                    ),
                  );
                },
                loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
                error: (_, __) => const SliverToBoxAdapter(child: Center(child: Text('Failed to load photos'))),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: MuseSpacing.xl),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GalleryTile extends StatelessWidget {
  final int index;
  final File file;
  final VoidCallback onTap;

  const _GalleryTile({required this.index, required this.file, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(MuseSpacing.radiusLg),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(MuseSpacing.radiusLg),
        child: Image.file(
          file,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}

class _GalleryDetailScreen extends StatelessWidget {
  final File file;

  const _GalleryDetailScreen({required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: Image.file(file),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}