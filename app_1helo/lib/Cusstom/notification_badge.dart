import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_1helo/provider/notification_provider .dart';
import 'package:app_1helo/pages/notification_page.dart';

class NotificationBadge extends StatelessWidget {
  const NotificationBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationBadge notificationBadge;
    // Gọi Provider để truy cập dữ liệu từ NotificationProvider
    final notificationProvider = Provider.of<NotificationProvider>(context);

    // Lấy số lượng thông báo chưa đọc
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
