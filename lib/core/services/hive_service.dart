import 'package:hive_flutter/hive_flutter.dart';
import 'encryption_service.dart';

class HiveService {
  static late Box box;
  static late Box offersBox;

  // 1. تشغيل Hive + التشفير
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // مفتاح التشفير بيتجاب من encryption_service
    final encryptionKey = await EncryptionService.getKey();
    
    // البوكس الرئيسي للداتا بتاعت المستخدم - متشفر AES
    box = await Hive.openBox(
      'app_data',
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
    
    // بوكس العروض - مش لازم تشفير لانها عروض عامة
    offersBox = await Hive.openBox('offers');
  }

  // 2. دوال سهلة للحفظ والقراية
  static Future<void> put(String key, dynamic value) async {
    await box.put(key, value);
  }

  static T? get<T>(String key, {T? defaultValue}) {
    return box.get(key, defaultValue: defaultValue) as T?;
  }

  static Future<void> delete(String key) async {
    await box.delete(key);
  }

  // 3. دوال العروض
  static Future<void> saveOffer({
    required String offerId,
    required String title,
    required String description,
    required DateTime expiryDate,
    double? price,
  }) async {
    await offersBox.put(offerId, {
      'title': title,
      'description': description,
      'expiryDate': expiryDate.toIso8601String(),
      'price': price,
      'isActive': true,
    });
  }

  static Map<String, dynamic>? getOffer(String offerId) {
    return offersBox.get(offerId);
  }

  static List<Map> getAllOffers() {
    return offersBox.values.whereType<Map>().toList();
  }

  // 4. مسح كل الداتا - للطوارئ بس
  static Future<void> clear() async {
    await box.clear();
    await offersBox.clear();
  }
}
