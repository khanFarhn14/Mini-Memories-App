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
    _cameraController = CameraController(front, ResolutionPreset.max);

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
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() => _isRecording = true);
    }
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
    ): Center
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
              child: Icon(_isRecording ? Icons.stop : Icons.circle),
              onPressed: () => _recordVideo(),
            ),
          ),
        ],
      ),
    );
  }
}