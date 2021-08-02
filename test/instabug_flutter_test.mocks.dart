// Mocks generated by Mockito 5.0.10 from annotations
// in instabug_flutter/example/ios/.symlinks/plugins/instabug_flutter/test/instabug_flutter_test.dart.
// Do not manually edit this file.

import 'package:instabug_flutter/utils/platform_manager.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: comment_references
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

/// A class which mocks [PlatformManager].
///
/// See the documentation for Mockito's code generation for more information.
class MockPlatformManager extends _i1.Mock implements _i2.PlatformManager {
  MockPlatformManager() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool isAndroid() =>
      (super.noSuchMethod(Invocation.method(#isAndroid, []), returnValue: false)
          as bool);
  @override
  bool isIOS() =>
      (super.noSuchMethod(Invocation.method(#isIOS, []), returnValue: false)
          as bool);
}