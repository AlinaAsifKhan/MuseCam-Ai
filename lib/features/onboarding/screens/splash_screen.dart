import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../core/constants/spacing.dart';
import '../../../shared/widgets/muse_gradient_button.dart';
import '../../../shared/widgets/video_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Fade-in animation for content
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      body: VideoBackground(
        videoPath: 'assets/images/732bbd80-8897-4306-bb86-218da2c59e5f_tOC9sgyN.mp4',
        child: Stack(
          children: [
            // Main content
            FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                child: SizedBox(
                  height: screenSize.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top spacer
                      SizedBox(height: screenSize.height * 0.12),

                      // Center section: Logo + Title + Tagline
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo - Simple, no frame
                          Image.asset(
                            'assets/images/logo.png',
                            width: 140,
                            height: 140,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: MuseColors.surface,
                                ),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  size: 80,
                                  color: MuseColors.primary,
                                ),
                              );
                            },
                          ),
                          
                          SizedBox(height: screenSize.height * 0.08),

                          // App Name
                          Text(
                            'MuseCam AI',
                            style: MuseTypography.displayXL,
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: MuseSpacing.md),

                          // Tagline
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: MuseSpacing.lg,
                            ),
                            child: Text(
                              'See the Shot Before You Take It.',
                              style: MuseTypography.bodyMdSecondary.copyWith(
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),

                      // Bottom section: Buttons
                      Padding(
                        padding: const EdgeInsets.all(MuseSpacing.lg),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Primary CTA Button
                            MuseGradientButton(
                              label: 'Start Capturing',
                              onPressed: () {
                                context.go('/home');
                              },
                              showShimmer: true,
                            ),

                            const SizedBox(height: MuseSpacing.lg),

                            // Secondary buttons row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Sign In
                                TextButton(
                                  onPressed: () {
                                    // TODO: Navigate to login
                                  },
                                  child: Text(
                                    'Sign In',
                                    style: MuseTypography.labelLg.copyWith(
                                      color: MuseColors.textSecondary,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: MuseSpacing.md),

                                // Divider
                                Container(
                                  width: 1,
                                  height: 20,
                                  color: MuseColors.textSecondary.withValues(alpha: 0.3),
                                ),

                                const SizedBox(width: MuseSpacing.md),

                                // Continue as Guest
                                TextButton(
                                  onPressed: () {
                                    context.go('/home');
                                  },
                                  child: Text(
                                    'Continue as Guest',
                                    style: MuseTypography.labelLg.copyWith(
                                      color: MuseColors.mauveRoseTaupe,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: MuseSpacing.md),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
