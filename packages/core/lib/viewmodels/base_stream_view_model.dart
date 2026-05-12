import 'dart:async';
import 'package:flutter/material.dart';

/// Base class for ViewModels that handle Streaming data (e.g., GraphQL Subscriptions/WebSockets).
abstract class BaseStreamViewModel<T> extends ChangeNotifier {
  T? _data;
  T? get data => _data;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  StreamSubscription<T>? _subscription;

  /// Returns the stream to listen to.
  /// Subclasses MUST implement this to provide the WebSocket/GraphQL stream.
  Stream<T> getStream();

  /// Starts the connection and listens to the stream.
  void connect() {
    if (_subscription != null) return; // Already connected

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _subscription = getStream().listen(
        (data) {
          _data = data;
          _isLoading = false;
          _error = null;
          notifyListeners();
        },
        onError: (err) {
          _error = err.toString();
          _isLoading = false;
          notifyListeners();
        },
        onDone: () {
          _isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Closes the connection and cancels the subscription.
  void disconnect() {
    _subscription?.cancel();
    _subscription = null;
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}
