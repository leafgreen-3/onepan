import 'dart:async';

import 'package:flutter/foundation.dart';

/// A simple [Listenable] that notifies listeners whenever the provided
/// [Stream] emits an event. Useful for wiring provider/notifier changes into
/// `GoRouter.refreshListenable` without coupling to UI frameworks.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

