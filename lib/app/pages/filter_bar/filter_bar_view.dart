import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:open_mitra_mobile/app/controllers/filter_bar_controller.dart';
import 'package:open_mitra_mobile/app/global/widgets/mitra_divider_widget.dart';
import 'package:open_mitra_mobile/app/pages/filter_bar/widgets/body_filter_bar_widget.dart';
import 'package:open_mitra_mobile/app/pages/filter_bar/widgets/bottom_filter_bar_widget.dart';
import 'package:open_mitra_mobile/app/pages/filter_bar/widgets/head_filter_bar_widget.dart';
import 'package:open_mitra_mobile/app/theme/dimensions.dart';


// Todo: Tentar mudar ele para um StateLess
class FilterBarView extends StatefulWidget {
  final FilterBarController controller = Get.find();
  FilterBarView({Key? key}) : super(key: key);

  @override
  State<FilterBarView> createState() => _FilterBarViewState();
}

class _FilterBarViewState extends State<FilterBarView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(18),
        ),
        color: Colors.white,
      ),
      height: Get.height * .92,
      child: FutureBuilder(
        future: widget.controller.getFilterBarListById(widget.controller
            .mobileScreenController.selectedScreen.value.filterBarId!),
        builder: (context, snapshot) {
          return snapshot.hasData && widget.controller.loading.isFalse
              ? _buildFilterBody()
              : _buildLoadingFilterBody();
        },
      ),
    );
  }

  Widget _buildFilterBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        //NOTE: Cabeça da pagina.
        filterHead(context, widget.controller),

        const MitraDividerWidget(),
        const SizedBox(height: SpacingScale.scaleOne),
        //NOTE: Corpo da pagina.
        Expanded(
            child: BodyFilterListViewWidget(controller: widget.controller)),
        // NOTE: FInal da pagina
        const MitraDividerWidget(),
        const SizedBox(height: SpacingScale.scaleTwo),
        filterBottom(widget.controller),
        const SizedBox(height: SpacingScale.scaleFour),
      ],
    );
  }

  Widget _buildLoadingFilterBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          splashColor: const Color(0xff2C2C42),
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Color.fromRGBO(1, 208, 250, 1),
            size: 32,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        const Center(child: CircularProgressIndicator()),
        const SizedBox(),
      ],
    );
  }
}
