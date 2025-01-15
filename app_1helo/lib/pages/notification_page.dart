import 'dart:math';
import 'package:app_1helo/model/notification_model.dart';
import 'package:app_1helo/provider/provider_color.dart';
import 'package:app_1helo/service/notification_service.dart';
import 'package:app_1helo/service/update_notification_service.dart';
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

  // void showNotificationDetailsDialog(
  //     BuildContext context, dynamic notification) {
  //   String title = '';
  //   final stylesText = GoogleFonts.robotoCondensed(
  //       color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600);

  //   if (notification.requestType == 1) {
  //     title = 'Yêu cầu hủy hồ sơ C/O';
  //   } else if (notification.requestType == 2) {
  //     title = 'Yêu cầu sửa hồ sơ C/O';
  //   } else {
  //     title = 'Chi tiết thông báo'; // Tiêu đề mặc định
  //   }
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       final textStyle = GoogleFonts.robotoCondensed(
  //           fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14);
  //       final stylesTextData =
  //           GoogleFonts.robotoCondensed(color: Colors.black, fontSize: 14);
  //       return AlertDialog(
  //         title: Text(
  //           title,
  //           style: stylesText,
  //         ),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text.rich(
  //               TextSpan(children: [
  //                 TextSpan(text: 'Nhân viên: ', style: textStyle),
  //                 TextSpan(
  //                     text: '${notification.sender ?? 'Không rõ'}',
  //                     style: stylesTextData)
  //               ]),
  //             ),
  //             const SizedBox(height: 8),
  //             Text.rich(
  //               TextSpan(children: [
  //                 TextSpan(text: 'Nội dung: ', style: textStyle),
  //                 TextSpan(
  //                     text: '${notification.content ?? 'Không có nội dung'}',
  //                     style: stylesTextData)
  //               ]),
  //             ),
  //             const SizedBox(height: 8),
  //             Text.rich(
  //               TextSpan(children: [
  //                 TextSpan(text: 'Thời gian: ', style: textStyle),
  //                 TextSpan(
  //                     text:
  //                         (_formatDateTime(notification.createdDateTime ?? '')),
  //                     style: stylesTextData)
  //               ]),
  //             ),
  //             const SizedBox(height: 8),
  //             Text.rich(
  //               TextSpan(
  //                 children: [
  //                   TextSpan(text: 'Khách hàng: ', style: textStyle),
  //                   TextSpan(
  //                       text: ' ${notification.customerName ?? 'Không rõ'}',
  //                       style: stylesTextData)
  //                 ],
  //               ),
  //             ),
  //             const SizedBox(height: 8),
  //             Text.rich(
  //               TextSpan(
  //                 children: [
  //                   TextSpan(text: 'Mã hồ sơ CO: ', style: textStyle),
  //                   TextSpan(
  //                       text: '${notification.target ?? 'Không rõ'}',
  //                       style: GoogleFonts.robotoCondensed(
  //                           color: Colors.blue, fontSize: 14)),
  //                 ],
  //               ),
  //             ),
  //             const SizedBox(height: 8),
  //             Text.rich(
  //               TextSpan(
  //                 children: [
  //                   TextSpan(text: 'Lý do: ', style: textStyle),
  //                   TextSpan(
  //                       text: '${notification.reason ?? 'Không rõ'}',
  //                       style: stylesTextData)
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //             children: [
  //               Container(
  //                 height: 40,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10),
  //                   color: Colors.white,
  //                   border: Border.all(
  //                       width: 2,
  //                       color:
  //                           Provider.of<Providercolor>(context).selectedColor),
  //                 ),
  //                 child: TextButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: Text(
  //                     'Không',
  //                     style: GoogleFonts.robotoCondensed(
  //                         color: Provider.of<Providercolor>(context)
  //                             .selectedColor),
  //                   ),
  //                 ),
  //               ),
  //               Container(
  //                 height: 40,
  //                 decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(10),
  //                     color: Provider.of<Providercolor>(context).selectedColor),
  //                 child: TextButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: Text(
  //                     'Đồng ý',
  //                     style: GoogleFonts.robotoCondensed(color: Colors.white),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  void showNotificationDetailsDialog(
      BuildContext context, dynamic notification) async {
// Chuyển đổi `isRead` từ `int` sang `bool` để so sánh
    bool isReadBool = notification.isRead == 1;
    print(
        "Current isRead (int): ${notification.isRead}, Converted isRead (bool): $isReadBool");

// Nếu thông báo chưa được đọc (isReadBool == false), gọi API để cập nhật trạng thái
    if (!isReadBool) {
      print("Notification is not read. Sending update API request...");

      final updateNotification = await fetchNotificationUpdate(
        notifyId: notification.notifyId ?? '', // ID của thông báo
        isRead: true, // Đánh dấu là đã đọc
        senderId: notification.senderId ?? '', // ID người gửi
        recordCount: notification.recordCount, // Số lượng bản ghi
        rowNumber: notification.rowNumber, // Số thứ tự dòng
        accessCoDetail: notification.accessCoDetail, // Chi tiết quyền truy cập
        activeFlag: notification.activeFlag, // Cờ hoạt động
        content: notification.content, // Nội dung thông báo
        createdDateTime: notification.createdDateTime, // Thời gian tạo
        customerName: notification.customerName, // Tên khách hàng
        historyNotificationsId:
            notification.historyNotificationsId, // ID thông báo lịch sử
        isReceived: 1, // Trạng thái đã nhận
        reason: notification.reason, // Lý do
        requestType: notification.requestType, // Loại yêu cầu
        sender: notification.sender, // Người gửi
        target: notification.target, // Mục tiêu
      );

      if (updateNotification == null) {
        // Xử lý lỗi khi không lấy được chi tiết thông báo
        print("Failed to update notification status. API returned null.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Không thể tải thông báo, vui lòng thử lại!")),
        );
        return;
      }

      // Cập nhật trạng thái isRead trong đối tượng notification
      print("API call successful. Updating isRead to 1.");
      notification.isRead = 1; // Đánh dấu là đã đọc
    } else {
      print("Notification is already read. No API call needed.");
    }

    // Hiển thị dialog
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
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints.expand(),
        color: Colors.grey.withOpacity(0.1),
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
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: unreadNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = unreadNotifications[index];
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
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: readNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = readNotifications[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1, color: Colors.grey),
                        ),
                        child: ListTile(
                          leading: Container(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10)),
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
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
