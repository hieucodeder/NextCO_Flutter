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

  // Hàm để cập nhật thông báo
  void setNotifications(List<Data> notifications) {
    _notifications = notifications;
    notifyListeners(); // Thông báo trạng thái đã thay đổi
  }

  List<Data> get notifications => _notifications;
  Future<void> fetchNotifications() async {
    try {
      List<Data> notifications =
          await _notificationService.fetchNotification(1, 10);

      _notifications = notifications;
      _unreadCount = _notifications.where((notif) => notif.isRead == 0).length;
      notifyListeners();
    } catch (e) {
      debugPrint('Lỗi khi lấy dữ liệu thông báo: $e');
    }
  }

  bool hasUnreadNotifications() {
    return _unreadCount > 0;
  }
}
