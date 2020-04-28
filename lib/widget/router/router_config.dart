import 'package:flibrary_plugin/widget/router/dialog_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utils/util/print.dart';

enum TransitionType { inFromTop, inFromBottom }

class RouterConfig {
  static RouterConfig _instance = RouterConfig._internal();

  NavigatorObserver _navigatorObserver;

  RouterConfig._internal();

  factory RouterConfig() {
    return _instance;
  }

  NavigatorObserver get navigatorObserver => _navigatorObserver;

  BuildContext get context => navigatorObserver.navigator.context;

  void initState() {
    _navigatorObserver = NavigatorObserver();
  }

  void dispose() {
    _navigatorObserver = null;
  }

  void navigatorByWidget(Widget child,
      {bool replace: false, bool clearStack: false, RoutePredicate predicate}) {
    if (clearStack == true) {
      _navigatorObserver.navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => child),
          predicate ??
              (Route<dynamic> route) {
                return route == null;
              });
    } else {
      if (replace == true) {
        _navigatorObserver.navigator
            .pushReplacement(MaterialPageRoute(builder: (context) => child));
      } else {
        _navigatorObserver.navigator
            .push(MaterialPageRoute(builder: (context) => child));
      }
    }
  }

  Future<T> showDialog<T>(
      {bool barrierDismissible = true,
      WidgetBuilder builder,
      Color barrierColor,
      RouteTransitionsBuilder transitionBuilder,
      Duration transitionDuration: const Duration(milliseconds: 150)}) {
    assert(builder != null);
    final ThemeData theme = Theme.of(context, shadowThemeOnly: true);
    return navigator(DialogRoute<T>(
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        final Widget pageChild = Builder(builder: builder);
        return SafeArea(
          child: Builder(builder: (BuildContext context) {
            return theme != null
                ? Theme(data: theme, child: pageChild)
                : pageChild;
          }),
        );
      },
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: barrierColor ?? Colors.black54,
      transitionDuration: transitionDuration,
      transitionBuilder: transitionBuilder ?? _buildMaterialDialogTransitions,
    ));
  }

  Widget _buildMaterialDialogTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }

  Future<dynamic> navigator(Route newRoute,
      {bool replace: false, bool clearStack: false, RoutePredicate predicate}) {
    if (clearStack == true) {
      return _navigatorObserver.navigator.pushAndRemoveUntil(
          newRoute,
          predicate ??
              (Route<dynamic> route) {
                return route == null;
              });
    } else {
      if (replace == true) {
        return _navigatorObserver.navigator.pushReplacement(newRoute);
      } else {
        return _navigatorObserver.navigator.push(newRoute);
      }
    }
  }

  void navigatorByName(String name,
      {bool replace: false, bool clearStack: false, RoutePredicate predicate}) {
    if (clearStack == true) {
      _navigatorObserver.navigator.pushNamedAndRemoveUntil(
          name,
          predicate ??
              (Route<dynamic> route) {
                return route == null;
              });
    } else {
      if (replace == true) {
        _navigatorObserver.navigator.pushReplacementNamed(name);
      } else {
        _navigatorObserver.navigator.pushNamed(name);
      }
    }
  }

  void pop({String name}) {
    if (name?.isNotEmpty == true) {
      _navigatorObserver.navigator.popUntil((Route<dynamic> route) {
        Print().printNative("_navigator ${route?.settings?.name}");
        if (route == null || route?.settings?.name == name) {
          return true;
        }
        return false;
      });
    } else {
      _navigatorObserver.navigator.pop();
    }
  }

  static RouteTransitionsBuilder standardTransitionsBuilder(
      {TransitionType transitionType: TransitionType.inFromTop}) {
    return (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      const Offset topLeft = const Offset(0.0, 0.0);
      const Offset topRight = const Offset(1.0, 0.0);
      const Offset bottomLeft = const Offset(0.0, 1.0);
      Offset startOffset = bottomLeft;
      Offset endOffset = topLeft;
      if (transitionType == TransitionType.inFromTop) {
        startOffset = const Offset(0.0, -1.0);
      } else {
        startOffset = const Offset(0.0, 1.0);
      }

      endOffset = topLeft;

      return SlideTransition(
        position: Tween<Offset>(
          begin: startOffset,
          end: endOffset,
        ).animate(animation),
        child: child,
      );
    };
  }
}
