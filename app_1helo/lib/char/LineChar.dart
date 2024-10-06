import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Linechar extends StatelessWidget {
  const Linechar({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: AspectRatio(
          aspectRatio: 1.5,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true),
                titlesData: const FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 300),
                      const FlSpot(1, 320),
                      const FlSpot(2, 350),
                      const FlSpot(3, 400),
                    ],
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 3,
                    belowBarData: BarAreaData(show: false),
                  ),
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 400),
                      const FlSpot(1, 380),
                      const FlSpot(2, 410),
                      const FlSpot(3, 450),
                    ],
                    isCurved: true,
                    color: Colors.orange,
                    barWidth: 3,
                    belowBarData: BarAreaData(show: false),
                  ),
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 200), 
                      const FlSpot(1, 180),
                      const FlSpot(2, 220),
                      const FlSpot(3, 240),
                    ],
                    isCurved: true,
                    color: Colors.red,
                    barWidth: 3,
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: const Color(0xff37434d), width: 1),
                ),
                minX: 0,
                maxX: 3,
                minY: 0,
                maxY: 500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
