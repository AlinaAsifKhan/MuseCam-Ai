import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:muse_cam_ai/core/constants/spacing.dart';
import 'package:muse_cam_ai/core/theme/colors.dart';
import 'package:muse_cam_ai/core/theme/typography.dart';
import 'package:muse_cam_ai/features/camera/presentation/providers/mode_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modes = ref.watch(availableModesProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF111217), Color(0xFF171A22), Color(0xFF0C0D10)],
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: MuseColors.surface.withValues(alpha: 0.85),
                              border: Border.all(
                                color: MuseColors.primary.withValues(alpha: 0.2),
                              ),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.camera_alt_rounded,
                                  color: MuseColors.primary,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: MuseSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'MuseCam AI',
                                  style: MuseTypography.displaySm.copyWith(
                                    color: Colors.white,
                                    fontSize: 28,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Choose a mode, then step into the camera.',
                                  style: MuseTypography.bodySm.copyWith(
                                    color: MuseColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: MuseSpacing.xl),
                      _SectionTitle(
                        title: 'Capture Modes',
                        subtitle: 'Tap one to open the camera in that mode.',
                      ),
                      const SizedBox(height: MuseSpacing.md),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: MuseSpacing.lg),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: MuseSpacing.md,
                    crossAxisSpacing: MuseSpacing.md,
                    mainAxisExtent: 176,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final mode = modes[index];
                      return _ModeCard(
                        mode: mode,
                        onTap: () {
                          ref.read(modeProvider.notifier).selectMode(mode);
                          context.go('/camera?mode=${mode.name}');
                        },
                      );
                    },
                    childCount: modes.length,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    MuseSpacing.lg,
                    MuseSpacing.xl,
                    MuseSpacing.lg,
                    MuseSpacing.md,
                  ),
                  child: _SectionTitle(
                    title: 'Recent Captures',
                    subtitle: 'Your latest results will appear here.',
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: MuseSpacing.lg),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _RecentCaptureTile(index: index),
                    childCount: 6,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: MuseSpacing.md,
                    crossAxisSpacing: MuseSpacing.md,
                    mainAxisExtent: 120,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    MuseSpacing.lg,
                    MuseSpacing.xl,
                    MuseSpacing.lg,
                    MuseSpacing.md,
                  ),
                  child: _SectionTitle(
                    title: 'AI Themes',
                    subtitle: 'A few visual directions for your next shoot.',
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 140,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: MuseSpacing.lg),
                    scrollDirection: Axis.horizontal,
                    itemCount: _themeCards.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: MuseSpacing.md),
                    itemBuilder: (context, index) {
                      final theme = _themeCards[index];
                      return _ThemeCard(
                        title: theme.title,
                        description: theme.description,
                        colors: theme.colors,
                      );
                    },
                  ),
                ),
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

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: MuseTypography.displaySm.copyWith(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: MuseTypography.bodySm.copyWith(
            color: MuseColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _ModeCard extends StatelessWidget {
  final CaptureMode mode;
  final VoidCallback onTap;

  const _ModeCard({required this.mode, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final gradient = switch (mode) {
      CaptureMode.portrait => const [Color(0xFF1D2230), Color(0xFF10131B)],
      CaptureMode.selfie => const [Color(0xFF16302C), Color(0xFF0F1715)],
      CaptureMode.product => const [Color(0xFF302316), Color(0xFF17110C)],
      CaptureMode.creative => const [Color(0xFF261C31), Color(0xFF15111D)],
    };

    final iconData = switch (mode) {
      CaptureMode.portrait => Icons.portrait_rounded,
      CaptureMode.selfie => Icons.camera_front_rounded,
      CaptureMode.product => Icons.shopping_bag_rounded,
      CaptureMode.creative => Icons.auto_awesome_rounded,
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(MuseSpacing.radiusLg),
          border: Border.all(
            color: MuseColors.primary.withValues(alpha: 0.18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(MuseSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                  child: Icon(
                    iconData,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                mode.displayName,
                style: MuseTypography.labelLg.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                mode.description,
                style: MuseTypography.bodySm.copyWith(
                  color: MuseColors.textSecondary,
                ),
              ),
              const SizedBox(height: MuseSpacing.md),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: MuseColors.primary.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Open camera',
                  style: MuseTypography.labelSm.copyWith(
                    color: MuseColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentCaptureTile extends StatelessWidget {
  final int index;

  const _RecentCaptureTile({required this.index});

  @override
  Widget build(BuildContext context) {
    final gradient = [
      Color.lerp(const Color(0xFF7A4E2F), const Color(0xFF2A3142), index / 6)!,
      Color.lerp(const Color(0xFF14161D), const Color(0xFF1E222D), index / 6)!,
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MuseSpacing.radiusMd),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 10,
            right: 10,
            bottom: 10,
            child: Text(
              'Capture ${index + 1}',
              style: MuseTypography.labelSm.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Positioned(
            top: 10,
            right: 10,
            child: Icon(
              Icons.photo_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final String title;
  final String description;
  final List<Color> colors;

  const _ThemeCard({
    required this.title,
    required this.description,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MuseSpacing.radiusLg),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(MuseSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              style: MuseTypography.labelLg.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: MuseTypography.bodySm.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeCardData {
  final String title;
  final String description;
  final List<Color> colors;

  const _ThemeCardData({
    required this.title,
    required this.description,
    required this.colors,
  });
}

const _themeCards = [
  _ThemeCardData(
    title: 'Golden Hour',
    description: 'Warm portraits with soft contrast and glow.',
    colors: [Color(0xFF7A4E2F), Color(0xFF1A1620)],
  ),
  _ThemeCardData(
    title: 'Clean Product',
    description: 'Bright, minimal framing for objects.',
    colors: [Color(0xFF223044), Color(0xFF10161E)],
  ),
  _ThemeCardData(
    title: 'Editorial Edge',
    description: 'Bold shadows and dramatic angles.',
    colors: [Color(0xFF2F1C31), Color(0xFF12111A)],
  ),
];