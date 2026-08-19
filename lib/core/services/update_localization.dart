class UpdateLocalization {
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'updateAvailable': 'Update Available',
      'newVersionAvailable': 'A new version is available',
      'later': 'Later',
      'update': 'Update',
      'downloading': 'Downloading...',
      'downloadComplete': 'Download Complete',
      'install': 'Install',
      'whatsNew': 'What\'s New',
      'version': 'Version',
      'fileSize': 'File Size',
    },
    'ar': {
      'updateAvailable': 'تحديث متاح',
      'newVersionAvailable': 'إصدار جديد متاح',
      'later': 'لاحقاً',
      'update': 'تحديث',
      'downloading': 'جاري التحميل...',
      'downloadComplete': 'اكتمل التحميل',
      'install': 'تثبيت',
      'whatsNew': 'ما الجديد',
      'version': 'الإصدار',
      'fileSize': 'حجم الملف',
    },
  };

  static String get(String key, String languageCode) {
    return _localizedValues[languageCode]?[key]??
           _localizedValues['en']?[key]??
           key;
  }
}
