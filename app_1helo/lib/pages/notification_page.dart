import 'package:app_1helo/model/notification_model.dart';
import 'package:app_1helo/service/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  @override
  Widget build(BuildContext context) {
    final testStyles = GoogleFonts.robotoCondensed(
        fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black);
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
                    // Danh sách chưa đọc
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
                            leading: Image.asset(
                              'resources/avatarcute.jpg',
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
                              // Xử lý khi nhấp vào thông báo
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => NotificationDetailPage(
                              //       notification: notification,
                              //     ),
                              //   ),
                              // );
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
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: ListTile(
                            leading: Image.asset(
                              'resources/avatarcute.jpg',
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
                                style: testStyle),
                            onTap: () {
                              // Xử lý khi nhấp vào thông báo
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => NotificationDetailPage(
                              //       notification: notification,
                              //     ),
                              //   ),
                              // );
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
