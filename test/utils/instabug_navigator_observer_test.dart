import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/generated/instabug.api.g.dart';
import 'package:instabug_flutter/src/utils/screen_loading/screen_loading_manager.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'instabug_navigator_observer_test.mocks.dart';

@GenerateMocks([
  InstabugHostApi,
  ScreenLoadingManager,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  final mHost = MockInstabugHostApi();
  final mScreenLoadingManager = MockScreenLoadingManager();

  late InstabugNavigatorObserver observer;
  const screen = '/screen';
  const previousScreen = '/previousScreen';
  late Route route;
  late Route previousRoute;

  setUpAll(() {
    Instabug.$setHostApi(mHost);
    ScreenLoadingManager.setInstance(mScreenLoadingManager);
  });

  setUp(() {
    observer = InstabugNavigatorObserver();
    route = createRoute(screen);
    previousRoute = createRoute(previousScreen);
  });

  test('should report screen change when a route is pushed', () {
    fakeAsync((async) {
      observer.didPush(route, previousRoute);

      async.elapse(const Duration(milliseconds: 1000));

      verify(
        mScreenLoadingManager.startUiTrace(screen),
      ).called(1);

      verify(
        mHost.reportScreenChange(screen),
      ).called(1);
    });
  });

  test(
      'should report screen change when a route is popped and previous is known',
      () {
    fakeAsync((async) {
      observer.didPop(route, previousRoute);

      async.elapse(const Duration(milliseconds: 1000));

      verify(
        mScreenLoadingManager.startUiTrace(previousScreen),
      ).called(1);

      verify(
        mHost.reportScreenChange(previousScreen),
      ).called(1);
    });
  });

  test(
      'should not report screen change when a route is popped and previous is not known',
      () {
    fakeAsync((async) {
      observer.didPop(route, null);

      async.elapse(const Duration(milliseconds: 1000));

      verifyNever(
        mScreenLoadingManager.startUiTrace(any),
      );

      verifyNever(
        mHost.reportScreenChange(any),
      );
    });
  });
}

Route createRoute(String? name) {
  return MaterialPageRoute(
    builder: (_) => Container(),
    settings: RouteSettings(name: name),
  );
}
