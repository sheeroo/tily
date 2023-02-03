import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '/config/configuration.dart';
import 'features/core/presentation/app_widget.dart';
import 'firebase_options.dart';

void main() => Main();

class Main extends Env {
  @override
  FutureOr<HookConsumerWidget> onCreate() async {
    await Firebase.initializeApp(
      name: 'tily-app',
      options: DefaultFirebaseOptions.currentPlatform,
    );
    ErrorWidget.builder = (details) {
      Zone.current.handleUncaughtError(details.exception, details.stack!);
      return const ColoredBox(color: Colors.transparent);
    };

    return const AppWidget();
  }
}
