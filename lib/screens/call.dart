import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

const String appId = 'ad0d26a345964b03af77bdfde45b3ad9';

class VoiceCallScreen extends StatefulWidget {
  const VoiceCallScreen({super.key});

  @override
  State<VoiceCallScreen> createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends State<VoiceCallScreen> {
  String channelName = 'COMMUNICATION_1';
  String token = '<Insert token here>';

  int uid = 0; // uid of local user

  int? _remoteUid; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  late RtcEngine agoraEngine; // Agora engine instance

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold

  Future<void> setupVoiceSDKEngine() async {
    await [Permission.microphone].request();

    agoraEngine = createAgoraRtcEngine();

    await agoraEngine.initialize(
      const RtcEngineContext(appId: appId),
    );

    agoraEngine.registerEventHandler(RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
      showMessage("Local user uid: ${connection.localUid} joined the channel");
      setState(() {
        _isJoined = true;
      });
    }, onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
      showMessage("Remote user: $remoteUid joined the channel");
      setState(() {
        _remoteUid = remoteUid;
      });
    }, onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
      showMessage("Remote user: $remoteUid left the channel");
      setState(() {
        _remoteUid = null;
      });
    }));
  }

  void join() async {
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    await agoraEngine.joinChannel(
      token: token,
      channelId: channelName,
      uid: uid,
      options: options,
    );
  }

  void leave() async {
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    agoraEngine.leaveChannel();
  }

  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  void initState() {
    super.initState();
    setupVoiceSDKEngine();
  }

  @override
  void dispose() async {
    await agoraEngine.leaveChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('voice call demo'),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 4),
          children: [
            Container(
              height: 40,
              child: Center(
                child: _status(),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      join();
                    },
                    child: const Text("Join"),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      leave();
                    },
                    child: const Text('Leave'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _status() {
    String statusText;

    if (!_isJoined) {
      statusText = 'Join a Channel';
    } else if (_remoteUid == null) {
      statusText = 'Waiting for a remote user to join...';
    } else {
      statusText = 'Connected to remote user, uid:$_remoteUid';
    }
    return Text(
      statusText,
    );
  }
}
