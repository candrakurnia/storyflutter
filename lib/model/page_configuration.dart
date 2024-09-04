class PageConfiguration {
  final bool unknown;
  final bool register;
  final bool? loggedIn;
  final String? userId;

  PageConfiguration.splash()
      : unknown = false,
        register = false,
        loggedIn = null,
        userId = null;

  PageConfiguration.login()
      : unknown = false,
        register = false,
        loggedIn = false,
        userId = null;
  PageConfiguration.register()
      : unknown = false,
        register = true,
        loggedIn = null,
        userId = null;
  PageConfiguration.detail(String id)
      : unknown = false,
        register = true,
        loggedIn = true,
        userId = id;
  PageConfiguration.home()
      : unknown = false,
        register = false,
        loggedIn = true,
        userId = null;
  PageConfiguration.unknown()
      : unknown = true,
        register = false,
        loggedIn = null,
        userId = null;
  bool get isSplashPage =>
      unknown == false && register == false && loggedIn == null;
  bool get isLoginPage =>
      unknown == false && register == false && loggedIn == false;
  bool get isRegisterPage =>
      unknown == false && register == true && loggedIn == false;
  bool get isHomePage =>
      unknown == false && register == false && loggedIn == true;
  bool get isUnknownPage =>
      unknown == true && register == false && loggedIn == null;
  bool get isDetailPage =>
      unknown == false &&
      register == false &&
      loggedIn == true &&
      userId != null;
}
