import 'package:instabug_flutter/src/generated/instabug.api.g.dart';
import 'package:instabug_flutter/src/models/w3c_feature_flags.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';
import 'package:meta/meta.dart';

typedef OnW3CFeatureFlagChange = void Function(
  bool isW3cExternalTraceIDEnabled,
  bool isW3cExternalGeneratedHeaderEnabled,
  bool isW3cCaughtHeaderEnabled,
);

class FeatureFlagsManager implements FeatureFlagsFlutterApi {
  // Access the singleton instance
  factory FeatureFlagsManager() {
    return _instance;
  }
  // Private constructor to prevent instantiation from outside the class
  FeatureFlagsManager._();

  // Singleton instance
  static final FeatureFlagsManager _instance = FeatureFlagsManager._();

  // Host API instance
  static InstabugHostApi _host = InstabugHostApi();

  /// @nodoc
  @visibleForTesting
  // Setter for the host API
  // ignore: use_setters_to_change_properties
  void $setHostApi(InstabugHostApi host) {
    _host = host;
  }

  @visibleForTesting
  // Setter for the FeatureFlagsManager
  void setFeatureFlagsManager(FeatureFlagsManager featureFlagsManager) {
    // This can be used for testing, but should be avoided in production
    // since it breaks the singleton pattern
  }

  // Internal state flags
  bool _isAndroidW3CExternalTraceID = false;
  bool _isAndroidW3CExternalGeneratedHeader = false;
  bool _isAndroidW3CCaughtHeader = false;

  Future<W3cFeatureFlags> getW3CFeatureFlagsHeader() async {
    if (IBGBuildInfo.instance.isAndroid) {
      return Future.value(
        W3cFeatureFlags(
          isW3cCaughtHeaderEnabled: _isAndroidW3CCaughtHeader,
          isW3cExternalGeneratedHeaderEnabled:
              _isAndroidW3CExternalGeneratedHeader,
          isW3cExternalTraceIDEnabled: _isAndroidW3CExternalTraceID,
        ),
      );
    }
    final flags = await _host.isW3CFeatureFlagsEnabled();
    return W3cFeatureFlags(
      isW3cCaughtHeaderEnabled: flags['isW3cCaughtHeaderEnabled'] ?? false,
      isW3cExternalGeneratedHeaderEnabled:
          flags['isW3cExternalGeneratedHeaderEnabled'] ?? false,
      isW3cExternalTraceIDEnabled:
          flags['isW3cExternalTraceIDEnabled'] ?? false,
    );
  }

  Future<void> registerW3CFlagsListener() async {
    FeatureFlagsFlutterApi.setup(this); // Use 'this' instead of _instance

    final featureFlags = await _host.isW3CFeatureFlagsEnabled();
    _isAndroidW3CCaughtHeader =
        featureFlags['isW3cCaughtHeaderEnabled'] ?? false;
    _isAndroidW3CExternalTraceID =
        featureFlags['isW3cExternalTraceIDEnabled'] ?? false;
    _isAndroidW3CExternalGeneratedHeader =
        featureFlags['isW3cExternalGeneratedHeaderEnabled'] ?? false;

    return _host.registerFeatureFlagChangeListener();
  }

  @override
  @internal
  void onW3CFeatureFlagChange(
    bool isW3cExternalTraceIDEnabled,
    bool isW3cExternalGeneratedHeaderEnabled,
    bool isW3cCaughtHeaderEnabled,
  ) {
    _isAndroidW3CCaughtHeader = isW3cCaughtHeaderEnabled;
    _isAndroidW3CExternalTraceID = isW3cExternalTraceIDEnabled;
    _isAndroidW3CExternalGeneratedHeader = isW3cExternalGeneratedHeaderEnabled;
  }
}
