import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/controllers/intro_screen_controller.dart';

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
              width: Get.width, // Largura do container
              height: Get.height, // Altura do container
              decoration: const BoxDecoration(color: Colors.black),
            ),
          ),
        );
      },
    );
  }
}
