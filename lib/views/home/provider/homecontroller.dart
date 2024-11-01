import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iguru/funs/loc.dart';
import 'package:iguru/funs/user.dart';
import 'package:iguru/models/user_mdel.dart';
import 'package:image_picker/image_picker.dart';

class HomeController extends GetxController {
  RxBool isLoading = true.obs;

  Box userImages = Hive.box('user');

  load({load}) {
    if (load == null) {
      isLoading.value = !isLoading.value;
    } else {
      isLoading.value = load;
    }
    update();
  }

  Position? userPosition;

  List<UserLst> userlst = [];

  int _page = 1;

  bool _hasData = true;

  @override
  void onInit() {
    super.onInit();
    UserLocation().fetchLocation().then((value) {
      userPosition = value;
      refresh();
    });
    getusers(true);
  }

  RxString get userLatlng {
    if (userPosition == null) {
      return "".obs;
    } else {
      return "Device LatLngs ${userPosition!.latitude} : ${userPosition!.longitude}".obs;
    }
  }

  getusers(bool isFirst) {
    if (isFirst) {
      _page = 1;
      _hasData = true;
      userlst.clear();
    } else {
      _page = _page + 1;
    }
    if (_hasData) {
      load(load: true);
      UserClass().getUsers(page: _page).then((value) {
        if (isFirst) {
          userlst = value.userLst;
        } else {
          userlst.addAll(value.userLst);
        }

        if (value.total == userlst.length) {
          _hasData = false;
        }
      }).whenComplete(() => load(load: false));
    }
  }

  bool hasImage(int id) {
    return userImages.containsKey(id);
  }

  Uint8List storedImage(int id) {
    return userImages.get(id);
  }

  removeImage(int id) {
    userImages.delete(id).whenComplete(() {
      update();
    });
  }

  Future saveUserImage(int id, XFile file) {
    return file.readAsBytes().then((value) {
      userImages.put(id, value).whenComplete(() {
        log("Uploaddd");
        update();
      });
    });
  }
}
