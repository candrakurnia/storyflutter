import 'package:flutter/material.dart';
import 'package:storyflutter/db/auth_repository.dart';
import 'package:storyflutter/screen/detail/detail_screen.dart';
import 'package:storyflutter/screen/home/home_screen.dart';
import 'package:storyflutter/screen/login/login_screen.dart';
import 'package:storyflutter/model/page_configuration.dart';
import 'package:storyflutter/screen/maps/maps_screen.dart';
import 'package:storyflutter/screen/register/register_screen.dart';
import 'package:storyflutter/screen/splash/splashscreen.dart';
import 'package:storyflutter/screen/story/post_story.dart';

class MyRouterDelegate extends RouterDelegate<PageConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthRepository authRepository;

  bool? isLoggedIn;
  bool? isRegister = false;
  bool? isUnknown;
  bool? isPosted;
  bool? isLocation;

  List<Page> historyStack = [];

  List<Page> get _splashStack => const [
        MaterialPage(
          key: ValueKey("SplashPage"),
          child: SplashScreenPage(),
        ),
      ];
  List<Page> get _loggedOutStack => [
        MaterialPage(
          key: const ValueKey("LoginPage"),
          child: LoginScreen(
            onLogin: () {
              isLoggedIn = true;
              notifyListeners();
            },
            onRegister: () {
              isRegister = true;
              notifyListeners();
            },
          ),
        ),
        if (isRegister == true)
          MaterialPage(
            key: const ValueKey("RegisterPage"),
            child: RegisterPage(
              onRegister: () {
                isRegister = false;
                notifyListeners();
              },
              onLogin: () {
                isRegister = false;
                notifyListeners();
              },
            ),
          ),
      ];
  List<Page> get _postStack => [
        MaterialPage(
          key: const ValueKey("PostPage"),
          child: PostStoryScreen(
            onPosted: () {
              isLoggedIn = true;
              isPosted = false;
              notifyListeners();
            },
          ),
        ),
      ];
  List<Page> get _locStack => [
        MaterialPage(
          child: MapsScreen(
            onMaps : () {
              isLocation = true;
              notifyListeners();
            }
          ),
        ),
      ];
  List<Page> get _loggedInStack => [
        MaterialPage(
          key: const ValueKey("HomeStory"),
          child: HomeScreenPage(
            onLogout: () {
              isLoggedIn = false;
              notifyListeners();
            },
            onTapped: (String id) {
              selectedUser = id;
              notifyListeners();
            },
            onPosted: () {
              isLoggedIn = true;
              isPosted = true;
              notifyListeners();
            },
            onMaps : () {
              isLoggedIn = true;
              isLocation = true;
              notifyListeners();
            }
          ),
        ),
        if (selectedUser != null)
          MaterialPage(
            key: ValueKey(selectedUser),
            child: DetailScreen(
              userId: selectedUser!,
            ),
          ),
      ];

  MyRouterDelegate(this.authRepository)
      : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    isLoggedIn = await authRepository.isLoggedIn();
    notifyListeners();
  }

  String? selectedUser;

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true && isPosted == true) {
      historyStack = _loggedInStack + _postStack;
    } else if (isLoggedIn == true && isLocation == true) {
      historyStack = _loggedInStack + _locStack;
    } else if (isLoggedIn == true && isPosted == false) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }
    return Navigator(
      key: navigatorKey,
      pages: historyStack,
      onPopPage: (route, result) {
        final didPop = route.didPop(result);
        if (!didPop) {
          return false;
        }
        isRegister = false;
        isPosted = false;
        isLocation = false;
        selectedUser = null;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(PageConfiguration configuration) async {
    if (configuration.isUnknownPage) {
      isUnknown = true;
      isRegister = false;
    } else if (configuration.isRegisterPage) {
      isRegister = true;
    } else if (configuration.isHomePage ||
        configuration.isLoginPage ||
        configuration.isSplashPage) {
      isUnknown = false;
      isRegister = false;
      selectedUser = null;
      isPosted = false;
    } else if (configuration.isDetailPage) {
      isUnknown = false;
      isRegister = false;
      selectedUser = configuration.userId.toString();
    } else if (configuration.isPostpage) {
      isUnknown = false;
      isRegister = false;
      isPosted = true;
    } else {
      print(' Could not set new route');
    }
    notifyListeners();
  }

  @override
  PageConfiguration? get currentConfiguration {
    if (isLoggedIn == null) {
      return PageConfiguration.splash();
    } else if (isRegister == true) {
      return PageConfiguration.register();
    } else if (isLoggedIn == false) {
      return PageConfiguration.login();
    } else if (isUnknown == true) {
      return PageConfiguration.unknown();
    } else if (selectedUser == null) {
      return PageConfiguration.home();
    } else if (selectedUser != null) {
      return PageConfiguration.detail(selectedUser!);
    } else if (isPosted == true) {
      return PageConfiguration.post();
    } else {
      return null;
    }
  }
}
