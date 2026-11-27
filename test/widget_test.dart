import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wanderly/main.dart';

void main() {
  setUp(() => repository.reset());

  testWidgets('Explore screen renders the catalogue', (tester) async {
    await tester.pumpWidget(const WanderlyApp());

    expect(find.text('Wanderly'), findsOneWidget);
    expect(find.byType(GridView), findsOneWidget);
    expect(find.text('Bali'), findsOneWidget);
    expect(find.text('Kyoto'), findsOneWidget);
  });

  testWidgets('search filters the catalogue by name', (tester) async {
    await tester.pumpWidget(const WanderlyApp());

    await tester.enterText(find.byType(TextField), 'kyoto');
    await tester.pump();

    expect(find.text('Kyoto'), findsOneWidget);
    expect(find.text('Bali'), findsNothing);
  });

  testWidgets('single tap opens the detail screen', (tester) async {
    await tester.pumpWidget(const WanderlyApp());

    await tester.tap(find.text('Banff'));
    // The card also registers onDoubleTap, so a single tap is held for the
    // double-tap timeout before onTap fires; allow a second settle for the
    // route transition.
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();

    expect(find.text('Open in Maps'), findsOneWidget);
  });
}
