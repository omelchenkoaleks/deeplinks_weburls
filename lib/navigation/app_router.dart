import 'package:flutter/material.dart';

import '../models/models.dart';
import '../screens/screens.dart';
import 'app_link.dart';

class AppRouter extends RouterDelegate<AppLink>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final AppStateManager appStateManager;
  final GroceryManager groceryManager;
  final ProfileManager profileManager;

  AppRouter({
    required this.appStateManager,
    required this.groceryManager,
    required this.profileManager,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
    groceryManager.addListener(notifyListeners);
    profileManager.addListener(notifyListeners);
  }

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    groceryManager.removeListener(notifyListeners);
    profileManager.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _handlePopPage,
      pages: [
        if (!appStateManager.isInitialized) ...[
          SplashScreen.page(),
        ] else if (!appStateManager.isLoggedIn) ...[
          LoginScreen.page(),
        ] else if (!appStateManager.isOnboardingComplete) ...[
          OnboardingScreen.page(),
        ] else ...[
          Home.page(appStateManager.getSelectedTab),
          if (groceryManager.isCreatingNewItem)
            GroceryItemScreen.page(onCreate: (item) {
              groceryManager.addItem(item);
            }, onUpdate: (item, index) {
              // No update
            }),
          if (groceryManager.selectedIndex != -1)
            GroceryItemScreen.page(
                item: groceryManager.selectedGroceryItem,
                index: groceryManager.selectedIndex,
                onCreate: (_) {
                  // No create
                },
                onUpdate: (item, index) {
                  groceryManager.updateItem(item, index);
                }),
          if (profileManager.didSelectUser)
            ProfileScreen.page(profileManager.getUser),
          if (profileManager.didTapOnRaywenderlich) WebViewScreen.page(),
        ]
      ],
    );
  }

  bool _handlePopPage(Route<dynamic> route, result) {
    if (!route.didPop(result)) {
      return false;
    }

    if (route.settings.name == FooderlichPages.onboardingPath) {
      appStateManager.logout();
    }

    if (route.settings.name == FooderlichPages.groceryItemDetails) {
      groceryManager.groceryItemTapped(-1);
    }

    if (route.settings.name == FooderlichPages.profilePath) {
      profileManager.tapOnProfile(false);
    }

    if (route.settings.name == FooderlichPages.raywenderlich) {
      profileManager.tapOnRaywenderlich(false);
    }

    return true;
  }

  // TODO: Convert app state to applink

  // TODO: Apply configuration helper

  // Calls setNewRoutePath() when a new route is pushed. It passes along an AppLink. This is navigation configuration.
  @override
  Future<void> setNewRoutePath(AppLink newLink) async {
    // Use a switch to check every location.
    switch (newLink.location) {
      // If the new location is /profile, show the Profile screen.
      case AppLink.profilePath:
        profileManager.tapOnProfile(true);
        break;
      // Check if the new location starts with /item.
      case AppLink.itemPath:
        // If itemId is not null, set the selected grocery item and show the Grocery Item screen.
        final itemId = newLink.itemId;
        if (itemId != null) {
          groceryManager.setSelectedGroceryItem(itemId);
        } else {
          // If itemId is null, show an empty Grocery Item screen.
          groceryManager.createNewItem();
        }
        // Hide the Profile screen.
        profileManager.tapOnProfile(false);
        break;
      // If the new location is /home.
      case AppLink.homePath:
        // Set the currently selected tab.
        appStateManager.goToTab(newLink.currentTab ?? 0);
        // Make sure the Profile screen and Grocery Item screen are hidden.
        profileManager.tapOnProfile(false);
        groceryManager.groceryItemTapped(-1);
        break;
      // If the location does not exist, do nothing.
      default:
        break;
    }
  }

  @override
  Future<void> setNewRoutePath(configuration) async => null;
}
