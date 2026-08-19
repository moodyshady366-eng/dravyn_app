import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'update_localization.dart';

enum UpdateStatus { upToDate, available, required, noInternet, error }
enum UpdateChannel { stable, beta, alpha }

class UpdateConfig {
  final String latestVersion;
  final String minRequiredVersion;
  final bool forceUpdate;
  final String title;
  final String message;
  final String changelog;
  final String androidUrl;
  final String iosUrl;
  final int promptDelayHours;
  final int vipGiftDays;
  final UpdateChannel channel;
  final bool enableInAppUpdate;
  final double rolloutPercent;

  UpdateConfig({
    required this.latestVersion,
    required this.minRequiredVersion,
    required this.forceUpdate,
    required this.title,
    required this.message,
    required this.changelog,
    required this.androidUrl,
    required this.iosUrl,
    required this.promptDelayHours,
    required this.vipGiftDays,
    required this.channel,
    required this.enableInAppUpdate,
    required this.rolloutPercent,
  });

  factory UpdateConfig.fromRemoteConfig(FirebaseRemoteConfig config) {
    return UpdateConfig(
      latestVersion: config.getString('latest_version'),
      minRequiredVersion: config.getString('min_required_version'),
      forceUpdate: config.getBool('force_update'),
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
