import 'package:flutter/material.dart';
import 'screen2.dart';
class premiumPage extends StatefulWidget {
  const premiumPage({super.key});

  @override
  State<premiumPage> createState() => _premiumPageState();
}

class _premiumPageState extends State<premiumPage> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenMid = screenWidth+screenHeight;
    Widget size(x,y){
      return SizedBox(
        width: screenWidth/x,
        height: screenHeight/y,
      );
    }
    Widget size1(x,y){
      return SizedBox(
        width: screenMid/x,
        height: screenMid/y,
      );
    }
    Widget txt1(txt,fs){
      return Text(
        txt,
        style: TextStyle(
          color: Color.fromRGBO(255, 255, 255,1),
          fontSize: screenMid/fs,
          fontWeight: FontWeight.w600,
        ),
      );
    }
    return Scaffold(
      body:SafeArea(child:  Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(

              gradient: RadialGradient(
                colors: [Color(0xff1e2852), Color(0xff212a59)],
                stops: [0.3, 0.8],
                center: Alignment.topLeft,
              )
          ),
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(onPressed: (){Navigator.pushNamed(context, '/first');}, icon: Icon(Icons.arrow_back_ios_new,color:Colors.white)),
                    size(20,40),
                  ],

                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      size(20,40),
                      Text("You'll smile more 😆",
                        style: TextStyle(
                          color: Color.fromRGBO(255, 230, 0, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: screenHeight/25,
                        ),

                      ),
                      size(20,40),
                      Container(
                          width: screenWidth/1.2,
                          height: screenHeight/3.5,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              size(20,40),
                              txt1("Premium",40),
                              size(20,40),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  txt1("1.remove ads",50),
                                  size(30,45),
                                  txt1("2.Fast Startup",50),
                                  size(30,45),
                                  txt1("3.Calculate Costs",50),

                                ],
                              ),


                            ],

                          )
                      ),
                      size(20,40),
                      txt1("BUY NOW!",30),
                      size(20,40),
                      SizedBox(
                        height: screenHeight/20,
                        width:  screenWidth/1.2,
                        child: ElevatedButton(onPressed: (){
                          // setState((){
                          //   premiumword = true;
                          //   Navigator.pushNamed(context, '/');
                          // });


                        }, child:
                        Text("only \$8",
                            style: TextStyle(
                                fontSize: screenHeight/40,
                                color: Colors.black
                            )),
                          style:  ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(255, 230, 0, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              )
                          ),),
                      ),
                    ],
                  ),
                ),

                size(20,40),
              ],
            ),

          )
      )),
      bottomNavigationBar:  Container(
          width: screenWidth,
          height: screenHeight/10,
          decoration: BoxDecoration(
              color: Color.fromRGBO(217, 217, 217, 1),
              shape: BoxShape.rectangle

          ),
          child: Center(
            child: Text("banner ads",
                style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontSize: screenHeight/30,
                  fontWeight: FontWeight.bold,
                )),
          )),
    );
  }
}