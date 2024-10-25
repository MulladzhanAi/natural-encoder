import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:natural_encoder/domain/models/frequency.dart';

import '../constans.dart';

class HillGraph extends StatelessWidget {
  final List<Frequency> hillFrequency;
  const HillGraph({super.key,required this.hillFrequency});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.0,
      child: LineChart(
        LineChartData(
            minY: 0,
            maxX: Alphabets.russianAlphabetKeys.length.toDouble(),
            maxY: 0.5,
            lineBarsData: [
              LineChartBarData(
                  color: Colors.redAccent,
                  spots: [
                    for(int i=0;i<hillFrequency.length;i++)...[
                      FlSpot(i.toDouble(), hillFrequency[i].frequencyOfUse),
                    ]

                  ]
              ),
              LineChartBarData(
                  color: Colors.green,
                  spots: [
                    for(int i=0;i<Alphabets.russianAlphabetFrequencies.length;i++)...[
                      FlSpot(i.toDouble(), Alphabets.russianAlphabetFrequencies[i].frequencyOfUse),
                    ]

                  ]
              )
            ]
        ),

      ),
    );
  }
}
