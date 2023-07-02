import 'package:flutter/material.dart';
import 'package:pvpccheap/device.dart';

class SleepHourBar extends StatelessWidget {
  final List<SleepHours> sleepHours;
  final Color activeColor;

  const SleepHourBar({
    Key? key,
    required this.sleepHours,
    required this.activeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(24, (index) {
        final isActive = sleepHours.any((sh) => sh.hour == index);
        return Expanded(
          child: Container(
            height: 40,
            color: isActive ? activeColor : Colors.grey,
            child: Center(
              child: Text(
                '$index',
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.black, // Text color change depending if hour is active
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}