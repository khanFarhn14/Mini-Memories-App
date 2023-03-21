import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mini_memories/camera.dart';
import 'package:mini_memories/show_video.dart';
import 'package:mini_memories/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final CollectionReference _refUserInfo = FirebaseFirestore.instance.collection('userInfo');
  late Stream<QuerySnapshot> _streamUserInfo;
  String? url;

  @override
  void initState() 
  {
    _streamUserInfo = _refUserInfo.snapshots();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      body: StreamBuilder<QuerySnapshot>(
        stream: _streamUserInfo,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasError){
            return Text(snapshot.error.toString());
          }

          if(snapshot.connectionState == ConnectionState.active){
            QuerySnapshot querySnapshot = snapshot.data;
            List<QueryDocumentSnapshot> listQueryDocumentSnapshot = querySnapshot.docs;
            return ListView.builder
            (
              itemCount: listQueryDocumentSnapshot.length,
              itemBuilder: ((BuildContext context, int index) {
                return ShowVideo(url: snapshot.data.docs[index]['url'].toString());
              }),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),

      floatingActionButton: FloatingActionButton
      (
        onPressed: ()
        {
          nextScreen(context, const CameraPage());
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.camera_alt_outlined)
      ),
    );
  }
}