import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mini_memories/home.dart';
import 'package:mini_memories/widgets.dart';

class FinalPage extends StatefulWidget {
  final String filePath;
  const FinalPage({super.key, required this.filePath});
 

  @override
  State<FinalPage> createState() => _FinalPageState();
}

class _FinalPageState extends State<FinalPage> {
  String? videoTitle;
  UploadTask? uploadTask;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold
      (
        resizeToAvoidBottomInset: false,
        body: _isLoading ? const Center(child: CircularProgressIndicator(color: Colors.black)): Center
        (
          child: Padding
          (
            padding: const EdgeInsets.all(16.0),
            child: Container
            (
              height: 250,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration
              (
                color: Colors.black,
                borderRadius: BorderRadius.circular(16)

              ),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              child: Column
              (
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: 
                [
                  const Text("Title of the Video",style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 16,),

                  TextField
                  (
                    
                    onChanged: (val)
                    {
                      setState(() {
                        videoTitle = val;
                      });
                    },

                    // style: GiveStyle().inputText(),
                    decoration: InputDecoration
                    (
                      contentPadding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                      // labelStyle: GiveStyle().labelText().copyWith(color: GiveStyle().secondary_70),
                      filled: true,
                      fillColor: Colors.white,

                      enabledBorder: OutlineInputBorder
                      (
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),

                      focusedBorder: OutlineInputBorder
                      (
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide
                        (
                          color: Colors.blue,
                          width: 1.8,
                        )
                      ),

                    )
                  ),

                  const SizedBox(height: 32,),

                  InkWell
                  (
                    splashColor: Colors.blue,
                    child: Container
                    (
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      // height: 40,
                      decoration: BoxDecoration
                      (
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40)
                      ),
                      child: const Text("Ok",style: TextStyle(color: Colors.black, fontSize: 24,fontWeight: FontWeight.bold),),
                    ),
                    onTap: () => uploadFile()
                  )
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
  
  Future uploadFile() async 
  {
    setState(() {
      _isLoading = true;
    });
    final path = 'Video/${videoTitle}';
    final file = File(widget.filePath);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() 
    {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    // databaseService.savingVideo(videoTitle!, urlDownload);
    FirebaseFirestore.instance.collection('userInfo').add({
      'videoTitle': videoTitle,
      'url': urlDownload,
    });
    // ignore: prefer_const_constructors, use_build_context_synchronously
    nextScreenReplace(context, HomePage());
  }
}