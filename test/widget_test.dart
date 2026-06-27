import 'package:flutter_test/flutter_test.dart';
import 'package:welltion_app/main.dart';

void main() {
  testWidgets('WelltionApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const WelltionApp());
    await tester.pumpAndSettle();
    expect(find.text('01 Home'), findsOneWidget);
  });
}
