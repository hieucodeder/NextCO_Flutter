import 'package:app_1helo/provider/providerColor.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:app_1helo/model/columnChar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MultiBarChartWidget extends StatelessWidget {
  final List<ColumnChar> data;
  final String title;
  final String filterKey;

  const MultiBarChartWidget({
    super.key,
    required this.data,
    required this.title,
    required this.filterKey,
  });

  @override
  Widget build(BuildContext context) {
    double maxY = 0;
    List<BarChartGroupData> barGroups = [];

    for (var item in data) {
      double value;

      switch (filterKey) {
        case 'coNumber':
          value = item.coNumber?.toDouble() ?? 0;
          break;
        case 'vatNumber':
          value = item.vatNumber?.toDouble() ?? 0;
          break;
        case 'importDeclarationNumber':
          value = item.importDeclarationNumber?.toDouble() ?? 0;
          break;
        case 'exportDeclarationNumber':
          value = item.exportDeclarationNumber?.toDouble() ?? 0;
          break;
        case 'userNumber':
          value = item.userNumber?.toDouble() ?? 0;
          break;
        default:
          value = 0;
      }

      if (value > maxY) {
        maxY = value;
      }

      barGroups.add(BarChartGroupData(
        x: item.month ?? 0,
        barRods: [
          BarChartRodData(
            toY: value,
            color: Provider.of<Providercolor>(context).selectedColor,
            width: 12,
          ),
        ],
      ));
    }

    // double calculatedMaxY = 55.5;
    double calculatedMaxY = maxY > 0 ? (maxY * 1.1).ceilToDouble() : 100;

    return Card(
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.robotoCondensed(
                fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BarChart(
                BarChartData(
                    maxY: calculatedMaxY,
                    barGroups: barGroups,
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles:
                            SideTitles(showTitles: true, reservedSize: 40),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) {
                            int month = value.toInt();
                            return Text(
                              month.toString(),
                              style: GoogleFonts.robotoCondensed(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            );
                          },
                          interval: 1,
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barTouchData: BarTouchData(enabled: true)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
