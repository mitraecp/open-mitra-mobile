import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/controllers/intro_screen_controller.dart';
import 'package:open_mitra_mobile/app/global/constants.dart';
import 'package:open_mitra_mobile/settings/project_config.dart';

class SplashScreenView extends GetView<IntroScreenController> {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        controller.setGlobalUserDisplay(constraints);
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: Scaffold(
            body: Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: appProjectLogoUrl == ''
                      ? appProjectLocalLogoPath == ''
                          ? Image.network(
                              emptyLogoUrl,
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              appProjectLocalLogoPath,
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            )
                      : Image.network(
                          appProjectLogoUrl,
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
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
