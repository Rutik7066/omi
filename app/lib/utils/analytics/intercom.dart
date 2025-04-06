import 'dart:async';

import 'package:omi/backend/preferences.dart';
import 'package:omi/env/env.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:omi/utils/execution_gaurd.dart';

class IntercomManager {
  static final IntercomManager _instance = IntercomManager._internal();
  static IntercomManager get instance => _instance;
  static final SharedPreferencesUtil _preferences = SharedPreferencesUtil();

  IntercomManager._internal();

  Intercom get intercom => Intercom.instance;

  factory IntercomManager() {
    return _instance;
  }

  Future<void> initIntercom() async {
    if (ExecutionGuard.isWeb) return;
    if (Env.intercomAppId == null) return;
    await intercom.initialize(
      Env.intercomAppId!,
      iosApiKey: Env.intercomIOSApiKey,
      androidApiKey: Env.intercomAndroidApiKey,
    );
  }

  Future displayChargingArticle(String device) async {
    if (ExecutionGuard.isWeb) return;
    if (device == 'Omi DevKit 2') {
      return await intercom.displayArticle('10003257-how-to-charge-devkit2');
    } else {
      return await intercom.displayArticle('9907475-how-to-charge-the-device');
    }
  }

  Future displayEarnMoneyArticle() async {
    if (!ExecutionGuard.isWeb) return;
    return await intercom.displayArticle('10401566-build-publish-and-earn-with-omi-apps');
  }

  Future displayFirmwareUpdateArticle() async {
    if (!ExecutionGuard.isWeb) return;
    return await intercom.displayArticle('9995941-updating-your-devkit2-firmware');
  }

  Future logEvent(String eventName, {Map<String, dynamic>? metaData}) async {
    if (!ExecutionGuard.isWeb) return;
    return await intercom.logEvent(eventName, metaData);
  }

  Future updateCustomAttributes(Map<String, dynamic> attributes) async {
    if (!ExecutionGuard.isWeb) return;
    return await intercom.updateUser(customAttributes: attributes);
  }

  Future updateUser(String? email, String? name, String? uid) async {
    if (ExecutionGuard.isWeb) return;
    return await intercom.updateUser(
      email: email,
      name: name,
      userId: uid,
    );
  }

  Future<void> setUserAttributes() async {
    if (ExecutionGuard.isWeb) return;
    await updateCustomAttributes({
      'Notifications Enabled': _preferences.notificationsEnabled,
      'Location Enabled': _preferences.locationEnabled,
      'Apps Enabled Count': _preferences.enabledAppsCount,
      'Apps Integrations Enabled Count': _preferences.enabledAppsIntegrationsCount,
      'Speaker Profile': _preferences.hasSpeakerProfile,
      'Calendar Enabled': _preferences.calendarEnabled,
      'Primary Language': _preferences.userPrimaryLanguage,
      'Authorized Storing Recordings': _preferences.permissionStoreRecordingsEnabled,
    });
  }

  Future<void> loginUnidentifiedUser() async {
    if (ExecutionGuard.isWeb) return;
    return await instance.loginUnidentifiedUser();
  }

  Future<void> loginIdentifiedUser({String? userId, String? email, IntercomStatusCallback? statusCallback}) async {
    if (ExecutionGuard.isWeb) return;
    return await intercom.loginIdentifiedUser(email: email, statusCallback: statusCallback, userId: userId);
  }
}
