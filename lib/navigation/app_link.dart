class AppLink {
  // Create constants for each URL path.
  static const String homePath = '/home';
  static const String onboardingPath = '/onboarding';
  static const String loginPath = '/login';
  static const String profilePath = '/profile';
  static const String itemPath = '/item';
  // Create constants for each of the query parameters.
  static const String tabParam = 'tab';
  static const String idParam = 'id';
  // Store the path of the URL using location.
  String? location;
  // Use currentTab to store the tab want to redirect the user to.
  int? currentTab;
  // Store the ID of the item want to view in itemId.
  String? itemId;
  // Initialize the app link with the location and the two query parameters.
  AppLink({
    this.location,
    this.currentTab,
    this.itemId,
  });

// TODO: Add fromLocation

// TODO: Add toLocation

}
