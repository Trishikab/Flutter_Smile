import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'home/home.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
 
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _homeController = HomeController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Emotion'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => null,
        child: Icon(Icons.camera_alt),
      ),
      body: GetBuilder<HomeController>(
        init: _homeController,
        initState: (_) async {
          await _homeController.loadCamera();
          _homeController.startImageStream();
        },
        builder: (_) {
          return Container(
            child: Column(
              children: [
              
                _.cameraController != null &&
                        _.cameraController!.value.isInitialized
                    ? Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: CameraPreview(_.cameraController!))
                    : Center(child: Text('loading')),
                SizedBox(height: 15),
                Expanded(
                  child: Container(
                    alignment: Alignment.topCenter,
                    width: 200,
                    height: 200,
                    color: Color.fromARGB(255, 128, 14, 14),
                    
                  ),
                ),
                Text(
                  '${_.label}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}