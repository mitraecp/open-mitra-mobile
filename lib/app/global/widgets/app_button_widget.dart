import 'package:flutter/material.dart';
import 'package:open_mitra_mobile/app/theme/colors.dart';

enum AppButtonStyle {
  text,
  outlined,
  contained,
}

class AppButtonWidget extends StatelessWidget {
  final AppButtonStyle style;
  final Widget? child;
  final void Function()? onPressed;
  final bool disableButton;
  final bool loading;
  final double borderRadius;
  final Color? buttonColor;
  final double buttonHeight;

  // ignore: use_super_parameters
  const AppButtonWidget({
    Key? key,
    this.style = AppButtonStyle.contained,
    this.child,
    this.onPressed,
    this.borderRadius = 8,
    this.disableButton = false,
    this.loading = false,
    this.buttonColor = GlobalColors.violet_600,
    this.buttonHeight = 44,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (style == AppButtonStyle.outlined) {
      return Container(
        height: buttonHeight,
        // width: MediaQuery.of(context).size.width * 0.35,
        decoration: BoxDecoration(
          border: Border.all(color: GlobalColors.grey_300),
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          boxShadow: const [
            GlobalColors.shadow_xs,
          ],
        ),
        child: TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          ),
          onPressed: disableButton ? null : onPressed,
          child: child!,
        ),
      );
    }

    if (style == AppButtonStyle.text && child != null) {
      return TextButton(
        onPressed: onPressed,
        child: child!,
      );
    }
    //NOTE: Verifica a versão do botão, se é desabilitado ou habilitado.
    return !disableButton
        //NOTE: A versão habilitado tem a cor normal e retorna uma função.
        ? _buildActiveButton()
        //NOTE: Versão do botão desabilidado, a cor fica desfocada e retorna uma função vazia.
        : _buildDisabledButton();
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.white,
        strokeAlign: -4.0,
        strokeWidth: 3.0,
      ),
    );
  }

  Widget _buildActiveButton() {
    return Container(
      height: buttonHeight,
      // width: MediaQuery.of(context).size.width * 0.35,
      decoration: BoxDecoration(
        color: buttonColor == GlobalColors.violet_600 ? GlobalColors.appPrimary_600 : buttonColor,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        boxShadow: const [
          GlobalColors.shadow_xs,
        ],
      ),
      child: loading
          ? _buildLoading()
          : TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
              ),
              onPressed: onPressed,
              child: child!,
            ),
    );
  }

  Widget _buildDisabledButton() {
    return Container(
      height: buttonHeight,
      // width: MediaQuery.of(context).size.width * 0.35,
      decoration: BoxDecoration(
        color: GlobalColors.appPrimary_200,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
        onPressed: () {},
        child: child!,
      ),
    );
  }
}
