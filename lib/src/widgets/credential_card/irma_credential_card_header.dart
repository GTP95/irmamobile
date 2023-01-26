import 'package:flutter/material.dart';

import '../../theme/theme.dart';
import '../translated_text.dart';
import 'irma_credential_avatar.dart';

class IrmaCredentialCardHeader extends StatelessWidget {
  final String credentialName;
  final String? logo;
  final String? issuerName;
  final Widget? trailing;
  final bool isExpired;
  final bool isExpiringSoon;
  final bool isRevoked;

  const IrmaCredentialCardHeader({
    required this.credentialName,
    this.logo,
    this.issuerName,
    this.trailing,
    this.isExpiringSoon = false,
    this.isExpired = false,
    this.isRevoked = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = IrmaTheme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IrmaCredentialAvatar(logo: logo),
        SizedBox(width: theme.tinySpacing + theme.smallSpacing),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isRevoked)
                TranslatedText(
                  'credential.revoked',
                  style: theme.themeData.textTheme.headline4!.copyWith(
                    color: theme.error,
                  ),
                )
              else if (isExpired)
                TranslatedText(
                  'credential.expired',
                  style: theme.themeData.textTheme.headline4!.copyWith(
                    color: theme.error,
                  ),
                )
              else if (isExpiringSoon)
                TranslatedText(
                  'credential.about_to_expire',
                  style: theme.themeData.textTheme.headline4!.copyWith(
                    color: theme.warning,
                  ),
                ),
              Text(
                credentialName,
                style: theme.themeData.textTheme.headline4!.copyWith(color: theme.dark),
              ),
              if (issuerName != null)
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: theme.smallSpacing,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TranslatedText(
                        'credential.issued_by',
                        style: theme.themeData.textTheme.bodyText2,
                      ),
                      Text(
                        issuerName!,
                        style: theme.themeData.textTheme.bodyText1,
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
        if (trailing != null && !isExpired && !isRevoked) ...[
          SizedBox(width: theme.smallSpacing),
          trailing!,
        ],
      ],
    );
  }
}
