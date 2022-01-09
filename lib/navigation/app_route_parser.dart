import 'package:flutter/material.dart';

import 'app_link.dart';

// AppRouteParser extends RouteInformationParser. It takes a generic type. In this case,type is AppLink, which holds all the route and navigation information.
class AppRouteParser extends RouteInformationParser<AppLink> {
  // The route information contains the URL string.
  @override
  Future<AppLink> parseRouteInformation(
      RouteInformation routeInformation) async {
    // Take the route information and build an instance of AppLink from it.
    final link = AppLink.fromLocation(routeInformation.location);
    return link;
  }

  // 4
  @override
  RouteInformation restoreRouteInformation(AppLink appLink) {
    // This function passes in an AppLink object. Ask AppLink to give back the URL string.
    final location = appLink.toLocation();
    // Wrap it in RouteInformation to pass it along.
    return RouteInformation(location: location);
  }
}
