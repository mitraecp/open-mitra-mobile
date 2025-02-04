import 'package:flutter/material.dart';

class RouteHistoryObserver extends NavigatorObserver {
  final List<String> _routeStack = [];

  List<String> get routeStack => _routeStack;

  bool isRouteInStack(String routeName) {
    return _routeStack.contains(routeName);
  }

  String currentRoute() {
    return _routeStack.last;
  }

  String watIsBefore(String routeName) {
    int currentIndex =
        _routeStack.indexWhere((element) => element == routeName);
    return _routeStack[currentIndex - 1];
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _addRoute(route);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _removeRoute(route);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    _removeRoute(route);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (oldRoute != null) _removeRoute(oldRoute);
    if (newRoute != null) _addRoute(newRoute);
  }

  void _addRoute(Route route) {
    if (route.settings.name != null) {
      _routeStack.add(route.settings.name!);
    }
  }

  void _removeRoute(Route route) {
    if (route.settings.name != null) {
      _routeStack.remove(route.settings.name);
    }
  }
}
