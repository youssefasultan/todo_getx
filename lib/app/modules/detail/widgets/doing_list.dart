import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_getx/app/core/utils/extentions.dart';

import '../../home/controller.dart';

class DoingList extends StatefulWidget {
  const DoingList({super.key});

  @override
  State<DoingList> createState() => _DoingListState();
}

class _DoingListState extends State<DoingList> {
  final homeCtrl = Get.find<HomeController>();
  bool isPlaying = false;
  late PlayerController playerController;

  @override
  void initState() {
    playerController = PlayerController();
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
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => homeCtrl.doingTodos.isEmpty && homeCtrl.doneTodos.isEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/checklist.png',
                  fit: BoxFit.cover,
                  width: 65.0.wp,
                ),
                Text(
                  'Add Task',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0.sp,
                  ),
                )
              ],
            )
          : ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                ...homeCtrl.doingTodos
                    .map(
                      (element) => Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 3.0.wp,
                          horizontal: 9.0.wp,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                fillColor: MaterialStateProperty.resolveWith(
                                  (states) => Colors.grey,
                                ),
                                value: element.done,
                                onChanged: (value) {
                                  homeCtrl.doneToDo(element.title);
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.0.wp),
                              child: Text(
                                element.title,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (element.voiceNotePath.isNotEmpty)
                              !isPlaying
                                  ? IconButton(
                                      onPressed: () =>
                                          playRecording(element.voiceNotePath),
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
                          ],
                        ),
                      ),
                    )
                    .toList(),
                if (homeCtrl.doingTodos.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                    child: const Divider(thickness: 2),
                  )
              ],
            ),
    );
  }

  playRecording(String path) async {
    if (path.isNotEmpty) {
      await playerController.preparePlayer(
        path: path,
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
