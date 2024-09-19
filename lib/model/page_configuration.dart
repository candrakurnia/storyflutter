class PageConfiguration {
  final bool unknown;
  final bool register;
  final bool? loggedIn;
  final String? userId;
  final bool? postStory;
  final bool? locStory;

  PageConfiguration.splash()
      : unknown = false,
        register = false,
        loggedIn = null,
        userId = null,
        postStory = false,
        locStory = false;

  PageConfiguration.login()
      : unknown = false,
        register = false,
        loggedIn = false,
        userId = null,
        postStory = false,
        locStory = false;

  PageConfiguration.register()
      : unknown = false,
        register = true,
        loggedIn = null,
        userId = null,
        postStory = false,
        locStory = false;

  PageConfiguration.detail(String id)
      : unknown = false,
        register = true,
        loggedIn = true,
        userId = id,
        postStory = false,
        locStory = false;

  PageConfiguration.post()
      : unknown = false,
        register = true,
        loggedIn = true,
        userId = null,
        postStory = true,
        locStory = false;

  PageConfiguration.locPage()
      : unknown = false,
        register = false,
        loggedIn = true,
        userId = null,
        postStory = false,
        locStory = true;

  PageConfiguration.home()
      : unknown = false,
        register = false,
        loggedIn = true,
        userId = null,
        postStory = false,
        locStory = false;

  PageConfiguration.unknown()
      : unknown = true,
        register = false,
        loggedIn = null,
        userId = null,
        postStory = false,
        locStory = false;

  bool get isSplashPage =>
      unknown == false &&
      register == false &&
      loggedIn == null &&
      postStory == false &&
      locStory == false;

  bool get isLoginPage =>
      unknown == false &&
      register == false &&
      loggedIn == false &&
      postStory == false &&
      locStory == false;

  bool get isRegisterPage =>
      unknown == false &&
      register == true &&
      loggedIn == false &&
      postStory == false &&
      locStory == false;

  bool get isHomePage =>
      unknown == false &&
      register == false &&
      loggedIn == true &&
      postStory == false &&
      locStory == false;

  bool get isUnknownPage =>
      unknown == true &&
      register == false &&
      loggedIn == null &&
      postStory == false &&
      locStory == false;

  bool get isDetailPage =>
      unknown == false &&
      register == false &&
      loggedIn == true &&
      userId != null &&
      postStory == false &&
      locStory == false;

  bool get isPostpage =>
      unknown == false &&
      register == false &&
      loggedIn == true &&
      postStory == true &&
      locStory == false;

  bool get isLocPage =>
      unknown == false &&
      register == false &&
      loggedIn == true &&
      postStory == false &&
      locStory == true;
}
