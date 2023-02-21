import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:irmamobile/src/screens/data/credentials_detail_screen.dart';
import 'package:irmamobile/src/screens/session/widgets/issuance_success_screen.dart';
import 'package:irmamobile/src/widgets/credential_card/irma_credential_card.dart';

import 'helpers/helpers.dart';
import 'helpers/issuance_helpers.dart';
import 'irma_binding.dart';
import 'util.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final irmaBinding = IntegrationTestIrmaBinding.ensureInitialized();
  WidgetController.hitTestWarningShouldBeFatal = true;

  group('issuance', () {
    // Initialize the app's repository for integration tests (enable developer mode, etc.)
    setUp(() => irmaBinding.setUp());
    tearDown(() => irmaBinding.tearDown());

    Future<void> testIssueMunicipality(
      WidgetTester tester,
      Locale locale,
    ) async {
      await pumpAndUnlockApp(
        tester,
        irmaBinding.repository,
        locale,
      );

      await issueMunicipalityPersonalData(
        tester,
        irmaBinding,
        locale: locale,
      );
      await tester.pumpAndSettle();

      expect(find.byType(IssuanceSuccessScreen), findsOneWidget);
      await tester.tapAndSettle(find.text('OK'));

      // Go to data tab
      await tester.tapAndSettle(find.byKey(const Key('nav_button_data')));

      // Expect CredentialTypeTile and tap it
      var categoryTileFinder = find.byKey(const Key('irma-demo.gemeente.personalData_tile')).hitTestable();
      await tester.scrollUntilVisible(categoryTileFinder, 75);
      await tester.tapAndSettle(categoryTileFinder);

      // Expect detail page
      expect(find.byType(CredentialsDetailScreen), findsOneWidget);

      // Expect to find a card
      final credentialCardFinder = find.byType(IrmaCredentialCard);
      expect(credentialCardFinder, findsOneWidget);
    }

    testWidgets(
      'issue-municipality-en',
      (tester) => testIssueMunicipality(tester, const Locale('en', 'EN')),
    );

    testWidgets(
      'issue-municipality-nl',
      (tester) => testIssueMunicipality(tester, const Locale('nl', 'NL')),
    );
  });
}
