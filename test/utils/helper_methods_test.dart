import 'package:flutter_challenge/utils/helper_methods.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Capatilization of Text', (WidgetTester tester) async {
    String text = 'hey there!';

    String capText = HelperMethods().capitalize(text);

    expect(capText, 'Hey there!');
  });
}
