class CurrentUserModel {
  int? id;
  String? name;
  String? email;
  bool? isDev;

  CurrentUserModel({
    this.id,
    this.name,
    this.email,
    this.isDev,
  });

  CurrentUserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        email = json['username'] as String?,
        isDev = json['isDev'] as bool?;

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'username': email, 'isDev': isDev};
}
