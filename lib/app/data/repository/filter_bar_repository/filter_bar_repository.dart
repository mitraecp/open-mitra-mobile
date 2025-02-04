

import 'package:open_mitra_mobile/app/data/providers/filter_bar_provider.dart';

class FilterBarRepository {
  final FilterBarProvider apiClient = FilterBarProvider();

  getFilterBarConfigById(int filterBarId) {
    return apiClient.getFilterBarConfigById(filterBarId);
  }

  getFilterBarSelectionsByFilterId(int screenId) {
    return apiClient.getFilterBarSelectionsByFilterId(screenId);
  }

  setFilterDimensionContents({
    required int screenComponentId,
    required int screenId,
    required int dimensionId,
    required List<String> dimensionValue,
    bool isApplyFilter = false,
  }) {
    apiClient.setFilterDimensionContents(
      screenComponentId: screenComponentId,
      screenId: screenId,
      dimensionId: dimensionId,
      dimensionValue: dimensionValue,
      isApplyFilter: isApplyFilter,
    );
  }

  setDayFilterDimensionContents({
    required int screenComponentId,
    required int screenId,
    required int dimensionId,
    String? startDayId,
    String? endDayId,
    bool isApplyFilter = false,
  }) {
    apiClient.setDayFilterDimensionContents(
      screenComponentId: screenComponentId,
      screenId: screenId,
      dimensionId: dimensionId,
      startDayId: startDayId,
      endDayId: endDayId,
      isApplyFilter: isApplyFilter,
    );
  }

  Future<void> deleteTempFilters({required int screenId}) {
    return apiClient.deleteTempFilters(screenId: screenId);
  }
}
