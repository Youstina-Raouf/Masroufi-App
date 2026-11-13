import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:masroufi/main.dart';
import 'package:masroufi/models/expense_item.dart';

// Portrait screen of 600 x 1200 logical pixels. The default test font is wider
// than the real app font, so a slightly wider screen avoids false overflows.
void usePhonePortrait(WidgetTester tester) {
  tester.view.physicalSize = const Size(1200, 2400);
  tester.view.devicePixelRatio = 2.0;
  addTearDown(tester.view.reset);
}

void main() {
  test('ExpenseItem.toMap stores the fields and an ISO date string', () {
    final date = DateTime(2026, 11, 13, 9, 30);
    final item = ExpenseItem(id: 7, title: 'Coffee', price: 45.5, date: date);

    final map = item.toMap();

    expect(map['id'], 7);
    expect(map['title'], 'Coffee');
    expect(map['price'], 45.5);
    expect(map['date'], date.toIso8601String());
  });

  testWidgets('Home screen shows the title, EGP total and empty state',
      (WidgetTester tester) async {
    usePhonePortrait(tester);
    await tester.pumpWidget(const MasroufiApp());
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Masroufi'), findsOneWidget);
    expect(find.text('Total Expenses:'), findsOneWidget);
    expect(find.text('EGP 0.00'), findsOneWidget);
    expect(find.text('No expenses yet'), findsOneWidget);
  });

  testWidgets('Add Expense button opens the form',
      (WidgetTester tester) async {
    usePhonePortrait(tester);
    await tester.pumpWidget(const MasroufiApp());
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.text('Add Expense'));
    await tester.pumpAndSettle();

    expect(find.text('Add New Expense'), findsOneWidget);
    expect(find.text('Expense Title'), findsOneWidget);
    expect(find.text('Amount in EGP'), findsOneWidget);
  });

  testWidgets('Submitting an empty form shows validation messages',
      (WidgetTester tester) async {
    usePhonePortrait(tester);
    await tester.pumpWidget(const MasroufiApp());
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.text('Add Expense'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add Expense'));
    await tester.pump();

    expect(find.text('Please enter an expense title'), findsOneWidget);
    expect(find.text('Please enter an amount'), findsOneWidget);
  });

  testWidgets('A non-numeric amount is rejected',
      (WidgetTester tester) async {
    usePhonePortrait(tester);
    await tester.pumpWidget(const MasroufiApp());
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.text('Add Expense'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Expense Title'), 'Tea');
    await tester.enterText(find.widgetWithText(TextFormField, 'Amount in EGP'), 'abc');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add Expense'));
    await tester.pump();

    expect(find.text('Please enter a valid number'), findsOneWidget);
  });
}
