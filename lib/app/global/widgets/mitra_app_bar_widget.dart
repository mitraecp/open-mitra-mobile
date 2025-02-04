import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';

class MitraAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget appTitle;
  final bool centerAppBar;
  final Widget appLeading;
  final double? appLeadingWidth;
  final double? appTitleSpacing;
  final List<Widget> appAction;
  final RxBool isToAddOnTopContainer;

  const MitraAppBar({
    Key? key,
    required this.appTitle,
    this.centerAppBar = false,
    required this.appLeading,
    this.appAction = const [SizedBox()],
    this.appLeadingWidth,
    this.appTitleSpacing = 0,
    required this.isToAddOnTopContainer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: SpacingScale.scaleHalf),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: GlobalColors.grey_200, // Cor da borda
                width: 1.0, // Largura da borda
              ),
            ),
          ),
          child: AppBar(
            title: appTitle,
            centerTitle: centerAppBar,
            leadingWidth: appLeadingWidth,
            elevation: 0,
            titleSpacing: appTitleSpacing,
            leading: appLeading,
            actions: appAction,
            scrolledUnderElevation: 0,
            backgroundColor: Colors.white,
            // Defina a elevação para 0 para remover a sombra padrão
          ),
        ),
        Obx(
          () => isToAddOnTopContainer.value
              ? Container(
                  color: const Color.fromRGBO(0, 0, 0, 0.35),
                )
              : const SizedBox(height: 1, width: 1,),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
