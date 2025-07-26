import 'package:flutter/material.dart';

class MeetingSchedulerScreen extends StatelessWidget {
  const MeetingSchedulerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Meeting Scheduler\nComing Soon',
        style: TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }
}
