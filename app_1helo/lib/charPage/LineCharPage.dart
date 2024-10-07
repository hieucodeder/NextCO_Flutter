import 'package:app_1helo/model/lineCharModel.dart' as LineCharModel1;
import 'package:app_1helo/service/lineChar_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Linecharpage extends StatefulWidget {
  const Linecharpage({super.key});

  @override
  _LinecharpageState createState() => _LinecharpageState();
}

class _LinecharpageState extends State<Linecharpage> {
  final LineChartService _lineChartService = LineChartService();
  List<FlSpot> _completeCoSpots = [];
  List<FlSpot> _processingCoSpots = [];
  List<FlSpot> _canceledCoSpots = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    LineCharModel1.LinecharModel? lineChartResponse =
        await _lineChartService.fetchLineChartData('employeeId', 'customerId');

    if (lineChartResponse != null && lineChartResponse.data != null) {
      setState(() {
        _completeCoSpots = lineChartResponse.data!.completeCo?.map((co) {
              return FlSpot(
                  co.id?.toDouble() ?? 0, co.name?.length?.toDouble() ?? 0);
            }).toList() ??
            [];

        _processingCoSpots = lineChartResponse.data!.processingCo?.map((co) {
              return FlSpot(
                  co.id?.toDouble() ?? 0, co.name?.length?.toDouble() ?? 0);
            }).toList() ??
            [];

        _canceledCoSpots = lineChartResponse.data!.canceledCo?.map((co) {
              return FlSpot(
                  co.id?.toDouble() ?? 0, co.name?.length?.toDouble() ?? 0);
            }).toList() ??
            [];

        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: AspectRatio(
          aspectRatio: 1.5,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: _isLoading
                ? const CircularProgressIndicator()
                : LineChart(
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
                          spots: _completeCoSpots,
                          isCurved: true,
                          color: Colors.green,
                          barWidth: 3,
                          belowBarData: BarAreaData(show: false),
                        ),
                        LineChartBarData(
                          spots: _processingCoSpots,
                          isCurved: true,
                          color: Colors.orange,
                          barWidth: 3,
                          belowBarData: BarAreaData(show: false),
                        ),
                        LineChartBarData(
                          spots: _canceledCoSpots,
                          isCurved: true,
                          color: Colors.red,
                          barWidth: 3,
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                            color: const Color(0xff37434d), width: 1),
                      ),
                      minX: 0,
                      maxX: 3,
                      minY: 0,
                      maxY: 50,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
