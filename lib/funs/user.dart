import 'package:iguru/const/apis.dart';
import 'package:iguru/funs/api_helper.dart';
import 'package:iguru/models/user_mdel.dart';

class UserClass {
  Future<UserDataModel> getUsers({int page = 0}) {
    return ApiHelper("$getUsersApi$page").get().then((value) {
      return UserDataModel.fromJson(value);
    });
  }
}
