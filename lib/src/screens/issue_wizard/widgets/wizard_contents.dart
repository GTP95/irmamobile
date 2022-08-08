import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../models/issue_wizard.dart';
import '../../../screens/issue_wizard/issue_wizard.dart';
import '../../../theme/theme.dart';
import '../../../widgets/irma_bottom_bar.dart';
import '../../../widgets/irma_markdown.dart';
import '../../../widgets/irma_progress_indicator.dart';
import 'wizard_card_stepper.dart';
import 'wizard_scaffold.dart';

class IssueWizardContents extends StatelessWidget {
  final GlobalKey scrollviewKey;
  final ScrollController controller;
  final IssueWizardEvent wizard;
  final Image logo;
  final void Function() onBack;
  final void Function(BuildContext context, IssueWizardEvent wizard) onNext;
  final void Function(VisibilityInfo visibility, IssueWizardEvent wizard) onVisibilityChanged;

  const IssueWizardContents({
    required this.scrollviewKey,
    required this.controller,
    required this.wizard,
    required this.logo,
    required this.onBack,
    required this.onNext,
    required this.onVisibilityChanged,
  });

  Widget _buildWizard(BuildContext context, String lang, IssueWizardEvent wizard) {
    final intro = wizard.wizardData.intro;
    final theme = IrmaTheme.of(context);
    return VisibilityDetector(
      key: const Key('wizard_key'),
      onVisibilityChanged: (v) => onVisibilityChanged(v, wizard),
      child: Padding(
        padding: EdgeInsets.only(left: theme.defaultSpacing, right: theme.defaultSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (intro.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: theme.defaultSpacing),
                child: IrmaMarkdown(intro.translate(lang)),
              ),
            WizardCardStepper(data: wizard.wizardContents, completed: wizard.completed),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = IrmaTheme.of(context);
    final lang = FlutterI18n.currentLocale(context)!.languageCode;
    final activeItem = wizard.activeItem;
    final buttonLabel = wizard.completed
        ? FlutterI18n.translate(context, 'issue_wizard.done')
        : activeItem?.label.translate(lang,
            fallback: FlutterI18n.translate(
              context,
              'issue_wizard.add_credential',
              translationParams: {
                'credential': activeItem.header.translate(lang),
              },
            ));
    final wizardContentSize = wizard.wizardContents.length;
    final indicator = Padding(
      padding: EdgeInsets.only(top: 4, bottom: 32, left: theme.defaultSpacing, right: theme.defaultSpacing),
      child: IrmaProgressIndicator(
        step: wizard.completed ? wizard.wizardContents.length : wizard.activeItemIndex,
        stepCount: wizardContentSize,
      ),
    );

    return WizardScaffold(
      scrollviewKey: scrollviewKey,
      controller: controller,
      header: wizard.wizardData.title.translate(lang),
      image: logo,
      backgroundColor: IssueWizardScreen.defaultBackgroundColor,
      textColor: IssueWizardScreen.defaultTextColor,
      onBack: onBack,
      bottomBar: IrmaBottomBar(
        primaryButtonLabel: buttonLabel,
        onPrimaryPressed: () => onNext(context, wizard),
        alignment: IrmaBottomBarAlignment.horizontal,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (wizardContentSize > 1) indicator,
          _buildWizard(context, lang, wizard),
        ],
      ),
    );
  }
}
