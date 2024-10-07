import 'package:app_1helo/service/pieChar_service.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:app_1helo/model/pieCharModel.dart';

class Piechartpage extends StatefulWidget {
  const Piechartpage({super.key});

  @override
  _PiechartpageState createState() => _PiechartpageState();
}

class _PiechartpageState extends State<Piechartpage> {
  Map<String, double> dataMap = {};
  final List<Color> colorList = [
    Colors.black,
    Colors.green,
    Colors.blue,
    Colors.red,
    Colors.orange,
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final pieCharService = PiecharService();
    final pieChartData = await pieCharService.fetchPieChartData(
      'employeeIdValue',
      'customerIdValue',
      '2023-01-01',
      '2023-01-31',
    );

    if (pieChartData != null && pieChartData.success == true) {
      setState(() {
        dataMap = {
          "Đang thực hiện": pieChartData.inProgress ?? 0.0,
          "Đã hoàn thành": pieChartData.completed ?? 0.0,
          "Đã sửa": pieChartData.revised ?? 0.0,
        };
      });
    } else {
      print('Failed to fetch pie chart data or data is unsuccessful');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          PieChart(
            dataMap: dataMap.isEmpty ? {'Không có dữ liệu': 0} : dataMap,
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
