import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:todo_getx/app/core/utils/extentions.dart';
import 'package:todo_getx/app/core/values/colors.dart';
import 'package:todo_getx/app/modules/home/widgets/add_text_feild.dart';

import '../controller.dart';

class AddDialog extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();

  AddDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) => false,
      child: Scaffold(
        body: Form(
          key: homeCtrl.formKey,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(3.0.wp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                        homeCtrl.editController.clear();
                        homeCtrl.changeTask(null);
                      },
                      icon: Icon(
                        Icons.close,
                        size: 7.0.wp,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (homeCtrl.formKey.currentState!.validate()) {
                          if (homeCtrl.task.value == null) {
                            EasyLoading.showError('Please Select task Type');
                          } else {
                            var success = homeCtrl.updateTask(
                              homeCtrl.task.value!,
                              homeCtrl.editController.text,
                              homeCtrl.pathToAudio.value,
                            );
                            if (success) {
                              EasyLoading.showSuccess(
                                  'Item added Successfully');
                              Get.back();
                              homeCtrl.changeTask(null);
                            } else {
                              EasyLoading.showError('Todo Item Already exist');
                            }

                            homeCtrl.changePath('');
                            homeCtrl.editController.clear();
                          }
                        }
                      },
                      icon: Icon(
                        Icons.add,
                        size: 7.0.wp,
                        color: blue,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                child: Text(
                  'New Task',
                  style:
                      TextStyle(fontSize: 20.0.sp, fontWeight: FontWeight.bold),
                ),
              ),
              const AddTextFeild(),
              Padding(
                padding: EdgeInsets.only(
                  top: 5.0.wp,
                  left: 5.0.wp,
                  right: 5.0.wp,
                  bottom: 2.0.wp,
                ),
                child: Text(
                  'Add to',
                  style: TextStyle(
                    fontSize: 14.0.sp,
                    color: Colors.grey,
                  ),
                ),
              ),
              ...homeCtrl.tasks
                  .map((element) => Obx(
                        () => InkWell(
                          onTap: () => homeCtrl.changeTask(element),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 3.0.wp,
                              horizontal: 5.0.wp,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      IconData(element.icon,
                                          fontFamily: 'MaterialIcons'),
                                      color: HexColor.fromHex(element.color),
                                    ),
                                    SizedBox(width: 3.0.wp),
                                    Text(
                                      element.title,
                                      style: TextStyle(
                                        fontSize: 12.0.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                if (homeCtrl.task.value == element)
                                  const Icon(
                                    Icons.check,
                                    color: blue,
                                  )
                              ],
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
