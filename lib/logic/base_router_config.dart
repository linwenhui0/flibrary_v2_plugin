import 'package:flutter/material.dart'
    show
        BuildContext,
        MaterialPageRoute,
        NavigatorObserver,
        Route,
        RoutePredicate,
        Widget;

class BaseRouterConfig {
  NavigatorObserver _navigatorObserver;

  NavigatorObserver get navigatorObserver => _navigatorObserver;

  void initState() {
    _navigatorObserver = NavigatorObserver();
  }

  void dispose() {
    _navigatorObserver = null;
  }

  void navigator(Widget child,
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

  BuildContext get context => navigatorObserver.navigator.context;
}
