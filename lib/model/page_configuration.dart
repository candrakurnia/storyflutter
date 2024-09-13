class PageConfiguration {
  final bool unknown;
  final bool register;
  final bool? loggedIn;
  final String? userId;
  final bool? postStory;

  PageConfiguration.splash()
      : unknown = false,
        register = false,
        loggedIn = null,
        userId = null,
        postStory = false;

  PageConfiguration.login()
      : unknown = false,
        register = false,
        loggedIn = false,
        userId = null,
        postStory = false;
  PageConfiguration.register()
      : unknown = false,
        register = true,
        loggedIn = null,
        userId = null,
        postStory = false;
  PageConfiguration.detail(String id)
      : unknown = false,
        register = true,
        loggedIn = true,
        userId = id,
        postStory = false;
  PageConfiguration.post()
      : unknown = false,
        register = true,
        loggedIn = true,
        userId = null,
        postStory = true;
  PageConfiguration.home()
      : unknown = false,
        register = false,
        loggedIn = true,
        userId = null,
        postStory = false;
  PageConfiguration.unknown()
      : unknown = true,
        register = false,
        loggedIn = null,
        userId = null,
        postStory = false;
  bool get isSplashPage =>
      unknown == false &&
      register == false &&
      loggedIn == null &&
      postStory == false;
  bool get isLoginPage =>
      unknown == false &&
      register == false &&
      loggedIn == false &&
      postStory == false;
  bool get isRegisterPage =>
      unknown == false &&
      register == true &&
      loggedIn == false &&
      postStory == false;
  bool get isHomePage =>
      unknown == false &&
      register == false &&
      loggedIn == true &&
      postStory == false;
  bool get isUnknownPage =>
      unknown == true &&
      register == false &&
      loggedIn == null &&
      postStory == false;
  bool get isDetailPage =>
      unknown == false &&
      register == false &&
      loggedIn == true &&
      userId != null &&
      postStory == false;
  bool get isPostpage =>
      unknown == false &&
      register == false &&
      loggedIn == true &&
      postStory == true;
}
