import 'package:flutter/material.dart';
import 'package:app_1helo/service/notification_service.dart';
import 'package:app_1helo/model/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  late NotificationService _notificationService;
  List<Data> _notifications = [];
  int _unreadCount = 0;

  NotificationProvider() {
    _notificationService = NotificationService();
    fetchNotifications();
  }

  int get unreadCount => _unreadCount;

  List<Data> get notifications => _notifications;

  /// Fetch notifications from the server
  Future<void> fetchNotifications() async {
    try {
      List<Data> notifications =
          await _notificationService.fetchNotification(1, 10);

      _notifications = notifications;

      // Cập nhật số lượng thông báo chưa đọc
      _unreadCount = _notifications.where((notif) => notif.isRead == 0).length;
      notifyListeners();
    } catch (e) {
      debugPrint('Lỗi khi lấy dữ liệu thông báo: $e');
    }
  }

  // /// Đánh dấu tất cả thông báo là đã đọc
  // void markAllAsRead() {
  //   for (var notification in _notifications) {
  //     notification.isRead = 1;
  //   }
  //   _unreadCount = 0;
  //   notifyListeners();
  // }

  // /// Đánh dấu một thông báo cụ thể là đã đọc
  // void markAsRead(int notificationId) {
  //   final notification =
  //       _notifications.firstWhere((notif) => notif.id == notificationId, orElse: () => null);
  //   if (notification != null && notification.isRead == 0) {
  //     notification.isRead = 1;
  //     _unreadCount -= 1;
  //     notifyListeners();
  //   }
  // }

  /// Kiểm tra xem có thông báo nào chưa đọc không
  bool hasUnreadNotifications() {
    return _unreadCount > 0;
  }
}
