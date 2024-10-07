import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Documentpage extends StatefulWidget {
  const Documentpage({super.key});

  @override
  State<Documentpage> createState() => _DocumentpageState();
}

class _DocumentpageState extends State<Documentpage> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    final myList = [
      MyData(value: 10, color: Colors.red, title: 'A'),
      MyData(value: 20, color: Colors.blue, title: 'B'),
      MyData(value: 30, color: Colors.green, title: 'C'),
      MyData(value: 40, color: Colors.yellow, title: 'D'),
      MyData(value: 50, color: Colors.pink, title: 'E'),
    ];
    const textStyle = TextStyle(
        color: Colors.black12, fontWeight: FontWeight.bold, fontSize: 18);
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 15,
                margin: const EdgeInsets.only(left: 250),
                child: Container(
                  width: 10,
                  height: 10,
                  child: const Text('Chú thích'),
                ),
              ),
              Container(
                width: double.infinity,
                height: 40,
                margin: const EdgeInsets.only(left: 200),
                child: const Row(
                  children: [
                    Text('Màu đỏ', style: TextStyle(color: Colors.red)),
                    SizedBox(width: 15),
                    Text(
                      'Màu vàng',
                      style: TextStyle(color: Colors.yellow),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 40,
                margin: const EdgeInsets.only(left: 200),
                child: const Row(
                  children: [
                    Text('Màu blue', style: TextStyle(color: Colors.blue)),
                    SizedBox(width: 15),
                    Text('Màu hồng', style: TextStyle(color: Colors.pink)),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 40,
                margin: const EdgeInsets.only(left: 200),
                child: const Row(
                  children: [
                    Text('Màu green', style: TextStyle(color: Colors.green)),
                  ],
                ),
              )
            ],
          ),
          Center(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                  color: Colors.transparent,
                  margin: const EdgeInsets.all(10.0),
                  child: PieChart(
                      PieChartData(
                        sections: myList.asMap().entries.map((mapEntry) {
                          final index = mapEntry.key;
                          final data = mapEntry.value;
                          // final isLast = index == myList.length - 1;
                          final isTouched = _index == index;
                          final isLast = isTouched;
                          return PieChartSectionData(
                            value: data.value,
                            color: data.color,
                            radius: isTouched ? 80 : 50,
                            showTitle: true,
                            titleStyle: isLast
                                ? textStyle.copyWith(color: Colors.black)
                                : textStyle,
                            title: data.title,
                            borderSide: isLast
                                ? const BorderSide(
                                    width: 4, color: Colors.black)
                                : BorderSide.none,
                          );
                        }).toList(),
                        centerSpaceRadius: 100,
                        centerSpaceColor: Colors.black12,
                        sectionsSpace: 4,
                        startDegreeOffset: 45,
                        pieTouchData: PieTouchData(
                          touchCallback: (
                            FlTouchEvent e,
                            PieTouchResponse? r,
                          ) {
                            if (r != null && r.touchedSection != null) {
                              setState(() {
                                _index = r.touchedSection!.touchedSectionIndex;
                              });
                            }
                            if (e is FlTapUpEvent) {
                              print('tapUpEvent');
                            }
                          },
                          mouseCursorResolver: (
                            FlTouchEvent e,
                            PieTouchResponse? r,
                          ) {
                            if (r != null &&
                                r.touchedSection != null &&
                                r.touchedSection!.touchedSectionIndex != -1) {
                              return SystemMouseCursors.click;
                            }
                            return SystemMouseCursors.basic;
                          },
                        ),
                      ),
                      swapAnimationDuration: const Duration(milliseconds: 1000),
                      swapAnimationCurve: Curves.bounceOut)),
            ),
          ),
        ],
      ),
    );
  }
}

class MyData {
  final double value;
  final Color color;
  final String title;
  MyData({required this.value, required this.color, required this.title});
}
