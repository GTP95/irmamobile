import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../../../../models/return_url.dart';
import '../../../../models/session.dart';
import '../../../../theme/theme.dart';
import '../../../../util/con_dis_con.dart';
import '../../../../widgets/credential_card/irma_credential_card.dart';
import '../../../../widgets/irma_action_card.dart';
import '../../../../widgets/irma_bottom_bar.dart';
import '../../../../widgets/irma_icon_button.dart';
import '../../../../widgets/irma_quote.dart';
import '../../../../widgets/issuer_verifier_header.dart';
import '../../../../widgets/translated_text.dart';
import '../../widgets/session_scaffold.dart';
import '../bloc/disclosure_permission_event.dart';
import '../bloc/disclosure_permission_state.dart';
import '../models/choosable_disclosure_credential.dart';
import 'disclosure_permission_progress_indicator.dart';
import 'disclosure_permission_share_dialog.dart';

class DisclosurePermissionChoicesScreen extends StatelessWidget {
  final RequestorInfo requestor;
  final DisclosurePermissionChoices state;
  final Function(DisclosurePermissionBlocEvent) onEvent;
  final Function() onDismiss;
  final ReturnURL? returnURL;

  const DisclosurePermissionChoicesScreen({
    required this.requestor,
    required this.state,
    required this.onEvent,
    required this.onDismiss,
    this.returnURL,
  });

  Future<void> _showConfirmationDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => DisclosurePermissionConfirmDialog(requestor: requestor),
        ) ??
        false;

    onEvent(confirmed ? DisclosurePermissionNextPressed() : DisclosurePermissionDialogDismissed());
  }

  Widget _buildChoiceEntry(
    BuildContext context,
    MapEntry<int, Con<ChoosableDisclosureCredential>> choiceEntry,
    bool isOptional,
  ) {
    final theme = IrmaTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                onEvent(
                  DisclosurePermissionChangeChoicePressed(
                    disconIndex: choiceEntry.key,
                  ),
                );
                Feedback.forTap(context);
              },
              child: TranslatedText(
                'disclosure_permission.change_choice',
                style: theme.hyperlinkTextStyle,
              ),
            )
          ],
        ),
        SizedBox(height: theme.smallSpacing),
        for (int i = 0; i < choiceEntry.value.length; i++)
          IrmaCredentialCard(
            credentialView: choiceEntry.value[i],
            hideFooter: true,
            padding: EdgeInsets.symmetric(horizontal: theme.tinySpacing),
            headerTrailing: isOptional && i == 0
                ? IrmaIconButton(
                    icon: Icons.close,
                    size: 12,
                    onTap: () => onEvent(DisclosurePermissionRemoveOptionalDataPressed(disconIndex: choiceEntry.key)))
                : null,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = this.state;
    final theme = IrmaTheme.of(context);
    final lang = FlutterI18n.currentLocale(context)!.languageCode;

    if (state is DisclosurePermissionChoicesOverview && state.showConfirmationPopup) {
      Future.delayed(Duration.zero, () => _showConfirmationDialog(context));
    }

    String contentTranslationKey;
    Map<String, String>? contentTranslationsParams;

    if (state is DisclosurePermissionPreviouslyAddedCredentialsOverview) {
      contentTranslationKey = 'disclosure_permission.previously_added.explanation';
    } else if (returnURL != null && returnURL!.isPhoneNumber) {
      contentTranslationKey = 'disclosure_permission.call.disclosure_explanation';
      contentTranslationsParams = {
        'otherParty': requestor.name.translate(lang),
        'phoneNumber': returnURL!.phoneNumber,
      };
    } else {
      contentTranslationKey = 'disclosure_permission.overview.explanation';
      contentTranslationsParams = {
        'requestorName': requestor.name.translate(lang),
      };
    }

    return SessionScaffold(
      appBarTitle: state is DisclosurePermissionPreviouslyAddedCredentialsOverview
          ? 'disclosure_permission.previously_added.title'
          : 'disclosure_permission.overview.title',
      onDismiss: onDismiss,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(theme.defaultSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IssuerVerifierHeader(title: requestor.name.translate(lang)),
            DisclosurePermissionProgressIndicator(
              step: state.currentStepIndex + 1,
              stepCount: state.plannedSteps.length,
              contentTranslationKey: contentTranslationKey,
              contentTranslationParams: contentTranslationsParams,
            ),
            SizedBox(height: theme.defaultSpacing),
            if (state is DisclosurePermissionChoicesOverview && state.isSignatureSession) ...[
              TranslatedText(
                'disclosure_permission.overview.sign',
                style: theme.themeData.textTheme.headline4,
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: theme.smallSpacing,
                  bottom: theme.defaultSpacing,
                ),
                child: IrmaQuote(
                  key: const Key('signature_message'),
                  quote: state.signedMessage,
                ),
              ),
            ],
            TranslatedText(
              state is DisclosurePermissionPreviouslyAddedCredentialsOverview
                  ? 'disclosure_permission.previously_added.header'
                  : 'disclosure_permission.overview.header',
              style: theme.themeData.textTheme.headline4,
            ),
            SizedBox(height: theme.smallSpacing),
            ...state.requiredChoices.entries.map((choiceEntry) => _buildChoiceEntry(context, choiceEntry, false)),
            if (state.optionalChoices.isNotEmpty) ...[
              TranslatedText('disclosure_permission.optional_data', style: theme.themeData.textTheme.headline4),
              ...state.optionalChoices.entries.map((choiceEntry) => _buildChoiceEntry(context, choiceEntry, true)),
            ],
            if (state.requiredChoices.isEmpty && state.optionalChoices.isEmpty)
              TranslatedText('disclosure_permission.no_data_selected', style: theme.textTheme.caption),
            if (state.hasAdditionalOptionalChoices) ...[
              SizedBox(height: theme.defaultSpacing),
              IrmaActionCard(
                titleKey: 'disclosure_permission.add_optional_data',
                onTap: () => onEvent(DisclosurePermissionAddOptionalDataPressed()),
                icon: Icons.add_circle_outline,
                color: theme.textTheme.headline1?.color ?? Colors.black,
                invertColors: true,
                style: theme.textTheme.button,
                centerText: true,
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: IrmaBottomBar(
        primaryButtonLabel: state is DisclosurePermissionPreviouslyAddedCredentialsOverview
            ? 'disclosure_permission.next_step'
            : 'disclosure_permission.overview.confirm',
        onPrimaryPressed: state.choicesValid ? () => onEvent(DisclosurePermissionNextPressed()) : null,
      ),
    );
  }
}
