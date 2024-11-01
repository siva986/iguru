class UserDataModel {
  int page;
  int perPage;
  int total;
  int totalPages;
  List<UserLst> userLst;

  UserDataModel({
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
    required this.userLst,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
        page: json["page"],
        perPage: json["per_page"],
        total: json["total"],
        totalPages: json["total_pages"],
        userLst: List<UserLst>.from(json["data"].map((x) => UserLst.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "per_page": perPage,
        "total": total,
        "total_pages": totalPages,
        "data": List<dynamic>.from(userLst.map((x) => x.toJson())),
      };
}

class UserLst {
  int id;
  String email;
  String firstName;
  String lastName;
  String avatar;

  UserLst({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory UserLst.fromJson(Map<String, dynamic> json) => UserLst(
        id: json["id"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "avatar": avatar,
      };
}
