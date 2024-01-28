import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:todo_getx/app/core/utils/extentions.dart';

import '../../../core/values/colors.dart';
import '../controller.dart';

class AddTextFeild extends StatefulWidget {
  const AddTextFeild({super.key});

  @override
  State<AddTextFeild> createState() => _AddTextFeildState();
}

class _AddTextFeildState extends State<AddTextFeild> {
  final homeCtrl = Get.find<HomeController>();

  late RecorderController recorderController;
  late PlayerController playerController;
  bool isRecording = false;
  bool isPlaying = false;
  late String? pathToAudio;

  @override
  void initState() {
    recorderController = RecorderController();
    playerController = PlayerController();
    pathToAudio = '';
    playerController.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.stopped) {
        setState(() {
          isPlaying = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    recorderController.dispose();
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
      child: isRecording
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AudioWaveforms(
                  size: Size(70.0.wp, 4.0.wp),
                  recorderController: recorderController,
                  enableGesture: true,
                  padding: EdgeInsets.symmetric(
                    vertical: 5.0.wp,
                    horizontal: 2.0.wp,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 168, 204, 234),
                    border: Border.all(
                      width: 2,
                      color: blue.withOpacity(0.5),
                    ),
                    borderRadius: BorderRadius.circular(20.0.wp),
                  ),
                  waveStyle: const WaveStyle(
                    waveColor: blue,
                    spacing: 4.0,
                    showMiddleLine: false,
                    extendWaveform: true,
                  ),
                ),
                IconButton(
                  onPressed: stopRecording,
                  icon: const Icon(
                    Icons.stop,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: homeCtrl.editController,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey[400]!,
                        ),
                      ),
                    ),
                    autofocus: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please Enter a Todo title';
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (pathToAudio != null && pathToAudio!.isNotEmpty)
                      !isPlaying
                          ? IconButton(
                              onPressed: playRecording,
                              icon: const Icon(
                                Icons.play_arrow,
                                color: Colors.green,
                              ),
                            )
                          : IconButton(
                              onPressed: stopPlaying,
                              icon: const Icon(
                                Icons.stop,
                                color: Colors.red,
                              ),
                            ),
                    IconButton(
                      onPressed: startRecording,
                      icon: const Icon(
                        Icons.mic,
                        color: blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Future<void> startRecording() async {
    try {
      Map<Permission, PermissionStatus> permissions = await [
        Permission.storage,
        Permission.microphone,
      ].request();

      bool permissionsGranted = permissions[Permission.storage]!.isGranted &&
          permissions[Permission.microphone]!.isGranted;

      if (permissionsGranted) {
        final dir = await getApplicationDocumentsDirectory();
        Directory appFolder = Directory(dir.path);
        bool appFolderExists = await appFolder.exists();
        if (!appFolderExists) {
          final created = await appFolder.create(recursive: true);
          if (kDebugMode) {
            print(created.path);
          }
        }

        final filepath =
            '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.rn';
        if (kDebugMode) {
          print(filepath);
        }

        await recorderController.record(path: filepath);

        setState(() {
          isRecording = true;
        });
      }
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  void stopRecording() async {
    pathToAudio = await recorderController.stop();
    setState(() {
      isRecording = false;
    });

    homeCtrl.changePath(pathToAudio!);

    if (kDebugMode) {
      print('Output path $pathToAudio');
    }
  }

  void playRecording() async {
    if (pathToAudio != null && pathToAudio!.isNotEmpty) {
      await playerController.preparePlayer(
        path: pathToAudio!,
        shouldExtractWaveform: true,
        noOfSamples: 100,
        volume: 1.0,
      );

      await playerController.startPlayer(finishMode: FinishMode.stop);

      setState(() {
        isPlaying = true;
      });
    }
  }

  void stopPlaying() async {
    await playerController.stopPlayer();
    setState(() {
      isPlaying = false;
    });
  }
}
