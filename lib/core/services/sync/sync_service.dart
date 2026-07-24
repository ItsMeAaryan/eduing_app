import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import '../firebase/firebase_service.dart';

enum SyncState { online, offline, syncing, error }

class SyncService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  final _syncStateController = StreamController<SyncState>.broadcast();
  Stream<SyncState> get syncStateStream => _syncStateController.stream;

  SyncState _currentState = SyncState.online;
  SyncState get currentState => _currentState;

  Future<void> initialize() async {
    // Initial check
    final results = await _connectivity.checkConnectivity();
    _updateState(results);

    // Listen to network changes
    _subscription = _connectivity.onConnectivityChanged.listen(_updateState);
  }

  void _updateState(List<ConnectivityResult> results) {
    final isOnline = !results.contains(ConnectivityResult.none);

    if (isOnline && _currentState == SyncState.offline) {
      _flushQueue();
    } else if (!isOnline) {
      _setState(SyncState.offline);
    } else {
      _setState(SyncState.online);
    }
  }

  void _setState(SyncState state) {
    if (_currentState != state) {
      _currentState = state;
      _syncStateController.add(state);
    }
  }

  Future<void> _flushQueue() async {
    _setState(SyncState.syncing);
    try {
      // Firebase Firestore handles offline queue automatically when network is restored.
      // We can await a network call to verify syncing is complete.
      await FirebaseService.firestore.enableNetwork();
      _setState(SyncState.online);
    } catch (e) {
      debugPrint('Sync Error: $e');
      _setState(SyncState.error);
    }
  }

  void dispose() {
    _subscription?.cancel();
    _syncStateController.close();
  }
}
