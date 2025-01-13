import 'dart:math';
import 'package:app_1helo/model/notification_model.dart';
import 'package:app_1helo/provider/provider_color.dart';
import 'package:app_1helo/service/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationService notificationService = NotificationService();
  final ScrollController _scrollController = ScrollController();

  List<Data> unreadNotifications = [];
  List<Data> readNotifications = [];
  bool isLoading = false;
  int currentPage = 1;
  final int pageSize = 10;
  bool hasMoreData = true;

  String getRandomImage(int rowNumber) {
    List<String> images = [
      'resources/7.jpg',
      'resources/50.jpg',
      'resources/43.jpg',
      'resources/45.jpg',
      'resources/11.jpg',
      'resources/47.jpg',
      'resources/34.jpg',
      'resources/51.jpg',
    ];
    return images[rowNumber % images.length];
  }

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoading &&
          hasMoreData) {
        _fetchNotifications();
      }
    });
  }

  Future<void> _fetchNotifications() async {
    setState(() {
      isLoading = true;
    });

    try {
      final newNotifications =
          await notificationService.fetchNotification(currentPage, pageSize);

      setState(() {
        currentPage++;
        unreadNotifications.addAll(
            newNotifications.where((notif) => notif.isRead == 0).toList());
        readNotifications.addAll(
            newNotifications.where((notif) => notif.isRead == 1).toList());
        if (newNotifications.length < pageSize) {
          hasMoreData = false;
        }
      });
    } catch (e) {
      // Xử lý lỗi tải thông báo
      print('Error fetching notifications: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatNotificationTime(String createdDateTime) {
    try {
      final createdTime = DateTime.parse(createdDateTime).toLocal();
      final currentTime = DateTime.now();
      final difference = currentTime.difference(createdTime);

      if (difference.inSeconds < 60) {
        return 'Vừa xong';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes} phút trước';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} giờ trước';
      } else {
        return '${difference.inDays} ngày trước';
      }
    } catch (e) {
      return 'Không xác định'; // Trường hợp lỗi
    }
  }

  String _formatDateTime(String dateTimeString) {
    try {
      DateTime dateTime = DateTime.parse(dateTimeString);
      // Định dạng ngày tháng theo kiểu dd/MM/yyyy HH:mm
      return DateFormat('dd/MM/yyyy, HH:mm').format(dateTime);
    } catch (e) {
      return 'Không xác định';
    }
  }

  void showNotificationDetailsDialog(
      BuildContext context, dynamic notification) {
    String title = '';
    final stylesText = GoogleFonts.robotoCondensed(
        color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600);

    if (notification.requestType == 1) {
      title = 'Yêu cầu hủy hồ sơ C/O';
    } else if (notification.requestType == 2) {
      title = 'Yêu cầu sửa hồ sơ C/O';
    } else {
      title = 'Chi tiết thông báo'; // Tiêu đề mặc định
    }
    showDialog(
      context: context,
      builder: (context) {
        final textStyle = GoogleFonts.robotoCondensed(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14);
        final stylesTextData =
            GoogleFonts.robotoCondensed(color: Colors.black, fontSize: 14);
        return AlertDialog(
          title: Text(
            title,
            style: stylesText,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(children: [
                  TextSpan(text: 'Nhân viên: ', style: textStyle),
                  TextSpan(
                      text: '${notification.sender ?? 'Không rõ'}',
                      style: stylesTextData)
                ]),
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(children: [
                  TextSpan(text: 'Nội dung: ', style: textStyle),
                  TextSpan(
                      text: '${notification.content ?? 'Không có nội dung'}',
                      style: stylesTextData)
                ]),
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(children: [
                  TextSpan(text: 'Thời gian: ', style: textStyle),
                  TextSpan(
                      text:
                          (_formatDateTime(notification.createdDateTime ?? '')),
                      style: stylesTextData)
                ]),
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Khách hàng: ', style: textStyle),
                    TextSpan(
                        text: ' ${notification.customerName ?? 'Không rõ'}',
                        style: stylesTextData)
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Mã hồ sơ CO: ', style: textStyle),
                    TextSpan(
                        text: '${notification.target ?? 'Không rõ'}',
                        style: GoogleFonts.robotoCondensed(
                            color: Colors.blue, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Lý do: ', style: textStyle),
                    TextSpan(
                        text: '${notification.reason ?? 'Không rõ'}',
                        style: stylesTextData)
                  ],
                ),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    border: Border.all(
                        width: 2,
                        color:
                            Provider.of<Providercolor>(context).selectedColor),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Không',
                      style: GoogleFonts.robotoCondensed(
                          color: Provider.of<Providercolor>(context)
                              .selectedColor),
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Provider.of<Providercolor>(context).selectedColor),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Đồng ý',
                      style: GoogleFonts.robotoCondensed(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final testStyles = GoogleFonts.robotoCondensed(
        fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black);
    final testStyle = GoogleFonts.robotoCondensed(
        fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DANH SÁCH THÔNG BÁO',
          style: GoogleFonts.robotoCondensed(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        padding: const EdgeInsets.all(8.0),
        color: Colors.white,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: Colors.grey)),
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Chưa đọc',
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: unreadNotifications.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final notification = unreadNotifications[index];
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: ListTile(
                            leading: SizedBox(
                              width: 45,
                              height: 45,
                              child: Image.asset(
                                getRandomImage(notification.rowNumber ?? 0),
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              notification.content ?? 'Không có nội dung',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: testStyles,
                            ),
                            subtitle: Text(
                              formatNotificationTime(
                                  notification.createdDateTime ?? ''),
                              style: testStyle,
                            ),
                            onTap: () {
                              showNotificationDetailsDialog(
                                  context, notification);
                            },
                          ),
                        );
                      },
                    ),

                    // Danh sách đã đọc
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Tất cả',
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: readNotifications.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final notification = readNotifications[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: ListTile(
                            leading: SizedBox(
                              width: 45,
                              height: 45,
                              child: Image.asset(
                                getRandomImage(notification.rowNumber ?? 0),
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              notification.content ?? 'Không có nội dung',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              formatNotificationTime(
                                  notification.createdDateTime ?? ''),
                            ),
                            onTap: () {
                              showNotificationDetailsDialog(
                                  context, notification);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              if (isLoading &&
                  (unreadNotifications.isEmpty && readNotifications.isEmpty))
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
