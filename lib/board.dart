import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:real_volume/real_volume.dart';

enum VolumeEventType { volumeUp, volumeDown, none }

class SB_BoardPage extends StatefulWidget {

  @override
  State<SB_BoardPage> createState() => _SB_BoardPageState();
}

class _SB_BoardPageState extends State<SB_BoardPage> {

  late int user1, user2;
  late int user1_set, user2_set;
  late double temp;
  late VolumeEventType type;
  late double height, width;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user1 = 0;
    user2 = 0;
    user1_set = 0;
    user2_set = 0;
    temp = 0;
    type = VolumeEventType.none;
    Future.microtask(() async {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetooth,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.bluetoothAdvertise
      ].request();
      await RealVolume.setAudioMode(AudioMode.RINGTONE);
      RealVolume.onVolumeChanged.listen((event) {
        double volume = event.volumeLevel;
        if(temp < volume){
          type = VolumeEventType.volumeUp;
          user1 += 1;
        } else
        if(temp > volume){
          type = VolumeEventType.volumeDown;
          user2 += 1;
        } else
        if(temp == volume){
          if(type == VolumeEventType.volumeUp){
            user1 += 1;
          } else
          if(type == VolumeEventType.volumeDown){
            user2 += 1;
          }
        }
        setState(() {
          temp = volume;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    Size size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          Expanded(
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(width: 5, color: Colors.white)
                ),
                child: Column(
                  children: [
                    Expanded(
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              user1 += 2;
                            });
                          },
                          child: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(vertical: 2.5),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 2.5, color: Colors.white)
                              ),
                              child: Text("${user1 ~/ 2}", style: TextStyle(fontSize: height * 0.3, color: (user1 != 0 && (user1 ~/ 2) % 10 == 0) ? Colors.yellow.shade400 : Colors.white, fontWeight: FontWeight.bold))
                          ),
                        )
                    ),
                    GestureDetector(
                      onTap: (){
                        if(user1 > 0){
                          setState(() {
                            user1 -= 1;
                          });
                        }
                      },
                      child: Container(
                        height: height * 0.15,
                        width: double.infinity,
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(vertical: 2.5),
                        decoration: BoxDecoration(
                            color: Colors.grey
                        ),
                        child: Text("-1", style: TextStyle(fontSize: height * 0.1, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                )
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: height * 0.45,
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(width: 5, color: Colors.white)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("SET", style: TextStyle(fontSize: height * 0.1, color: Colors.white, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      user1_set += 1;
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 2.5, color: Colors.white)
                                    ),
                                    child: Text("$user1_set", style: TextStyle(fontSize: height * 0.2, color: Colors.yellow.shade400, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      user2_set += 1;
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 2.5, color: Colors.white)
                                    ),
                                    child: Text("$user2_set", style: TextStyle(fontSize: height * 0.2, color: Colors.yellow.shade400, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            border: Border.all(width: 5, color: Colors.white)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  user1 = 0;
                                  user2 = 0;
                                  temp = 0;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.all(5),
                                alignment: Alignment.center,
                                height: height * 0.1,
                                decoration: BoxDecoration(
                                    color: Colors.yellow.shade700
                                ),
                                child: Text("SCORE RESET", style: TextStyle(fontSize: height * 0.07, color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  temp = 0;
                                  user1 = 0;
                                  user2 = 0;
                                  user1_set = 0;
                                  user2_set = 0;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.all(5),
                                alignment: Alignment.center,
                                height: height * 0.1,
                                decoration: BoxDecoration(
                                    color: Colors.red.shade200
                                ),
                                child: Text("ALL RESET", style: TextStyle(fontSize: height * 0.07, color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                int temp, temp_set;
                                temp = user1;
                                temp_set = user1_set;
                                setState(() {
                                  user1 = user2;
                                  user1_set = user2_set;
                                  user2 = temp;
                                  user2_set = temp_set;
                                });;
                              },
                              child: Container(
                                margin: EdgeInsets.all(5),
                                alignment: Alignment.center,
                                height: height * 0.1,
                                decoration: BoxDecoration(
                                    color: Colors.green.shade300
                                ),
                                child: Text("CHANGE", style: TextStyle(fontSize: height * 0.07, color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            )
                          ],
                        )
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(width: 5, color: Colors.white)
              ),
              child: Column(
                children: [
                  Expanded(
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            user2 += 2;
                          });
                        },
                        child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(vertical: 2.5),
                            decoration: BoxDecoration(
                                border: Border.all(width: 2.5, color: Colors.white)
                            ),
                            child: Text("${user2 ~/ 2}", style: TextStyle(fontSize: height * 0.3, color: (user2 != 0 && (user2 ~/ 2) % 10 == 0) ? Colors.yellow.shade400 : Colors.white, fontWeight: FontWeight.bold))
                        ),
                      )
                  ),
                  GestureDetector(
                    onTap: (){
                      if(user2 > 0){
                        setState(() {
                          user2 -= 1;
                        });
                      }
                    },
                    child: Container(
                      height: height * 0.15,
                      width: double.infinity,
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(vertical: 2.5),
                      decoration: BoxDecoration(
                          color: Colors.grey
                      ),
                      child: Text("-1", style: TextStyle(fontSize: height * 0.1, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
