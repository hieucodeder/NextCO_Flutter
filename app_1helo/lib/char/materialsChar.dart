import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Materialschar extends StatefulWidget {
  const Materialschar({super.key});

  @override
  State<Materialschar> createState() => _MaterialscharState();
}

class _MaterialscharState extends State<Materialschar> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
          child: AspectRatio(
        aspectRatio: 1.5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LineChart(LineChartData(
              lineBarsData: [
                LineChartBarData(
                    show: true,
                    spots: const [
                      FlSpot(0, 0),
                      FlSpot(1, 6),
                      FlSpot(2, 1),
                      FlSpot(3, 9),
                      FlSpot(4, 0),
                      FlSpot(5, 9),
                      FlSpot(6, 2),
                    ],
                    color: Colors.red,
                    gradient: const LinearGradient(colors: [
                      Colors.red,
                      Colors.purpleAccent,
                      Colors.lightBlueAccent
                    ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                    barWidth: 4,
                    isCurved: true,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.red.withOpacity(0.3),
                    ),
                    aboveBarData: BarAreaData(
                      show: true,
                      color: Colors.green.withOpacity(0.3),
                    ),
                    dotData: FlDotData(
                      show: true,
                      checkToShowDot: (spot, barData) {
                        return false;
                      },
                      getDotPainter: (
                        FlSpot spot,
                        double xPercentage,
                        LineChartBarData bar,
                        int index, {
                        double? size,
                      }) {
                        return FlDotSquarePainter(
                          size: 40,
                          color: [
                            Colors.red,
                            Colors.blue,
                            Colors.green,
                          ][index % 3],
                        );
                      },
                    ),
                    isStepLineChart: true,
                    lineChartStepData:
                        const LineChartStepData(stepDirection: 0.2)),
                LineChartBarData(
                    show: true,
                    spots: const [
                      FlSpot(0, 0),
                      FlSpot(1, 6),
                      FlSpot(2, 1),
                      FlSpot(3, 9),
                      FlSpot(4, 0),
                      FlSpot(5, 9),
                      FlSpot(6, 2),
                    ],
                    color: Colors.red,
                    gradient: const LinearGradient(colors: [
                      Colors.red,
                      Colors.purpleAccent,
                      Colors.lightBlueAccent
                    ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                    barWidth: 4,
                    isCurved: true,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.red.withOpacity(0.3),
                    ),
                    aboveBarData: BarAreaData(
                      show: true,
                      color: Colors.green.withOpacity(0.3),
                    ),
                    dotData: FlDotData(
                      show: true,
                      checkToShowDot: (spot, barData) {
                        return false;
                      },
                      getDotPainter: (
                        FlSpot spot,
                        double xPercentage,
                        LineChartBarData bar,
                        int index, {
                        double? size,
                      }) {
                        return FlDotSquarePainter(
                          size: 40,
                          color: [
                            Colors.red,
                            Colors.blue,
                            Colors.green,
                          ][index % 3],
                        );
                      },
                    ),
                    isStepLineChart: false,
                    lineChartStepData:
                        const LineChartStepData(stepDirection: 0.2))
              ],
              betweenBarsData: [
                BetweenBarsData(fromIndex: 0, toIndex: 1, color: Colors.black87)
              ],
              titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                      axisNameWidget: const Icon(Icons.ac_unit),
                      axisNameSize: 30,
                      sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                meta.formattedValue,
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          }))))),
        ),
      )),
    );
  }
}
