import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trailblazer_ai/main.dart';

void main() {
  testWidgets('Trailblazer app boots to landing', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: TrailblazerApp()));
    await tester.pump();
    expect(find.text('Trailblazer'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
