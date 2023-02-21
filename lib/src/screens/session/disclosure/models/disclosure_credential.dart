import 'package:equatable/equatable.dart';

import '../../../../models/attribute.dart';
import '../../../../models/credentials.dart';

/// Abstract class that contains the overlapping behaviour of ChoosableDisclosureCredential and TemplateDisclosureCredential.
abstract class DisclosureCredential extends CredentialView with EquatableMixin {
  DisclosureCredential({
    required CredentialInfo info,
    required Iterable<Attribute> attributes,
    bool expired = false,
    bool revoked = false,
  }) : super(info: info, expired: expired, revoked: revoked, attributes: attributes);

  @override
  List<Object?> get props => [
        {for (final attr in attributes) attr.attributeType.fullId: attr.value.raw}
      ];
}
