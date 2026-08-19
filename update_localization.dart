import 'package:flutter/material.dart';

enum AppLanguage {
  arabicEG, arabicSA, arabicMA, arabicJO,
  englishUS, frenchFR, germanDE,
}

class UpdateLocalization {
  static AppLanguage _currentLang = AppLanguage.arabicEG;
  
  static void setLanguage(AppLanguage lang) => _currentLang = lang;

  static void detectFromLocale(Locale locale) {
    final langCode = locale.languageCode;
    final countryCode = locale.countryCode;
    if (langCode == 'ar') {
      switch (countryCode) {
        case 'SA': case 'AE': case 'KW': case 'QA': case 'BH': case 'OM':
          _currentLang = AppLanguage.arabicSA; break;
        case 'MA': case 'DZ': case 'TN': case 'LY':
          _currentLang = AppLanguage.arabicMA; break;
        case 'JO': case 'SY': case 'LB': case 'PS': case 'IQ':
          _currentLang = AppLanguage.arabicJO; break;
        default: _currentLang = AppLanguage.arabicEG;
      }
    } else if (langCode == 'en') _currentLang = AppLanguage.englishUS;
    else if (langCode == 'fr') _currentLang = AppLanguage.frenchFR;
    else if (langCode == 'de') _currentLang = AppLanguage.germanDE;
    else _currentLang = AppLanguage.arabicEG;
  }

  static String get title => {
    AppLanguage.arabicEG: 'تحديث جديد وصل يا معلم 🚀',
    AppLanguage.arabicSA: 'تحديث جديد متوفر طال عمرك 🌟',
    AppLanguage.arabicMA: 'تحديث جديد كاين أخويا 🔥',
    AppLanguage.arabicJO: 'تحديث جديد متوفر يا كبير 👑',
    AppLanguage.englishUS: 'New Update Available',
    AppLanguage.frenchFR: 'Nouvelle mise à jour disponible',
    AppLanguage.germanDE: 'Neues Update verfügbar',
  }[_currentLang]!;

  static String get message => {
    AppLanguage.arabicEG: 'عملنالك إصدار أسرع وأحلى. حدث دلوقتي وخد هدية VIP لمدة أسبوع',
    AppLanguage.arabicSA: 'سوينا لك إصدار أسرع وأفضل. حدث الحين واحصل على VIP هدية لمدة أسبوع',
    AppLanguage.arabicMA: 'درنا ليك إصدار جديد زوين بزاف. حدث دابا و خود VIP فابور سيمانة',
    AppLanguage.arabicJO: 'عملنالك إصدار جديد كثير مرتب. حدث هسا وخذ VIP هدية أسبوع',
    AppLanguage.englishUS: 'We built a faster version with new features. Update now and get 7 days VIP free',
    AppLanguage.frenchFR: 'Version plus rapide avec nouvelles fonctionnalités. Mettez à jour et obtenez 7 jours VIP gratuit',
    AppLanguage.germanDE: 'Schnellere Version mit neuen Features. Jetzt updaten und 7 Tage VIP gratis erhalten',
  }[_currentLang]!;

  static String get updateNow => {
    AppLanguage.arabicEG: 'حدث دلوقتي',
    AppLanguage.arabicSA: 'حدث الحين',
    AppLanguage.arabicMA: 'حدث دابا',
    AppLanguage.arabicJO: 'حدث هسا',
    AppLanguage.englishUS: 'Update Now',
    AppLanguage.frenchFR: 'Mettre à jour',
    AppLanguage.germanDE: 'Jetzt aktualisieren',
  }[_currentLang]!;

  static String get later => {
    AppLanguage.arabicEG: 'بعدين', AppLanguage.arabicSA: 'بعدين',
    AppLanguage.arabicMA: 'من بعد', AppLanguage.arabicJO: 'بعدين',
    AppLanguage.englishUS: 'Later', AppLanguage.frenchFR: 'Plus tard',
    AppLanguage.germanDE: 'Später',
  }[_currentLang]!;

  static String get skip => {
    AppLanguage.arabicEG: 'تخطي الإصدار ده',
    AppLanguage.arabicSA: 'تخطي هذا الإصدار',
    AppLanguage.arabicMA: 'تخطي هاد الإصدار',
    AppLanguage.arabicJO: 'تخطي هالإصدار',
    AppLanguage.englishUS: 'Skip Version',
    AppLanguage.frenchFR: 'Ignorer la version',
    AppLanguage.germanDE: 'Version überspringen',
  }[_currentLang]!;

  static String get forceUpdate => {
    AppLanguage.arabicEG: 'لازم تحدث عشان تكمل',
    AppLanguage.arabicSA: 'يجب التحديث للمتابعة',
    AppLanguage.arabicMA: 'خاصك تحدث باش تكمل',
    AppLanguage.arabicJO: 'لازم تحدث عشان تكمل',
    AppLanguage.englishUS: 'Update required to continue',
    AppLanguage.frenchFR: 'Mise à jour requise',
    AppLanguage.germanDE: 'Update erforderlich',
  }[_currentLang]!;

  static String get vipGift => {
    AppLanguage.arabicEG: 'حدث وخد VIP مجاناً',
    AppLanguage.arabicSA: 'حدث واحصل على VIP مجاناً',
    AppLanguage.arabicMA: 'حدث و خود VIP فابور',
    AppLanguage.arabicJO: 'حدث وخذ VIP ببلاش',
    AppLanguage.englishUS: 'Update and get VIP free',
    AppLanguage.frenchFR: 'Mettez à jour et obtenez VIP gratuit',
    AppLanguage.germanDE: 'Update und VIP kostenlos erhalten',
  }[_currentLang]!;

  static String get whatsNew => {
    AppLanguage.arabicEG: 'الجديد إيه؟',
    AppLanguage.arabicSA: 'ما الجديد؟',
    AppLanguage.arabicMA: 'شنو الجديد؟',
    AppLanguage.arabicJO: 'شو الجديد؟',
    AppLanguage.englishUS: "What's New?",
    AppLanguage.frenchFR: 'Quoi de neuf ?',
    AppLanguage.germanDE: 'Was ist neu?',
  }[_currentLang]!;

  static String get currentVersionLabel => {
    AppLanguage.arabicEG: 'إصدارك الحالي',
    AppLanguage.arabicSA: 'إصدارك الحالي',
    AppLanguage.arabicMA: 'الإصدار ديالك',
    AppLanguage.arabicJO: 'إصدارك الحالي',
    AppLanguage.englishUS: 'Current Version',
    AppLanguage.frenchFR: 'Version actuelle',
    AppLanguage.germanDE: 'Aktuelle Version',
  }[_currentLang]!;

  static String get newVersionLabel => {
    AppLanguage.arabicEG: 'الجديد',
    AppLanguage.arabicSA: 'الجديد',
    AppLanguage.arabicMA: 'الجديد',
    AppLanguage.arabicJO: 'الجديد',
    AppLanguage.englishUS: 'New',
    AppLanguage.frenchFR: 'Nouveau',
    AppLanguage.germanDE: 'Neu',
  }[_currentLang]!;

  static String getChangelog(List<String> items) {
    final prefix = whatsNew;
    final formatted = items.map((item) {
      switch (_currentLang) {
        case AppLanguage.arabicEG: return '• $item يا نجم';
        case AppLanguage.arabicSA: return '• $item طال عمرك';
        case AppLanguage.arabicMA: return '• $item أخويا';
        case AppLanguage.arabicJO: return '• $item يا كبير';
        default: return '• $item';
      }
    }).join('\n');
    return '$prefix\n$formatted';
  }
}      forceUpdate: config.getBool('force_update'),
      title: config.getString('update_title'),
      message: config.getString('update_message'),
      changelog: config.getString('changelog'),
      androidUrl: config.getString('store_url_android'),
      iosUrl: config.getString('store_url_ios'),
      promptDelayHours: config.getInt('show_update_every_hours'),
      vipGiftDays: config.getInt('gift_vip_days_on_update'),
      channel: UpdateChannel.values.byName(config.getString('update_channel')),
      enableInAppUpdate: config.getBool('enable_in_app_update'),
      rolloutPercent: config.getDouble('rollout_percent'),
    );
  }
}

class AppUpdateService {
  static final _remoteConfig = FirebaseRemoteConfig.instance;
  static final _analytics = FirebaseAnalytics.instance;
  static final _prefs = SharedPreferences.getInstance();
  static DateTime? _lastPromptTime;
  static bool _isChecking = false;

  static const _keyLastPrompt = 'update_last_prompt';
  static const _keySkippedVersion = 'update_skipped_version';
  static const _keyUpdateCount = 'update_prompt_count';

  static Future<void> initialize() async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 10),
        minimumFetchInterval: Duration(minutes: 30),
      ));
      await _remoteConfig.setDefaults({
        'latest_version': '28.4.0',
        'min_required_version': '28.4.0',
        'force_update': false,
        'update_title': '',
        'update_message': '',
        'changelog': '• تحسينات الأداء\n• إصلاح الأخطاء',
        'store_url_android': 'market://details?id=com.dravyn.app',
        'store_url_ios': 'https://apps.apple.com/app/id000000000',
        'show_update_every_hours': 72,
        'gift_vip_days_on_update': 7,
        'update_channel': 'stable',
        'enable_in_app_update': true,
        'rollout_percent': 100.0,
      });
      final prefs = await _prefs;
      final lastPromptMs = prefs.getInt(_keyLastPrompt);
      if (lastPromptMs != null) {
        _lastPromptTime = DateTime.fromMillisecondsSinceEpoch(lastPromptMs);
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  static Future<UpdateStatus> checkForUpdate({bool silent = true}) async {
    if (_isChecking) return UpdateStatus.error;
    _isChecking = true;

    try {
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.none) {
        return UpdateStatus.noInternet;
      }

      await _remoteConfig.fetchAndActivate();
      final config = UpdateConfig.fromRemoteConfig(_remoteConfig);
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      if (!_shouldShowToUser(config.rolloutPercent)) {
        return UpdateStatus.upToDate;
      }

      final comparison = _compareVersions(
        currentVersion.split('.').map(int.parse).toList(),
        config.latestVersion.split('.').map(int.parse).toList(),
      );

      if (comparison >= 0) {
        await _logEvent('update_check_uptodate', {'version': currentVersion});
        return UpdateStatus.upToDate;
      }

      final isRequired = _compareVersions(
        currentVersion.split('.').map(int.parse).toList(),
        config.minRequiredVersion.split('.').map(int.parse).toList(),
      ) < 0 || config.forceUpdate;

      if (isRequired) {
        await _logEvent('update_required', {
          'current': currentVersion,
          'required': config.minRequiredVersion,
        });
        return UpdateStatus.required;
      }

      if (await _shouldPromptUser(config)) {
        await _logEvent('update_available', {
          'current': currentVersion,
          'latest': config.latestVersion,
        });
        return UpdateStatus.available;
      }

      return UpdateStatus.upToDate;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      return UpdateStatus.error;
    } finally {
      _isChecking = false;
    }
  }

  static Future<void> checkAndPrompt(BuildContext context) async {
    final status = await checkForUpdate(silent: false);
    if (!context.mounted) return;

    final config = UpdateConfig.fromRemoteConfig(_remoteConfig);
    final packageInfo = await PackageInfo.fromPlatform();

    switch (status) {
      case UpdateStatus.required:
        _showUpdateDialog(context, config, packageInfo.version, isForce: true);
        break;
      case UpdateStatus.available:
        _showUpdateDialog(context, config, packageInfo.version, isForce: false);
        break;
      case UpdateStatus.noInternet:
        if (kDebugMode) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('لا يوجد إنترنت للتحقق من التحديث')),
          );
        }
        break;
      default:
        break;
    }
  }

  static void _showUpdateDialog(
    BuildContext context,
    UpdateConfig config,
    String currentVersion, {
    required bool isForce,
  }) {
    showDialog(
      context: context,
      barrierDismissible: !isForce,
      builder: (ctx) => AdvancedUpdateDialog(
        config: config,
        isForce: isForce,
        currentVersion: currentVersion,
        onUpdate: () => _handleUpdate(context, config),
        onSkip: () => _handleSkip(context, config.latestVersion),
        onLater: () => Navigator.pop(context),
      ),
    );
    _updateLastPromptTime();
  }

  static Future<void> _handleUpdate(BuildContext context, UpdateConfig config) async {
    Navigator.pop(context);
    await _logEvent('update_button_clicked', {'version': config.latestVersion});

    if (Platform.isAndroid && config.enableInAppUpdate) {
      try {
        final info = await InAppUpdate.checkForUpdate();
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          if (info.immediateUpdateAllowed) {
            await InAppUpdate.performImmediateUpdate();
          } else if (info.flexibleUpdateAllowed) {
            await InAppUpdate.startFlexibleUpdate();
            await InAppUpdate.completeFlexibleUpdate();
          }
          await _grantVipGift(config.vipGiftDays);
          return;
        }
      } catch (e) {
        FirebaseCrashlytics.instance.log('InAppUpdate failed: $e');
      }
    }

    final url = Platform.isIOS ? config.iosUrl : config.androidUrl;
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      await _grantVipGift(config.vipGiftDays);
    }
  }

  static Future<void> _handleSkip(BuildContext context, String version) async {
    final prefs = await _prefs;
    await prefs.setString(_keySkippedVersion, version);
    await _logEvent('update_skipped', {'version': version});
    Navigator.pop(context);
  }

  static Future<void> _grantVipGift(int days) async {
    if (days <= 0) return;
    try {
      final user = FirebaseFirestore.instance.collection('users').doc('CURRENT_USER_ID');
      await user.update({
        'vip_expires': FieldValue.serverTimestamp(),
        'vip_days_added': FieldValue.increment(days),
      });
      await _logEvent('vip_gift_granted', {'days': days});
    } catch (e) {
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
    }
  }

  static Future<bool> _shouldPromptUser(UpdateConfig config) async {
    final prefs = await _prefs;
    final skippedVersion = prefs.getString(_keySkippedVersion);
    if (skippedVersion == config.latestVersion) return false;

    final now = DateTime.now();
    if (_lastPromptTime != null) {
      final hoursSince = now.difference(_lastPromptTime!).inHours;
      if (hoursSince < config.promptDelayHours) return false;
    }

    final count = prefs.getInt(_keyUpdateCount) ?? 0;
    await prefs.setInt(_keyUpdateCount, count + 1);
    return true;
  }

  static bool _shouldShowToUser(double rolloutPercent) {
    if (rolloutPercent >= 100) return true;
    final deviceId = Platform.operatingSystem;
    final hash = deviceId.hashCode % 100;
    return hash < rolloutPercent;
  }

  static int _compareVersions(List<int> v1, List<int> v2) {
    for (int i = 0; i < 3; i++) {
      final a = i < v1.length ? v1[i] : 0;
      final b = i < v2.length ? v2[i] : 0;
      if (a > b) return 1;
      if (a < b) return -1;
    }
    return 0;
  }

  static Future<void> _updateLastPromptTime() async {
    _lastPromptTime = DateTime.now();
    final prefs = await _prefs;
    await prefs.setInt(_keyLastPrompt, _lastPromptTime!.millisecondsSinceEpoch);
  }

  static Future<void> _logEvent(String name, Map<String, dynamic> params) async {
    try {
      await _analytics.logEvent(name: name, parameters: params);
    } catch (e) {
      if (kDebugMode) print('Analytics error: $e');
    }
  }
}
