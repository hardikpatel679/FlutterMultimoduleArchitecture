import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/viewmodels/base_stream_view_model.dart';

class MockStreamViewModel extends BaseStreamViewModel<int> {
  final Stream<int> stream;
  MockStreamViewModel(this.stream);

  @override
  Stream<int> getStream() => stream;
}

void main() {
  group('BaseStreamViewModel', () {
    late StreamController<int> controller;
    late MockStreamViewModel viewModel;

    setUp(() {
      controller = StreamController<int>();
      viewModel = MockStreamViewModel(controller.stream);
    });

    tearDown(() {
      controller.close();
      viewModel.dispose();
    });

    test('connect should update data when stream emits', () async {
      viewModel.connect();
      expect(viewModel.isLoading, true);

      controller.add(10);
      await Future.delayed(Duration.zero);

      expect(viewModel.data, 10);
      expect(viewModel.isLoading, false);
      expect(viewModel.error, null);
    });

    test('connect should update error when stream emits error', () async {
      viewModel.connect();
      
      controller.addError('Stream Error');
      await Future.delayed(Duration.zero);

      expect(viewModel.error, 'Stream Error');
      expect(viewModel.isLoading, false);
    });

    test('disconnect should cancel subscription', () async {
      viewModel.connect();
      viewModel.disconnect();

      expect(viewModel.isLoading, false);
      
      controller.add(20);
      await Future.delayed(Duration.zero);
      expect(viewModel.data, null); // Should not have updated
    });

    test('onDone should set isLoading to false', () async {
      viewModel.connect();
      await controller.close();
      await Future.delayed(Duration.zero);

      expect(viewModel.isLoading, false);
    });
  });
}
