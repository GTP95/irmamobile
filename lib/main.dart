import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'src/data/irma_client_bridge.dart';
import 'src/data/irma_preferences.dart';
import 'src/data/irma_repository.dart';
import 'src/sentry/sentry.dart';
import 'src/util/security_context_binding.dart';
import 'src/widgets/irma_repository_provider.dart';

Future<void> main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    Zone.current.handleUncaughtError(details.exception, details.stack ?? StackTrace.empty);
  };

  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    final preferences = await IrmaPreferences.fromInstance();
    await initSentry(preferences: preferences);
    SecurityContextBinding.ensureInitialized();
    final repository = IrmaRepository(
      client: IrmaClientBridge(debugLogging: kDebugMode),
      preferences: preferences,
    );

    runApp(IrmaApp(repository: repository));
  }, (error, stackTrace) => reportError(error, stackTrace));
}

class IrmaApp extends StatelessWidget {
  final Locale? forcedLocale;
  final IrmaRepository repository;

  const IrmaApp({Key? key, this.forcedLocale, required this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) => IrmaRepositoryProvider(
        repository: repository,
        child: App(
          irmaRepository: repository,
          forcedLocale: forcedLocale,
        ),
      );
}
