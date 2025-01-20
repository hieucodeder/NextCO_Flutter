import 'package:app_1helo/model/notification_model.dart';
import 'package:app_1helo/service/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_1helo/provider/notification_provider .dart';
import 'package:app_1helo/pages/notification_page.dart';

class NotificationBadge extends StatefulWidget {
  const NotificationBadge({super.key});

  @override
  State<NotificationBadge> createState() => _NotificationBadgeState();
}

class _NotificationBadgeState extends State<NotificationBadge> {
  final _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final List<Data> notifications =
          await _notificationService.fetchNotification(1, 10);

      // Cập nhật danh sách thông báo vào NotificationProvider
      final notificationProvider =
          Provider.of<NotificationProvider>(context, listen: false);
      notificationProvider.setNotifications(notifications);
    } catch (e) {
      print('Lỗi khi lấy thông báo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);

    final unreadCount = notificationProvider.unreadCount;

    return Badge(
      label: Text(
        '$unreadCount',
        style: GoogleFonts.robotoCondensed(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
      backgroundColor: Colors.red,
      isLabelVisible: unreadCount > 0,
      alignment: Alignment.topRight,
      offset: const Offset(-8, 6),
      child: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificationsPage()),
          ).then((_) {
            notificationProvider.fetchNotifications();
          });
        },
        icon: const Icon(Icons.notifications_none_outlined, size: 28),
        color: Colors.white,
      ),
    );
  }
}
