import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iguru/models/user_mdel.dart';
import 'package:iguru/utils/pic_image.dart';
import 'package:iguru/views/home/provider/homecontroller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: Text(controller.userLatlng.value),
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification && notification.metrics.extentAfter == 0) {
              controller.getusers(false);
              return true;
            }
            return false;
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                ...List.generate(controller.userlst.length, (index) {
                  UserLst model = controller.userlst[index];
                  return ListTile(
                    leading: controller.userImages.containsKey(model.id)
                        ? GestureDetector(
                            onLongPress: () {
                              controller.removeImage(model.id);
                            },
                            child: Image.memory(controller.storedImage(model.id)))
                        : Image.network(model.avatar),
                    title: Text("${model.firstName} ${model.lastName}"),
                    subtitle: Text(model.email),
                    trailing: IconButton(
                      icon: const Icon(Icons.upload),
                      onPressed: () {
                        showimagePicker(context, (v) {
                          if (v != null) {
                            controller.saveUserImage(model.id, v).then((value) {
                              controller.update();
                            });
                            log("message");
                          }
                        });
                      },
                    ),
                  );
                }),
                if (controller.isLoading.value) const Center(child: CircularProgressIndicator()),
                const SizedBox(height: 500),
              ],
            ),
          ),
        ),
      );
    });
  }
}
