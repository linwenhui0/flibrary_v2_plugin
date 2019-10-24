import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_utils/util/locale/localizations.dart';
import 'package:flutter_utils/util/print.dart';
import 'package:stack_trace/stack_trace.dart';

class App extends StatelessWidget {
  final ThemeData theme;
  final Locale locale;
  final Widget home;
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;
  final Iterable<Locale> supportedLocales;
  final RouteFactory onGenerateRoute;

  const App({
    Key key,
    this.home,
    this.theme,
    this.locale,
    this.localizationsDelegates,
    this.supportedLocales,
    this.onGenerateRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<LocalizationsDelegate<dynamic>> delegates = List();
    if (localizationsDelegates != null) {
      for (LocalizationsDelegate<dynamic> localizationsDelegate
          in localizationsDelegates) {
        delegates.add(localizationsDelegate);
      }
    }
    delegates.add(ZHCupertinoLocalizations.delegate);
    delegates.add(GlobalMaterialLocalizations.delegate);
    delegates.add(GlobalWidgetsLocalizations.delegate);
    return MaterialApp(
      theme: theme,
      locale: locale,
      localizationsDelegates: delegates,
      supportedLocales: supportedLocales,
      home: home,
      onGenerateRoute: onGenerateRoute,
    );
  }
}

Future<void> reportCrash(dynamic error, StackTrace stackTrace,
    {bool forceCrash = false}) async {
  final data = {
    'message': error.toString(),
    'cause': stackTrace == null ? 'unknown' : _cause(stackTrace),
    'trace': stackTrace == null ? [] : _traces(stackTrace),
    'forceCrash': forceCrash
  };
  Print().printNative(data, level: Print.ASSERT);
}

void startApp(Widget app) {
  runZoned<Future<Null>>(() {
    try {
      runApp(app);
    } catch (e) {}
  }, onError: (error, stackTrace) async {
    await reportCrash(error, stackTrace, forceCrash: false);
  });
}

List<Map<String, dynamic>> _traces(StackTrace stack) =>
    Trace.from(stack).frames.map(_toTrace).toList(growable: false);

String _cause(StackTrace stack) => Trace.from(stack).frames.first.toString();

Map<String, dynamic> _toTrace(Frame frame) {
  final List<String> tokens = frame.member.split('.');

  return {
    'library': frame.library ?? 'unknown',
    'line': frame.line ?? 0,
    // Global function might have thrown the exception.
    // So in some cases the method is the first token
    'method': tokens.length == 1 ? tokens[0] : tokens.sublist(1).join('.'),
    // Global function might have thrown the exception.
    // So in some cases class does not exist
    'class': tokens.length == 1 ? null : tokens[0],
  };
}
