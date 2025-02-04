class RelationShipDimension {
  String? parentId;
  String? descr;
  bool tempSelected;

  RelationShipDimension({
    this.parentId,
    this.descr,
    this.tempSelected = false,
  });

  factory RelationShipDimension.fromJson(Map<String, dynamic> json) {
    return RelationShipDimension(
      parentId: json["id"],
      descr: json["descr"],
    );
  }
}
