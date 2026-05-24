import 'package:flutter_test/flutter_test.dart';
import 'package:makena/main.dart';

void main() {
  testWidgets('App loads onboarding screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MakenaApp());
    expect(find.text('Discover Your Shape'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });
}
