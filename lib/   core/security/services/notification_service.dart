import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';

// أنواع المنبهات عشان نميزهم
enum NotificationType {
  journal,      // مذكرة يومية
  exercise,     // تمرين
  meal,         // أكل
  water,        // شرب مية
  medication,   // دوا
  appointment,  // معاد مهم
  custom,       // أي حاجة تانية
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // IDs ثابتة لكل نوع عشان نعرف نلغي ونعدل
  static const int journalId = 1;
  static const int exerciseId = 2;
  static const int mealId = 3;
  static const int waterId = 4;
  static const int medicationId = 5;
  static const int appointmentId = 6;

  static Future<void> init() async {
    tz.initializeTimeZones();
    
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: onNotificationTap,
    );
  }

  static void onNotificationTap(NotificationResponse response) {
    // هنا هنحدد لما يدوس على الاشعار يفتح ايه
    // هنظبطها بعدين في main.dart
    print('Notification tapped: ${response.payload}');
  }

  // منبه يومي متكرر
  static Future<void> scheduleDaily({
    required NotificationType type,
    required String title,
    required String body,
    required TimeOfDay time,
    String? payload,
  }) async {
    final int id = type.index;
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfTime(time),
      _getNotificationDetails(type),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }

  // منبه لتاريخ ووقت محدد مرة واحدة - للمواعيد المهمة
  static Future<void> scheduleOneTime({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required NotificationType type,
    String? payload,
  }) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      _getNotificationDetails(type),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  // منبه أسبوعي - للتمارين مثلا سبت واتنين واربع
  static Future<void> scheduleWeekly({
    required NotificationType type,
    required String title,
    required String body,
    required TimeOfDay time,
    required List<int> days, // 1=اتنين, 2=تلات... 7=حد
  }) async {
    for (int day in days) {
      final int id = type.index * 100 + day; // id فريد لكل يوم
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        _nextInstanceOfWeekday(time, day),
        _getNotificationDetails(type),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  static NotificationDetails _getNotificationDetails(NotificationType type) {
    String channelId = 'default_channel';
    String channelName = 'Default';
    String channelDesc = 'Default notifications';
    
    switch (type) {
      case NotificationType.journal:
        channelId = 'journal_channel';
        channelName = 'المذكرة اليومية';
        channelDesc = 'تذكير بكتابة المذكرات';
        break;
      case NotificationType.exercise:
        channelId = 'exercise_channel';
        channelName = 'التمارين';
        channelDesc = 'تذكير بالتمارين الرياضية';
        break;
      case NotificationType.meal:
        channelId = 'meal_channel';
        channelName = 'الوجبات';
        channelDesc = 'تذكير بمواعيد الأكل';
        break;
      case NotificationType.water:
        channelId = 'water_channel';
        channelName = 'شرب المياه';
        channelDesc = 'تذكير بشرب المياه';
        break;
      case NotificationType.medication:
        channelId = 'medication_channel';
        channelName = 'الأدوية';
        channelDesc = 'تذكير بمواعيد الدواء';
        break;
      case NotificationType.appointment:
        channelId = 'appointment_channel';
        channelName = 'المواعيد المهمة';
        channelDesc = 'تذكير بالمواعيد';
        break;
      case NotificationType.custom:
        channelId = 'custom_channel';
        channelName = 'مخصص';
        channelDesc = 'تنبيهات مخصصة';
        break;
    }

    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDesc,
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  static tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  static tz.TZDateTime _nextInstanceOfWeekday(TimeOfDay time, int weekday) {
    tz.TZDateTime scheduledDate = _nextInstanceOfTime(time);
    while (scheduledDate.weekday != weekday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  // إلغاء منبه بنوعه
  static Future<void> cancel(NotificationType type) async {
    if (type == NotificationType.exercise) {
      // الغي كل ايام التمرين
      for (int i = 1; i <= 7; i++) {
        await _notifications.cancel(type.index * 100 + i);
      }
    } else {
      await _notifications.cancel(type.index);
    }
  }

  // إلغاء منبه ب ID محدد
  static Future<void> cancelById(int id) async {
    await _notifications.cancel(id);
  }

  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
