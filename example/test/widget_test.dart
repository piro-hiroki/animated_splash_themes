import 'package:flutter_test/flutter_test.dart';
import 'package:animated_splash_themes_example/main.dart';

void main() {
  testWidgets('ExampleApp smoke test', (tester) async {
    await tester.pumpWidget(const ExampleApp());
    expect(find.byType(ExampleApp), findsOneWidget);
  });
}
