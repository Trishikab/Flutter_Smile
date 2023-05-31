import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'home/home.dart';
import 'package:flutter_ipfs/flutter_ipfs.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(
'$counter'
        );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.storage});
  final CounterStorage storage;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  String getCurrentDate() {
    var now = DateTime.now();
    var formatter = DateFormat('MM/dd(EEE)');
    return formatter.format(now);
  }

  late var h;
  final _homeController = HomeController();
  var selected = false;
  var selected1 = false;
  var selected2 = false;
  var selected3 = false;
  var selected4 = false;
  int time = 4;
  String lbl = '+ 0';
  String lbl1 = '+ 0';
  String lbl2 = '+ 0';
  String lbl3 = '+ 0';
  String lbl4 = '+ 0';
  bool check = true;
  late http.Response hello ;
  var pref;

  int d = 0;
 int sum =0;

  // Future<http.Response> createAlbum(String title) {
  //   return http.post(
  //     Uri.parse('https://api.pinata.cloud/pinning/pinJSONToIPFS'),String
  //     headers: <String, String>{
  //       'Content-Type': 'application/json',
  //       'pinata_api_key': pinataApiKey,
  //       'pinata_secret_api_key': pinataSecretApiKey,
  //     },
  //     body: t.toString()
  //   );
  // }
  Widget emoji(data,flag){
    if(data == '+ 10') return Icon(Icons.sentiment_very_satisfied,size:  MediaQuery.of(context).size.height/30,
        color: flag?Colors.transparent:Colors.white);
    if(data == '+ 9') return Icon(Icons.sentiment_very_satisfied,size:  MediaQuery.of(context).size.height/30,color: flag?Colors.transparent:Colors.white);
    if(data == '+ 8') return Icon(Icons.sentiment_satisfied,size:  MediaQuery.of(context).size.height/30,color: flag?Colors.transparent:Colors.white);
    if(data == '+ 7') return Icon(Icons.sentiment_satisfied,size:  MediaQuery.of(context).size.height/30,color: flag?Colors.transparent:Colors.white);
    if(data == '+ 6') return Icon(Icons.mood,size:  MediaQuery.of(context).size.height/30,color: flag?Colors.transparent:Colors.white);
    if(data == '+ 5') return Icon(Icons.mood,size:  MediaQuery.of(context).size.height/30,color: flag?Colors.transparent:Colors.white);
    if(data == '+ 4') return Icon(Icons.mood,size:  MediaQuery.of(context).size.height/30,color: flag?Colors.transparent:Colors.white);
    if(data == '+ 3') return Icon(Icons.sentiment_neutral,size:  MediaQuery.of(context).size.height/30,color: flag?Colors.transparent:Colors.white);
    if(data == '+ 2') return Icon(Icons.sentiment_neutral,size:  MediaQuery.of(context).size.height/30,color: flag?Colors.transparent:Colors.white);
    if(data == '+ 1') return Icon(Icons.sentiment_dissatisfied,size:  MediaQuery.of(context).size.height/30,color: flag?Colors.transparent:Colors.white);
    if(data == '+ 0') return Icon(Icons.sentiment_dissatisfied,size:  MediaQuery.of(context).size.height/30,color: flag?Colors.transparent:Colors.white);
    else  return Icon(Icons.warning,size:  MediaQuery.of(context).size.height/30,color: flag?Colors.transparent:Colors.white);
  }
  Color colordecide(data,flag){
    if(data == '+ 10') return Color.fromRGBO(128, 2, 80, 1);
    if(data == '+ 9') return  Color.fromRGBO(159, 5, 133, 1);
    if(data == '+ 8') return  Color.fromRGBO(190, 9, 191, 1);
    if(data == '+ 7') return  Color.fromRGBO(174, 14, 222, 1);
    if(data == '+ 6') return  Color.fromRGBO(148, 20, 250, 1);
    if(data == '+ 5') return  Color.fromRGBO(124, 48, 254, 1);
    if(data == '+ 4') return  Color.fromRGBO(124, 48, 254, 1);
    if(data == '+ 3') return  Color.fromRGBO(107, 107, 255, 1);
    if(data == '+ 2') return  Color.fromRGBO(138, 161, 255, 1);
    if(data == '+ 1') return  Color.fromRGBO(170, 204, 255, 1);
    if(data == '+ 0') return  Color.fromRGBO(204, 234, 255, 1);
    else  return  Colors.pink;
  }
  int f(data,sum) {

      if(data == '+ 10') return sum+=10;
      if(data == '+ 9') return  sum+=9;
      if(data == '+ 8') return  sum+=8;
      if(data == '+ 7') return sum+=7;
      if(data == '+ 6') return  sum+=6;
      if(data == '+ 5') return  sum+=5;
      if(data == '+ 4') return  sum+=4;
      if(data == '+ 3') return  sum+=3;
      if(data == '+ 2') return  sum+=2;
      if(data == '+ 1') return  sum+=1;
      if(data == '+ 0') return  sum+=0;
      else  return  sum+=0;

  }
  Color clr = Colors.red;
  late Timer mytime;
  var i = 0;
  // late Animation<double> animation;
  // late AnimationController animationController;
  AlignmentDirectional _ironManAlignment = AlignmentDirectional(0.0, 1);
  AlignmentDirectional _ironManAlignment1 = AlignmentDirectional(1, 1);
  AlignmentDirectional _ironManAlignment2 = AlignmentDirectional(-1, 1);
  AlignmentDirectional _ironManAlignment3 = AlignmentDirectional(-0.5, 1);
  AlignmentDirectional _ironManAlignment4 = AlignmentDirectional(0.5, 1);
  @override
  void initState() {
    widget.storage.readCounter().then((value) {
      setState(() {
        d = value;
      });
    });


  Future<File> _incrementCounter() {
    setState(() {
      d++;
    });

    // Write the variable as a string to the file.
    return widget.storage.writeCounter(d);
  }
    d=0;
    _ironManAlignment = AlignmentDirectional(0.0, 1);
    _ironManAlignment1 = AlignmentDirectional(1, 1);
    _ironManAlignment2 = AlignmentDirectional(-1, 1);
    _ironManAlignment3 = AlignmentDirectional(-0.5, 1);
    _ironManAlignment4 = AlignmentDirectional(0.5, 1);
    selected = true;
    selected1 = true;
    selected2 = true;
    selected3 = true;
    selected4 = true;
    sum = 0;
     h = 0;
    prefcall(getCurrentDate(),sum);
    i = 0;
    super.initState();
  }

 prefcall(date,data)async{
   pref = await SharedPreferences.getInstance();
   await pref.setInt(date, data);
 }
  //   animationController =
  //       AnimationController(vsync: this, duration: Duration(seconds: 3));
  //   animation = Tween<double>(begin: 0, end: -300).animate(animationController)
  //     ..addListener(() {
  //       setState(() {});
  //     });
  // }
   Future<dynamic> checkref(sum) async{
    print(sum);
    await prefcall(getCurrentDate(),sum);
    final prefs = await SharedPreferences.getInstance();
    var newpre =await prefs.getInt(getCurrentDate()) ?? 0;
    print('newpre = $newpre') ;
    setState(() {
      h = newpre;
    });
   print(h);
    }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.analytics),
          tooltip: 'Analystic',
          onPressed: () {
            Navigator.pushNamed(context, '/first');
          },
        ),
        centerTitle: true,
        title: Text('$sum'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: GetBuilder<HomeController>(
          init: _homeController,
          initState: (_) async {
            await _homeController.loadCamera();
            await _homeController.startImageStream();
            lbl =  await _homeController.label!;
            lbl1 = await _homeController.label1!;
            lbl2 = await _homeController.label2!;
            lbl3 = await _homeController.label3!;
            lbl4 = await _homeController.label4!;
          },
          builder: (_) {
            // lbl = '$_.label';
            // lbl1 = '$_.label1';
            // lbl2 = '$_.label2';
            // lbl3 = '$_.label3';
            // lbl4 = '$_.label4';
            return SafeArea(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children:[ Column(
                    children: [

                      _.cameraController != null &&
                          _.cameraController!.value.isInitialized
                          ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height/1.15,
                          child: CameraPreview(_.cameraController!))
                          : Center(child: Text('loading')),
                      // SizedBox(height: 15),

                      // SizedBox(height: 10),
                    ],
                  ),
                    AnimatedContainer(
                      duration: Duration(seconds: 5),
                      alignment: _ironManAlignment,
                      child: Container(
                        height: MediaQuery.of(context).size.height/20,
                        width:  MediaQuery.of(context).size.width/4,
                        child: Container(

                          decoration: BoxDecoration(
                            color: selected?Colors.transparent:colordecide(lbl!, selected),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          child:  Center(child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              emoji(lbl!,selected),
                              Text(lbl!,
                                style: TextStyle(
                                    color: selected?Colors.transparent:Colors.white,
                                    fontSize: MediaQuery.of(context).size.height/40
                                ),),
                            ],
                          )),

                        ),
                      ),
                    ),

                    AnimatedContainer(
                      duration: Duration(seconds: 5),
                      alignment: _ironManAlignment1,
                      child: Container(
                        height: MediaQuery.of(context).size.height/20,
                        width:  MediaQuery.of(context).size.width/4,
                        child: Container(

                          decoration: BoxDecoration(
                            color: selected1?Colors.transparent:colordecide(lbl1!, selected1),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          child:  Center(child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              emoji(lbl1!,selected1),
                              Text(lbl1!,
                                style: TextStyle(
                                    color: selected1?Colors.transparent:Colors.white,
                                    fontSize: MediaQuery.of(context).size.height/40
                                ),),
                            ],
                          )),

                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(seconds: 5),
                      alignment: _ironManAlignment2,
                      child: Container(
                        height: MediaQuery.of(context).size.height/20,
                        width:  MediaQuery.of(context).size.width/4,
                        child: Container(

                          decoration: BoxDecoration(
                            color: selected2?Colors.transparent:colordecide(lbl2!, selected2),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          child:  Center(child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              emoji(lbl2!,selected2),
                              Text(lbl2!,
                                style: TextStyle(
                                    color: selected2?Colors.transparent:Colors.white,
                                    fontSize: MediaQuery.of(context).size.height/40
                                ),),
                            ],
                          )),

                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(seconds: 5),
                      alignment: _ironManAlignment3,
                      child: Container(
                        height: MediaQuery.of(context).size.height/20,
                        width: MediaQuery.of(context).size.width/4,
                        child: Container(

                          decoration: BoxDecoration(
                            color: selected3?Colors.transparent:colordecide(lbl3!, selected3),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          child:  Center(child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              emoji(lbl3!,selected3),
                              Text(lbl3!,
                                style: TextStyle(
                                    color: selected3?Colors.transparent:Colors.white,
                                    fontSize: MediaQuery.of(context).size.height/40
                                ),),
                            ],
                          )),

                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(seconds: 5),
                      alignment: _ironManAlignment4,
                      child: Container(
                        height: MediaQuery.of(context).size.height/20,
                        width: MediaQuery.of(context).size.width/4,
                        child: Container(

                          decoration: BoxDecoration(
                            color: selected4?Colors.transparent:colordecide(lbl4!, selected4),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          child:  Center(child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              emoji(lbl4!,selected4),
                              Text(lbl4!,
                                style: TextStyle(
                                    color: selected4?Colors.transparent:Colors.white,
                                    fontSize: MediaQuery.of(context).size.height/40
                                ),),
                            ],
                          )),

                        ),
                      ),
                    ),

                    // for( i = 0;i<time;i++)
                    //      AnimatedPositioned(
                    //
                    //       width:  MediaQuery.of(context).size.width/3 ,
                    //       height: MediaQuery.of(context).size.height/15 ,
                    //       right: (MediaQuery.of(context).size.width/1.5)-(80*(i%4)),
                    //       bottom: selected?(MediaQuery.of(context).size.height/1.1): MediaQuery.of(context).size.height/150 ,
                    //       duration:  Duration(seconds: (i%10)+2),
                    //       curve: Curves.linear,
                    //       child: Container(
                    //
                    //         decoration: BoxDecoration(
                    //           color: selected?Colors.blue:Colors.transparent,
                    //           shape: BoxShape.rectangle,
                    //           borderRadius: BorderRadius.all(Radius.circular(50)),
                    //         ),
                    //         child:  Center(child: Text('🧭 \t +${i}',
                    //         style: TextStyle(
                    //           color: selected?Colors.black:Colors.transparent,
                    //           fontSize: MediaQuery.of(context).size.height/40
                    //         ),)),
                    //
                    //     ),
                    //     ),
                    //     // if(i==time) setState(() {
                    //     //   time++;
                    //     // });
                    //   // Text(
                    //   //   '${_.label}',
                    //   //   style: TextStyle(
                    //   //     fontSize: 18,
                    //   //     color: Colors.red,
                    //   //   ),
                    //   // ),
                    Padding(
                      padding: const EdgeInsets.only(top:350.0),
                      child: Align(
                        alignment: AlignmentDirectional.center,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height/15,
                          width: MediaQuery.of(context).size.width/2,
                          child: ElevatedButton(onPressed:((){
                            check ?
                            setState(() {
                              _ironManAlignment = AlignmentDirectional(0.0, 1);
                              _ironManAlignment1 = AlignmentDirectional(1, 1);
                              _ironManAlignment2 = AlignmentDirectional(-1, 1);
                              _ironManAlignment3 = AlignmentDirectional(-0.5, 1);
                              _ironManAlignment4 = AlignmentDirectional(0.5, 1);

                              mytime = Timer.periodic(Duration(seconds: 4), (timer) {
                                setState(() {
                                  // selected = !selected;
                                  Timer(Duration(seconds: 0), () async {
                                    lbl = await _homeController.label!;
                                   // sum+=(lbl as int);
                                    selected = !selected;
                                    selected?_ironManAlignment = AlignmentDirectional(0.0, 1):
                                    _ironManAlignment = AlignmentDirectional(0.0, -1.5);
    Timer(Duration(seconds: 0), () async {sum = await f(lbl,sum);});
                                  });

                                  Timer(Duration(seconds: 1), () async {
                                    lbl1 = await _homeController.label1!;
                                    //sum+=(lbl1 as int);
                                    selected1 = !selected1;
                                    selected1? _ironManAlignment1 = AlignmentDirectional(1, 1):
                                    _ironManAlignment1 = AlignmentDirectional(1, -1.5);
                                    Timer(Duration(seconds: 0), () async {sum = f(lbl1,sum);});
                                  });
                                  Timer(Duration(seconds: 2), () async {
                                    lbl2 = await _homeController.label2!;
                                    //sum+=(lbl2 as int);
                                    selected2 = !selected2;
                                    selected2? _ironManAlignment2 = AlignmentDirectional(-1, 1):
                                    _ironManAlignment2 = AlignmentDirectional(-1, -1.5);
                                    Timer(Duration(seconds: 0), () async {sum = await f(lbl2,sum);});
                                  });
                                  Timer(Duration(seconds: 1), () async {
                                    lbl3 = await _homeController.label3!;
                                    //sum+=(lbl3 as int);
                                    selected3 = !selected3;
                                    selected3? _ironManAlignment3 = AlignmentDirectional(-0.5, 1):
                                    _ironManAlignment3 = AlignmentDirectional(-0.5, -1.5);
                                    Timer(Duration(seconds: 0), () async {sum = await f(lbl3,sum);});
                                  });
                                  Timer(Duration(seconds: 4), () async {
                                    lbl4 = await _homeController.label4!;
                                    //sum+=(lbl4 as int);
                                    selected4 = !selected4;
                                    selected4? _ironManAlignment4 = AlignmentDirectional(0.5, 1):
                                    _ironManAlignment4 = AlignmentDirectional(0.5, -1.5);
                                    Timer(Duration(seconds: 0), () async {sum = await f(lbl4,sum);});
                                  });
                                });
                              });
                              check = false;
                            }): setState(() {
                              mytime.cancel();
                             checkref(sum);
                              sum = 0;
                              _ironManAlignment = AlignmentDirectional(0.0, 1);
                              _ironManAlignment1 = AlignmentDirectional(1, 1);
                              _ironManAlignment2 = AlignmentDirectional(-1, 1);
                              _ironManAlignment3 = AlignmentDirectional(-0.5, 1);
                              _ironManAlignment4 = AlignmentDirectional(0.5, 1);
                              check = true;
                            });


                          }),

                              style:  ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.white)

                              ),
                              child: Text(
                                !check?"Stop":"Start",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: MediaQuery.of(context).size.height/30,
                                ),
                              )
                          ),
                        ),
                      ),
                    ),
                    // Container(
                    //   height: MediaQuery.of(context).size.height/20,
                    //   width: MediaQuery.of(context).size.width/4,
                    //   decoration: BoxDecoration(
                    //     color: Colors.blue,
                    //     shape: BoxShape.rectangle,
                    //     borderRadius: BorderRadius.all(Radius.circular(50)),
                    //   ),
                    //   child:  Center(child: Text('$h',
                    //     style: TextStyle(
                    //         color: Colors.white,
                    //         fontSize: MediaQuery.of(context).size.height/40
                    //     ),)),
                    //
                    // ),
            //                   ElevatedButton(      onPressed: ()async { FilePickerService.pickFile(context);
            // },
            // style: ButtonStyle(
            // backgroundColor: MaterialStateProperty.all(Colors.black),
            //
            // ),      child: const SizedBox(       height: 50,       child: Center(        child: Text(         'Upload Image',          style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),        ),       ),      ),
            // ),
                ],
              ),
            ));

          }

        ),
      ),
      bottomNavigationBar:Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/10,
          decoration: BoxDecoration(
              color: Color.fromRGBO(217, 217, 217, 1),
              shape: BoxShape.rectangle

          ),
          child: Center(
            child: Text("banner ads",
                style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontSize: MediaQuery.of(context).size.height/30,
                  fontWeight: FontWeight.bold,
                )),
          )),
    );

    }
  }
