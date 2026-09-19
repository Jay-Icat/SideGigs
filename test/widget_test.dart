import 'package:flutter_test/flutter_test.dart';
import 'package:side_gigs/main.dart';

void main() {
  testWidgets('SideGigs app loads successfully smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SideGigsApp());
    expect(find.text('SideGigs'), findsOneWidget);
  });
}
