import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/design/widgets/gps_description.dart';
import 'package:gps_app/features/design/widgets/pinleaf_logo.dart';
import 'package:pinput/pinput.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key, required this.onNext});
  final void Function() onNext;
  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GPSColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const PinLeafLogo(size: 140),
                  GPSGaps.h24,
                  Center(child: GpsShortDescription()),

                  GPSGaps.h12,
                  Text(
                    'Check your inbox!\nEnter the code we sent to you',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                    textAlign: TextAlign.center,
                  ),
                  GPSGaps.h12,
                  Pinput(
                    onCompleted: (pin) => pr(pin),
                  ).animate().fadeIn(duration: 280.ms, delay: 120.ms).slideY(begin: .08),
                  GPSGaps.h24,
                  ElevatedButton(
                    onPressed: () async {
                      widget.onNext();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GPSColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Next', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  GPSGaps.h12,
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: GPSColors.mutedText),
                      children: [
                        const TextSpan(text: "No code yet? "),
                        TextSpan(
                          text: ' Send it again',
                          style: const TextStyle(
                            color: GPSColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                      ],
                    ),
                  ).animate().fadeIn().slideY(begin: .06),
                  GPSGaps.h12,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
