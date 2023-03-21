import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'video.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {

  bool _isLoading = true;
  bool _isRecording = false;
  late CameraController _cameraController;
  int count = 0;
  Timer? timer;

  @override
  void dispose() 
  {
    _cameraController.dispose();
    super.dispose();
  }

  _initCamera() async 
  {
    //Request all available cameras from the camera plugin.
    final cameras = await availableCameras();

    // Selecting the back-facing camera.
    final front = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.back);

    // Create an instance of CameraController. We are using the CameraDescription of the front camera and setting the resolution of the video to the maximum.
    _cameraController = CameraController(front, ResolutionPreset.low);

    // Initialize the controller with the set parameters.
    await _cameraController.initialize();

    // After the initialization, set the _isLoading state to false.
    setState(() => _isLoading = false);
  }

  @override
  void initState()
  {
    super.initState();
    _initCamera();
  }

  _recordVideo() async 
  {
    
    if (_isRecording) 
    {
      final file = await _cameraController.stopVideoRecording();
      setState(() => _isRecording = false);
      final route = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => VideoPage(filePath: file.path),
      );
      // ignore: use_build_context_synchronously
      Navigator.push(context, route);
    } else 
    {
      startTimer();
      scheduleTimeout(5 * 1000);
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() => _isRecording = true);
    }
  }

  startTimer()
  {
    timer = Timer.periodic
    (
      const Duration(seconds: 1),
      (timer) {
        /// callback will be executed every 1 second, increament a count value 
        /// on each callback
        setState(() {
          if(count == 5)
          {
            timer.cancel();
            count = 0;
          }
          else{
            count++;
          }
        });
      },
    );
  }

  Timer scheduleTimeout([int milliseconds = 10000])
  {
    return Timer(Duration(milliseconds: milliseconds), handleTimeout);
  }

  void handleTimeout() async
  { 
    final file = await _cameraController.stopVideoRecording();
    setState(() => _isRecording = false);
    final route = MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => VideoPage(filePath: file.path),
    );
    // ignore: use_build_context_synchronously
    Navigator.push(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? Container
    (
      color: Colors.white,
      child: const Center
      (
        child: CircularProgressIndicator(),
      ),
    ): Scaffold
    (
      backgroundColor: Colors.black,
      body: Center
      (
        child: Stack
        (
          alignment: Alignment.bottomCenter,
          children: 
          [
            CameraPreview(_cameraController),
    
            Padding(
              padding: const EdgeInsets.all(25),
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                // child: Icon(_isRecording ? Icons.stop : Icons.circle),
                child: _isRecording ? Text("$count", style: const TextStyle(fontSize: 32, color: Colors.white,)) : const Icon(Icons.circle),
                onPressed: () => _recordVideo(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}