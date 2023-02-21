import 'package:flutter_test/flutter_test.dart';
import 'package:irmamobile/src/screens/session/disclosure/widgets/disclosure_permission_introduction_screen.dart';
import 'package:irmamobile/src/screens/session/disclosure/widgets/disclosure_permission_share_dialog.dart';
import 'package:irmamobile/src/screens/session/session_screen.dart';
import 'package:irmamobile/src/screens/session/widgets/disclosure_feedback_screen.dart';
import 'package:irmamobile/src/widgets/irma_app_bar.dart';
import 'package:irmamobile/src/widgets/yivi_themed_button.dart';

import '../util.dart';

Future<void> evaluateIntroduction(WidgetTester tester) async {
  // Wait for the screen to appear
  await tester.waitFor(
    find.byType(DisclosurePermissionIntroductionScreen),
  );

  // Check the app bar
  final appBarTextFinder = find.descendant(
    of: find.byType(IrmaAppBar),
    matching: find.text('Get going'),
  );
  expect(appBarTextFinder, findsOneWidget);

  // Check the body text
  expect(find.text('Share your data'), findsOneWidget);
  expect(
    find.text('Collect the required data to be able to share it with requesting parties.'),
    findsOneWidget,
  );

  // Check and press the continue button
  final continueButtonFinder = find.descendant(
    of: find.byType(YiviThemedButton),
    matching: find.text('Get going'),
  );
  expect(continueButtonFinder, findsOneWidget);
  await tester.tapAndSettle(continueButtonFinder);
}

Future<void> evaluateFeedback(WidgetTester tester, [feedbackType = DisclosureFeedbackType.success]) async {
  // Expect the success screen
  final feedbackScreenFinder = find.byType(DisclosureFeedbackScreen);
  expect(feedbackScreenFinder, findsOneWidget);
  expect(
    (feedbackScreenFinder.evaluate().single.widget as DisclosureFeedbackScreen).feedbackType,
    feedbackType,
  );
  await tester.tapAndSettle(find.text('OK'));

  // Session flow should be over now
  expect(find.byType(SessionScreen), findsNothing);
}

Future<void> evaluateShareDialog(WidgetTester tester) async {
  expect(find.byType(DisclosurePermissionConfirmDialog), findsOneWidget);
  await tester.tapAndSettle(find.text('Share'));
}
