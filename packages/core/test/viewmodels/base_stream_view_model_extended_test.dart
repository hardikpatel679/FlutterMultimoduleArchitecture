import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/viewmodels/base_stream_view_model.dart';

class TestStreamViewModel extends BaseStreamViewModel<String> {
  final StreamController<String> _controller = StreamController<String>();
  
  @override
  Stream<String> getStream() => _controller.stream;

  void emit(String val) => _controller.add(val);
  void emitError(Object err) => _controller.addError(err);
  void close() => _controller.close();
}

void main() {
  group('BaseStreamViewModel Extended', () {
    late TestStreamViewModel viewModel;

    setUp(() {
      viewModel = TestStreamViewModel();
    });

    test('should handle multiple emits', () async {
      viewModel.connect();
      
      viewModel.emit('A');
      await Future.delayed(Duration.zero);
      expect(viewModel.data, 'A');

      viewModel.emit('B');
      await Future.delayed(Duration.zero);
      expect(viewModel.data, 'B');
    });

    test('should not connect if already connected', () {
      viewModel.connect();
      final sub1 = viewModel.isLoading; // true
      
      viewModel.connect(); // Should return early
      expect(viewModel.isLoading, sub1);
    });

    test('should handle exception during listen', () {
      // Create a broken stream
      final vm = BrokenStreamViewModel();
      vm.connect();
      expect(vm.error, contains('Broken Stream'));
    });
  });
}

class BrokenStreamViewModel extends BaseStreamViewModel<int> {
  @override
  Stream<int> getStream() {
    throw Exception('Broken Stream');
  }
}