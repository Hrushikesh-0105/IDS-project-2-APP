import 'dart:async';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:PixelCraft/splashScreen.dart';
import 'dart:io';
import 'package:flutter/services.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    ));

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  XFile? selectedImage;
  XFile? croppedImage;
  XFile? finalImage;

  List overlays = [];
  void importOverlays() {
    for (int i = 1; i <= 15; i++) {
      overlays.add("assets/images/overlay" + "${i}" + ".png");
    }
  }

  //function to pick image
  Future<void> pickImage(String source) async {
    var pickedImage;
    if (source == "gallery") {
      pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    } else {
      pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    }
    if (pickedImage != null) {
      selectedImage = XFile(pickedImage!.path);
      cropImage(); //after picking the image it directly calls the crop image function
    }
  }

  //function to crop image or edit it
  Future<void> cropImage() async {
    var editedImage = await ImageCropper()
        .cropImage(sourcePath: selectedImage!.path, uiSettings: [
      AndroidUiSettings(
          lockAspectRatio: false,
          toolbarTitle: "Image Editor",
          activeControlsWidgetColor: Colors.teal,
          toolbarColor: Colors.grey[900],
          toolbarWidgetColor: Colors.white,
          backgroundColor: Color.fromARGB(255, 21, 13, 50)),
    ]);
    croppedImage = XFile(editedImage!.path);
    tapOnOpacity = false;
    toggleOpacity = true;
    overlayContainer = true;
    importOverlays();
    setState(() {});
  }

  int overlayIndex = -1; //-1 means to show the original image
  int finalOverlay = -1;
  bool toggleSelectCategory = false;
  bool toggleOpacity = false;
  bool tapOnOpacity = true;
  bool overlayContainer = false;

  void toggleVisibility() {
    if (!toggleSelectCategory) {
      toggleSelectCategory = true;
      toggleOpacity = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 21, 13, 50),
        appBar: AppBar(
          title: Container(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: IconButton(
                      alignment: Alignment.centerLeft,
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 28,
                      )),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 48,
                            child: Image.asset('assets/images/logo2.png')),
                        SizedBox(width: 10),
                        Text(
                          "PixelCraft",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins",
                              fontSize: 28),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  //used to centre the title
                  flex: 1,
                  child: Container(),
                )
              ],
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.grey[850],
        ),
        body: Stack(
          children: [
            //column is first child and second child is select source from gallery or camera container
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.teal,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text("Upload Image",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontFamily: "Poppins")),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                toggleVisibility();
                              });
                            },
                            child: Text("Choose Source",
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontFamily: "Poppins")),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Visibility(
                      visible: finalImage != null ? true : false,
                      child: Container(
                          color: Colors.black,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: finalOverlay != -1 ? 360 : null,
                                child: finalImage != null
                                    ? Image.file(
                                        File(finalImage!.path),
                                      )
                                    : Text(""),
                              ),
                              Container(
                                child: finalOverlay != -1 && finalImage != null
                                    ? Image.asset(
                                        overlays[finalOverlay],
                                      )
                                    : Text(""),
                              )
                            ],
                          )),
                    ),
                  )
                ],
              ),
            ),
            Visibility(
              visible: toggleOpacity,
              child: InkWell(
                onTap: () {
                  if (tapOnOpacity) {
                    setState(() {
                      toggleOpacity = false;
                      toggleSelectCategory = false;
                    });
                  }
                },
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  //here the stack is in the body directly and as it is the second child or the one above the home page
                  //it takes up full space
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Visibility(
                  visible: overlayContainer,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[850],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      toggleOpacity = false;
                                      tapOnOpacity = true;
                                      overlayContainer = false;
                                      //selectedImage = null;
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.teal,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Icon(
                                        Icons.close_rounded,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Text(
                                    "Image Overlays",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontFamily: "Poppins"),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Container(
                                color: Colors.black,
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        height: overlayIndex != -1 ? 360 : null,
                                        child: croppedImage != null
                                            ? Image.file(
                                                File(croppedImage!.path))
                                            : Text(""),
                                      ),
                                      Container(
                                        child: overlayIndex != -1
                                            ? Image.asset(
                                                overlays[overlayIndex])
                                            : Text(""),
                                      )
                                    ]),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              overlayContainer
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        OutlinedButton(
                                          onPressed: () {
                                            overlayIndex = -1;
                                            setState(() {});
                                          },
                                          child: Text(
                                            "Original",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontFamily: 'poppins'),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                              minimumSize: Size(0, 48),
                                              backgroundColor: Colors.teal),
                                        ),
                                        //heart overlay
                                        Container(
                                            height: 52,
                                            width: 252,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () {
                                                    overlayIndex = index;
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        8, 0, 8, 0),
                                                    padding: EdgeInsets.all(4),
                                                    width: 60,
                                                    height: 60,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        border: Border.all(
                                                          color: Colors.teal,
                                                          width: 1,
                                                        )),
                                                    child: Image.asset(
                                                        overlays[index]),
                                                  ),
                                                );
                                              },
                                              itemCount: 15,
                                            ))
                                      ],
                                    )
                                  : Text(""),
                              SizedBox(
                                height: 14,
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  finalOverlay = overlayIndex;
                                  overlayIndex = -1;
                                  finalImage = croppedImage;
                                  toggleOpacity = false;
                                  tapOnOpacity = true;
                                  overlayContainer = false;
                                  setState(() {});
                                },
                                child: Text(
                                  "Use this image",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontFamily: 'poppins'),
                                ),
                                style: OutlinedButton.styleFrom(
                                    minimumSize: Size(0, 48),
                                    backgroundColor: Colors.teal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: toggleSelectCategory,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 172,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(28),
                          topLeft: Radius.circular(28))),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Select source",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontFamily: "Poppins"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 80,
                        width: 250,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                  height: 60,
                                  child: InkWell(
                                      onTap: () async {
                                        await pickImage(
                                            "gallery"); //calling the image picker function
                                        if (selectedImage != null) {
                                          toggleSelectCategory = false;
                                          toggleOpacity =
                                              false; //when we come back from editor, the opacity and select category will not be shown
                                          selectedImage = null;
                                        }
                                      },
                                      child: Image.asset(
                                          "assets/images/gallery.png")),
                                ),
                                Text("Gallery",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: "Poppins"))
                              ],
                            ),
                            Column(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    await pickImage(
                                        "camera"); //calling the image picker function
                                    if (selectedImage != null) {
                                      toggleSelectCategory = false;
                                      toggleOpacity =
                                          false; //when we come back from editor, the opacity and select category will not be shown
                                      setState(() {});
                                      await cropImage();
                                      setState(() {});
                                      selectedImage = null;
                                    }
                                  },
                                  child: Container(
                                    height: 60,
                                    child: Image.asset(
                                        "assets/images/camera2.png"),
                                  ),
                                ),
                                Text("Camera",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: "Poppins"))
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
