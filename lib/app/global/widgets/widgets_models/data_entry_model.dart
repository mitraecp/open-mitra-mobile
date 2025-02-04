class DataEntryModel {
  int? componentId;
  String? value;
  String? name;
  String? type;
  double? axisY;
  int? fieldHeight;
  int? blockId;
  int? row;
  int? col;

  DataEntryModel({
    this.componentId,
    this.value,
    this.name,
    this.type,
    this.axisY,
    this.fieldHeight,
    this.blockId,
    this.row,
    this.col,
  });

  factory DataEntryModel.fromJson(Map<String, dynamic> json) {
    var data = json["data"];
    return DataEntryModel(
      componentId: data["id"],
      value: data["value"].toString(),
      name: data["name"],
      type: data["type"],
      axisY: data["y"],
      fieldHeight: data["height"].toInt(),
      blockId: data["blockId"],
      row: data["row"],
      col: data["col"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = componentId;
    data['name'] = name;
    data['value'] = value;
    data['type'] = type;
    data['y'] = axisY;
    data['height'] = fieldHeight;
    return data;
  }
}
