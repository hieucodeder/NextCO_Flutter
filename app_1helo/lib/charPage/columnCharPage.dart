import 'package:app_1helo/charPage/MultiBarChartWidget.dart';
import 'package:app_1helo/model/columnChar.dart';
import 'package:app_1helo/service/columnChar_service.dart';
import 'package:flutter/material.dart';

class Columncharpage extends StatefulWidget {
  final Function(int) onSelectPage;
  const Columncharpage({super.key, required this.onSelectPage});
  @override
  _ColumncharpageState createState() => _ColumncharpageState();
}

class _ColumncharpageState extends State<Columncharpage> {
  late Future<List<ColumnChar>> futureData;
  int selectedYear = 2024;

  @override
  void initState() {
    super.initState();
    fetchChartDataForYear(selectedYear);
  }

  void fetchChartDataForYear(int year) {
    setState(() {
      futureData = fetchChartData(year);
    });
  }

  // Hàm tự động tăng năm
  List<DropdownMenuItem<int>> getYearOptions() {
    //Biến năm hiện tại
    final int currentYear = DateTime.now().year;
    return List.generate(3, (index) {
      final int year = currentYear - index;
      return DropdownMenuItem<int>(
        value: year,
        child: Text(year.toString()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Lọc theo năm:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 5,
                ),
                Container(
                    height: 34,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 1, color: Colors.black12),
                        color: Colors.white),
                    child: DropdownButton<int>(
                      value: selectedYear,
                      underline: const SizedBox.shrink(),
                      items: getYearOptions(),
                      onChanged: (year) {
                        if (year != null) {
                          setState(() {
                            selectedYear = year;
                            fetchChartDataForYear(selectedYear);
                          });
                        }
                      },
                    )),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ColumnChar>>(
              future: futureData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Lỗi khi tải dữ liệu'));
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        MultiBarChartWidget(
                          data: data,
                          title: 'Số lượng CO đã tạo',
                          filterKey: 'coNumber',
                        ),
                        const SizedBox(height: 16),
                        MultiBarChartWidget(
                          data: data,
                          title: 'Số lượng VAT đã tạo',
                          filterKey: 'vatNumber',
                        ),
                        const SizedBox(height: 16),
                        MultiBarChartWidget(
                          data: data,
                          title: 'Số lượng TKN đã tạo',
                          filterKey: 'importDeclarationNumber',
                        ),
                        const SizedBox(height: 16),
                        MultiBarChartWidget(
                          data: data,
                          title: 'Số lượng TKX đã tạo',
                          filterKey: 'exportDeclarationNumber',
                        ),
                        const SizedBox(height: 16),
                        MultiBarChartWidget(
                          data: data,
                          title: 'Số lượng người dùng đã tạo',
                          filterKey: 'userNumber',
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                      child: Text('Không có dữ liệu để hiển thị'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
