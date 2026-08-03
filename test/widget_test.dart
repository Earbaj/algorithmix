import 'package:flutter_test/flutter_test.dart';
import 'package:algorithmix/main.dart';

void main() {
  testWidgets('Algorithmix app renders splash screen title', (WidgetTester tester) async {
    await tester.pumpWidget(const AlgorithmixApp());

    // Verify Algorithmix title appears on splash screen
    expect(find.text('Algorithmix'), findsOneWidget);
  });
}
