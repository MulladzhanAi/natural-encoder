import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:natural_encoder/constans.dart';
import 'package:natural_encoder/domain/models/frequency.dart';

class Graph extends StatelessWidget {
  final List<Frequency> caesarFrequency;
  final List<Frequency> twoArraysFrequency;
  final List<Frequency> tritemiusFrequency;
  const Graph({
    required this.caesarFrequency,
    required this.tritemiusFrequency,
    required this.twoArraysFrequency,
    super.key});

  @override
  Widget build(BuildContext context) {

    return AspectRatio(
        aspectRatio: 2.0,
      child: LineChart(
          LineChartData(
            minY: 0,
            maxX: 34,
            maxY: 0.5,
            lineBarsData: [
              LineChartBarData(
                color: Colors.redAccent,
                spots: [
                  for(int i=0;i<caesarFrequency.length;i++)...[
                    FlSpot(i.toDouble(), caesarFrequency[i].frequencyOfUse),
                  ]

                ]
              ),
              LineChartBarData(
                  color: Colors.blueAccent,
                  spots: [
                    for(int i=0;i<twoArraysFrequency.length;i++)...[
                      FlSpot(i.toDouble(), twoArraysFrequency[i].frequencyOfUse),
                    ]

                  ]
              ),
              LineChartBarData(
                  color: Colors.amber,
                  spots: [
                    for(int i=0;i<tritemiusFrequency.length;i++)...[
                      FlSpot(i.toDouble(), tritemiusFrequency[i].frequencyOfUse),
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
