import 'dart:math';
import 'package:app_1helo/model/notification_model.dart';
import 'package:app_1helo/provider/provider_color.dart';
import 'package:app_1helo/service/notification_delete_service.dart';
import 'package:app_1helo/service/notification_service.dart';
import 'package:app_1helo/service/refuse_notification_service.dart';
import 'package:app_1helo/service/request_notification_service.dart';
import 'package:app_1helo/service/update_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationService notificationService = NotificationService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController reasonController = TextEditingController();

  List<Data> unreadNotifications = [];
  List<Data> readNotifications = [];
  bool isLoading = false;
  int currentPage = 1;
  final int pageSize = 10;
  bool hasMoreData = true;
  List<String> deletedNotificationIds = [];

  void removeNotification(Data notification) {
    setState(() {
      // Add deleted notification's ID to the list
      deletedNotificationIds.add(notification.historyNotificationsId ?? '');

      // Remove from both unread and read lists
      unreadNotifications
          .removeWhere((notif) => notif.notifyId == notification.notifyId);
      readNotifications
          .removeWhere((notif) => notif.notifyId == notification.notifyId);
    });
  }

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
      return 'Không xác định';
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

  Future<String?> showNotificationDetailsDialog(
    BuildContext context,
    dynamic notification,
    Function(Data) removeNotification,
  ) async {
    bool isReadBool = notification.isRead == 1;
    final selectedColor =
        Provider.of<Providercolor>(context, listen: false).selectedColor;

    if (!isReadBool) {
      final updateNotification = await fetchNotificationUpdate(
        notifyId: notification.notifyId ?? '',
        isRead: true,
        senderId: notification.senderId ?? '',
        recordCount: notification.recordCount,
        rowNumber: notification.rowNumber,
        accessCoDetail: notification.accessCoDetail,
        activeFlag: notification.activeFlag,
        content: notification.content,
        createdDateTime: notification.createdDateTime,
        customerName: notification.customerName,
        historyNotificationsId: notification.historyNotificationsId,
        isReceived: 1,
        reason: notification.reason,
        requestType: notification.requestType,
        sender: notification.sender,
        target: notification.target,
      );

      if (updateNotification == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Không thể tải thông báo, vui lòng thử lại!")),
        );
        return null;
      }

      notification.isRead = 1;
    }

    String getTitleByRequestType(int requestType,
        {String defaultTitle = 'Chi tiết thông báo'}) {
      switch (requestType) {
        case 1:
          return 'Yêu cầu hủy hồ sơ C/O';
        case 2:
          return 'Yêu cầu sửa hồ sơ C/O';
        default:
          return defaultTitle;
      }
    }

    String title = getTitleByRequestType(notification.requestType);
    String titleNo = getTitleByRequestType(notification.requestType,
            defaultTitle: 'Chi tiết thông báo')
        .replaceFirst('Yêu cầu ', '');
    String titleReson = notification.requestType == 1
        ? 'Lý do không đồng ý hủy'
        : notification.requestType == 2
            ? 'Lý do không đồng ý sửa'
            : 'Chi tiết thông báo';

    final stylesText = GoogleFonts.robotoCondensed(
        color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600);
    final stylesTextContent = GoogleFonts.robotoCondensed(
        color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500);

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
                TextSpan(children: [
                  TextSpan(text: 'Khách hàng: ', style: textStyle),
                  TextSpan(
                      text: ' ${notification.customerName ?? 'Không rõ'}',
                      style: stylesTextData)
                ]),
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(children: [
                  TextSpan(text: 'Mã hồ sơ CO: ', style: textStyle),
                  TextSpan(
                      text: '${notification.target ?? 'Không rõ'}',
                      style: GoogleFonts.robotoCondensed(
                          color: Colors.blue, fontSize: 14)),
                ]),
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(children: [
                  TextSpan(text: 'Lý do: ', style: textStyle),
                  TextSpan(
                      text: '${notification.reason ?? 'Không rõ'}',
                      style: stylesTextData)
                ]),
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
                      border: Border.all(width: 2, color: selectedColor)),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          TextEditingController reasonController =
                              TextEditingController();
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(titleNo, style: stylesText),
                                  const SizedBox(height: 8),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                            text: 'Từ chối $titleNo',
                                            style: stylesTextContent),
                                        TextSpan(
                                            text: ' "${notification.target}"?',
                                            style: GoogleFonts.robotoCondensed(
                                                fontSize: 16,
                                                color: Colors.red))
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: reasonController,
                                    decoration: InputDecoration(
                                      labelText: '*$titleReson',
                                      labelStyle: stylesTextContent,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    maxLines: 3,
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                width: 2,
                                                color: selectedColor)),
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.black54,
                                          ),
                                          child: Text(
                                            'Không',
                                            style: GoogleFonts.robotoCondensed(
                                                color:
                                                    Provider.of<Providercolor>(
                                                            context)
                                                        .selectedColor),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: selectedColor),
                                        child: TextButton(
                                          onPressed: () async {
                                            final bool isReadValue =
                                                notification.isRead == 1;
                                            final bool isReceivedValue =
                                                notification.isReceived == 1;
                                            // Lấy giá trị từ TextField
                                            final reason =
                                                reasonController.text.trim();

                                            if (reason.isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        "Vui lòng nhập lý do!")),
                                              );
                                              return;
                                            }
                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            final userId =
                                                prefs.getString('userId');

                                            if (userId != null) {
                                              DateTime now = DateTime.now();
                                              String formattedDateTime =
                                                  "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

                                              final response =
                                                  await fetchNotificationRefuse(
                                                activeFlag:
                                                    notification.activeFlag,
                                                content:
                                                    "Demo đã từ chối yêu cầu hồ sơ số ${notification.target}",
                                                createdDateTime:
                                                    formattedDateTime,
                                                historyNotificationsId:
                                                    notification
                                                        .historyNotificationsId,
                                                reason: reason,
                                                isRead: false,
                                                isReceived: false,
                                                receiver: notification.senderId,
                                                requestType: 4,
                                                senderId: userId,
                                                target: notification.target,
                                                type: 2,
                                              );

                                              if (response == null) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          "Không thể gửi yêu cầu, vui lòng thử lại!")),
                                                );
                                                return;
                                              }

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        "Yêu cầu đã được gửi thành công!")),
                                              );

                                              final deleteResponse =
                                                  await fetchNotificationRequest(
                                                notificationIds: [
                                                  notification.notifyId
                                                ],
                                              );

                                              if (deleteResponse == null) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          "Không thể xóa thông báo, vui lòng thử lại!")),
                                                );
                                              } else {
                                                Navigator.of(context).pop();

                                                removeNotification(
                                                    notification);
                                                _fetchNotifications();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          "Thông báo đã được xóa thành công!")),
                                                );
                                              }
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        "Không thể xác định người dùng, vui lòng thử lại!")),
                                              );
                                            }
                                          },
                                          child: Text(
                                            'Gửi',
                                            style: GoogleFonts.robotoCondensed(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
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
                    color: selectedColor,
                  ),
                  child: TextButton(
                    onPressed: () async {
                      final bool isReadValue = notification.isRead == 1;
                      final bool isReceivedValue = notification.isReceived == 1;

                      final prefs = await SharedPreferences.getInstance();
                      final userId = prefs.getString('userId');

                      if (userId != null) {
                        DateTime now = DateTime.now();
                        String formattedDateTime =
                            "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
                        // First API Call: Send Notification Request
                        final response = await fetchNotificationResquest(
                          activeFlag: notification.activeFlag,
                          content:
                              "Demo đã đồng ý yêu cầu chấp thuận hồ sơ ${notification.target}",
                          createdDateTime: formattedDateTime,
                          historyNotificationsId:
                              notification.historyNotificationsId,
                          isRead: false,
                          isReceived: false,
                          receiver: notification.senderId,
                          requestType: 3,
                          senderId: userId,
                          target: notification.target,
                          type: 2,
                        );

                        if (response == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Không thể gửi yêu cầu, vui lòng thử lại!")),
                          );
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Yêu cầu đã được gửi thành công!")),
                        );

                        final deleteResponse = await fetchNotificationRequest(
                          notificationIds: [notification.notifyId],
                        );

                        if (deleteResponse == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Không thể xóa thông báo, vui lòng thử lại!")),
                          );
                        } else {
                          Navigator.of(context).pop();

                          removeNotification(notification);
                          _fetchNotifications();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Thông báo đã được xóa thành công!")),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  "Không thể xác định người dùng, vui lòng thử lại!")),
                        );
                      }
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
    return null;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1, color: Colors.grey),
                        ),
                        margin: const EdgeInsets.only(bottom: 10),
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
                                context, notification, removeNotification);
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
                          onTap: () async {
                            showNotificationDetailsDialog(
                                context, notification, removeNotification);
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
}
