import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/features/about/cubits/about_cubit.dart';
import 'package:gps_app/features/about/models/about_model.dart';
import 'package:gps_app/features/about/presentation/widgets/about_loading_state.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/design/widgets/pinleaf_logo.dart';

// --- AboutScreen (no external params) ---
class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  void initState() {
    context.read<AboutCubit>().about();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<AboutCubit, ApiResponseModel<AboutModel>>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: GPSColors.background,
          appBar: AppBar(
            title: const Text('About'),
            centerTitle: true,
            backgroundColor: GPSColors.primary,
            elevation: 0,
          ),
          body: SafeArea(
            child:
                state.response == ResponseEnum.loading || state.data == null
                    ? AboutLoadingState()
                    : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image header
                          state.data!.image == null
                              ? Center(child: const PinLeafLogo(size: 140, isSplashScreen: false))
                              : _imageHeader(state.data!)
                                  .animate()
                                  .fadeIn(duration: 550.ms)
                                  .slideY(begin: 0.04, end: 0, duration: 550.ms),

                          GPSGaps.h16,

                          // Title card (uses only about.title)
                          _titleCard(textTheme, state.data!)
                              .animate(delay: 140.ms)
                              .fadeIn(duration: 480.ms)
                              .moveY(begin: 8, end: 0, duration: 480.ms),

                          GPSGaps.h12,

                          // Content block (uses only about.content)
                          _contentCard(textTheme, state.data!)
                              .animate(delay: 300.ms)
                              .fadeIn(duration: 520.ms)
                              .blur(
                                begin: Offset(2.0, 2.0),
                                end: Offset(0.0, 0.0),
                                duration: 520.ms,
                              ),

                          GPSGaps.h16,
                        ],
                      ),
                    ),
          ),
        );
      },
    );
  }

  // IMAGE HEADER (only uses about.image)
  Widget _imageHeader(AboutModel about) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
            height: 200,
            width: double.infinity,
            child:
                about.image != null && about.image!.isNotEmpty
                    ? Image.network(
                      about.image!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: GPSColors.cardSelected,
                          child: const Center(child: CircularProgressIndicator()),
                        );
                      },
                      errorBuilder: (c, e, s) {
                        return Container(
                          color: GPSColors.cardSelected,
                          child: const Center(child: Icon(Icons.broken_image, size: 40)),
                        );
                      },
                    )
                    : Container(
                      color: GPSColors.cardSelected,
                      child: const Center(child: Icon(Icons.image, size: 40)),
                    ),
          )
          // apply subtle parallax-like scaling on entrance
          .animate()
          .scale(begin: Offset(1.02, 1.02), end: Offset(1.0, 1.0), duration: 650.ms),
    );
  }

  Widget _titleCard(TextTheme textTheme, AboutModel about) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GPSColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: GPSColors.primary,
              borderRadius: BorderRadius.circular(6),
            ),
          ).animate().fade(duration: 900.ms, curve: Curves.easeInOut),

          GPSGaps.w10,

          Expanded(
            child: Text(
              about.title ?? '',
              style: textTheme.titleLarge?.copyWith(
                color: GPSColors.text,
                fontWeight: FontWeight.w700,
              ),
            ).animate().moveX(begin: -6, end: 0, duration: 420.ms).fadeIn(duration: 420.ms),
          ),
        ],
      ),
    );
  }

  // CONTENT CARD (only uses about.content)
  Widget _contentCard(TextTheme textTheme, AboutModel about) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GPSColors.cardBorder),
      ),
      padding: const EdgeInsets.all(16),
      child: Text(
        about.content ?? '',
        style: textTheme.bodyLarge?.copyWith(color: GPSColors.text, height: 1.6),
      ).animate().fadeIn(duration: 600.ms).moveY(begin: 14, end: 0, duration: 600.ms),
    );
  }
}
