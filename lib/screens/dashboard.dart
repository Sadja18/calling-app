import 'dart:developer';

import 'package:call/screens/call.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/';
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        centerTitle: false,
        // titleSpacing: ,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        height: MediaQuery.of(context).size.height * 0.80,
        width: MediaQuery.of(context).size.width * 0.95,
        decoration: const BoxDecoration(
          color: Colors.pinkAccent,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (kDebugMode) {
                        log('visiting voice call page');
                      }

                      Navigator.pushNamed(
                        context,
                        VoiceCallScreen.routeName,
                      );
                    },
                    icon: const Icon(
                      Icons.voice_chat_sharp,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
