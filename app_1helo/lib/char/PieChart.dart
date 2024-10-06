import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartSample extends StatelessWidget {
  final Map<String, double> dataMap = {
    "Đang thực hiện": 33,
    "Đã hoàn thành": 24,
    "Đã sửa": 12,
    "Đã hủy": 8,
    "Chờ duyệt": 23,
  };

  final List<Color> colorList = [
    Colors.black,
    Colors.green,
    Colors.blue,
    Colors.red,
    Colors.orange,
  ];

  PieChartSample({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          PieChart(
            dataMap: dataMap,
            animationDuration: const Duration(milliseconds: 800),
            chartLegendSpacing: 32,
            chartRadius: MediaQuery.of(context).size.width / 2.5,
            colorList: colorList,
            initialAngleInDegree: 0,
            chartType: ChartType.ring,
            ringStrokeWidth: 32,
            centerText: "Thống kê",
            legendOptions: const LegendOptions(
              showLegendsInRow: true,
              legendPosition: LegendPosition.bottom,
              showLegends: true,
              legendShape: BoxShape.circle,
              legendTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            chartValuesOptions: const ChartValuesOptions(
              showChartValueBackground: true,
              showChartValues: true,
              showChartValuesInPercentage: true,
              showChartValuesOutside: false,
              decimalPlaces: 0,
            ),
          ),
        ],
      ),
    );
  }
}
