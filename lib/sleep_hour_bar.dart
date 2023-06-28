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
            height: 40, // Aumenté la altura para hacer espacio para el texto
            color: isActive ? activeColor : Colors.grey,
            child: Center(
              child: Text(
                '$index',
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.black, // color del texto dependiendo de si la barra está activa o no
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}