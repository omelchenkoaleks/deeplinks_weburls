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

  static AppLink fromLocation(String? location) {
    // First, you need to decode the URL.
    location = Uri.decodeFull(location ?? '');
    // Parse the URI for query parameter keys and key-value pairs.
    final uri = Uri.parse(location);
    final params = uri.queryParameters;

    // Extract the currentTab from the URL path if it exists.
    final currentTab = int.tryParse(params[AppLink.tabParam] ?? '');
    // Extract the itemId from the URL path if it exists.
    final itemId = params[AppLink.idParam];
    // Create the AppLink by passing in the query parameters extract from the URL string.
    final link = AppLink(
      location: uri.path,
      currentTab: currentTab,
      itemId: itemId,
    );
    // Return the instance of AppLink.
    return link;
  }

// TODO: Add toLocation

}
