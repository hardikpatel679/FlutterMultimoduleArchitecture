import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/viewmodels/locale_viewmodel.dart';

void main() {
  group('LocaleViewModel', () {
    test('initial locale should be en', () {
      final viewModel = LocaleViewModel();
      expect(viewModel.locale.languageCode, 'en');
    });

    test('toggleLocale should switch between en and ar', () {
      final viewModel = LocaleViewModel();
      
      // Toggle to ar
      viewModel.toggleLocale();
      expect(viewModel.locale.languageCode, 'ar');
      
      // Toggle back to en
      viewModel.toggleLocale();
      expect(viewModel.locale.languageCode, 'en');
    });
  });
}
