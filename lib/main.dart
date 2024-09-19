import 'package:flutter/material.dart';
import 'package:storyflutter/api/api_service.dart';
import 'package:storyflutter/common/common.dart';
import 'package:storyflutter/db/auth_repository.dart';
import 'package:storyflutter/provider/all_stories_provider.dart';
import 'package:storyflutter/provider/auth_provider.dart';
import 'package:storyflutter/provider/detail_story_provider.dart';
import 'package:storyflutter/provider/localization_provider.dart';
import 'package:storyflutter/provider/login_provider.dart';
import 'package:storyflutter/provider/register_provider.dart';
import 'package:storyflutter/provider/upload_provider.dart';
import 'package:storyflutter/routes/route_information_parser.dart';
import 'package:storyflutter/routes/router_delegate.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AuthProvider authProvider;
  late MyRouteInformationParser myRouterInformationParser;
  late MyRouterDelegate myRouterDelegate;

  @override
  void initState() {
    super.initState();

    final authRepository = AuthRepository();

    authProvider = AuthProvider(authRepository);

    myRouterDelegate = MyRouterDelegate(authRepository);
    myRouterInformationParser = MyRouteInformationParser();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => authProvider),
        ChangeNotifierProvider(
            create: (context) => LoginProvider(apiService: ApiService())),
        ChangeNotifierProvider(
            create: (context) => RegisterProvider(apiService: ApiService())),
        ChangeNotifierProvider(
            create: (context) => AllStoriesProvider(apiService: ApiService())),
        ChangeNotifierProvider(
            create: (context) => DetailStoryProvider(apiService: ApiService())),
        ChangeNotifierProvider(
            create: (context) => UploadProvider(apiService: ApiService())),
        ChangeNotifierProvider<LocalizationProvider>(
          create: (context) => LocalizationProvider(),
          builder: (context, child) {
            final provider = Provider.of<LocalizationProvider>(context);
            return MaterialApp.router(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: provider.locale,
              debugShowCheckedModeBanner: false,
              title: "StoryApp",
              routerDelegate: myRouterDelegate,
              routeInformationParser: myRouterInformationParser,
              backButtonDispatcher: RootBackButtonDispatcher(),
            );
          },
        ),
      ],
    );
  }
}
