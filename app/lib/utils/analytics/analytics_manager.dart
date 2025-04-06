import 'package:omi/utils/analytics/intercom.dart';
import 'package:omi/utils/analytics/mixpanel.dart';
import 'package:omi/utils/execution_gaurd.dart';

class AnalyticsManager {
  static final AnalyticsManager _instance = AnalyticsManager._internal();

  factory AnalyticsManager() {
    return _instance;
  }

  AnalyticsManager._internal();

  void setUserAttributes() {
    MixpanelManager().setPeopleValues();
    if (!ExecutionGuard.isWeb) IntercomManager.instance.setUserAttributes();
  }

  void setUserAttribute(String key, dynamic value) {
    MixpanelManager().setUserProperty(key, value);
    if (!ExecutionGuard.isWeb) IntercomManager.instance.updateCustomAttributes({key: value});
  }
}
