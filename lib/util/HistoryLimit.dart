import 'package:flutter/material.dart';


class HistoryLimit extends NavigatorObserver {
  final int limit;
  final history = <Route>[];

  HistoryLimit([this.limit = 10]);


  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    final index = history.indexOf(oldRoute);
    history[index] = newRoute;
  }


  @override
  void didPush(Route route, Route previousRoute) {
    history.add(route);
     
  }

  @override
  void didPop(Route route, Route previousRoute) {
    history.remove(route);
  }

  @override
  void didRemove(Route route, Route previousRoute) {
    history.remove(route);
  }
}