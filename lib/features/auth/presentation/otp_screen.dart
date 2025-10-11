import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/helpers/snackbar.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/auth/cubits/verify_otp_cubit.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/design/widgets/gps_description.dart';
import 'package:gps_app/features/design/widgets/pinleaf_logo.dart';
import 'package:pinput/pinput.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key, this.onNext});
  final void Function()? onNext;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => VerifyOtpCubit(), child: OTPWidget(onNext));
  }
}

class OTPWidget extends StatefulWidget {
  const OTPWidget(this.onNext, {super.key});
  final void Function()? onNext;

  @override
  State<OTPWidget> createState() => _OTPWidgetState();
}

class _OTPWidgetState extends State<OTPWidget> {
  final _formKey = GlobalKey<FormState>();
  String otp = '';
  @override
  void initState() {
    if (widget.onNext == null) {
      _requestOtp();
    }
    super.initState();
  }

  Future _requestOtp() async {
    final response = (await context.read<VerifyOtpCubit>().requestOtp()).response;
    if (response == ResponseEnum.success) {
      showSnackbar('Success', "New OTP code is sended to your email", false);
    } else {
      showSnackbar(
        'Error',
        "Sorry we couldn't send OTP to your email, please try again later",
        true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerifyOtpCubit, ApiResponseModel>(
      listener: (context, state) async {
        if (state.response == ResponseEnum.success) {
          if (widget.onNext != null) {
            widget.onNext!();
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(AppRoutesNames.entryPoint, (_) => false);
          }
        }
      },
      builder: (context, state) {
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
                        length: 6,
                        onCompleted: (code) async {
                          pr(code);
                          otp = code;
                          await context.read<VerifyOtpCubit>().verifyOtp(code: code);
                        },
                      ).animate().fadeIn(duration: 280.ms, delay: 120.ms).slideY(begin: .08),
                      GPSGaps.h24,
                      ElevatedButton(
                        onPressed: () async {
                          pr(otp, 'otp');
                          // Navigator.of(context).pushNamedAndRemoveUntil(
                          //   AppRoutesNames.restaurantOnboardingMenuScreen,
                          //   (_) => false,
                          // );
                          if (otp.length < 6) return;
                          await context.read<VerifyOtpCubit>().verifyOtp(code: otp);
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
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      _requestOtp();
                                    },
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
      },
    );
  }
}
