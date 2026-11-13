import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasks/main.dart';

void main() {
  testWidgets('CloudProductExplorerApp renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const CloudProductExplorerApp());

    expect(find.text('Cloud Product Explorer'), findsOneWidget);
  });
}
