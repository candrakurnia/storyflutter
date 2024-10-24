import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:storyflutter/common/common.dart';
import 'package:storyflutter/core.dart';
import 'package:storyflutter/localization/localization.dart';
import 'package:storyflutter/provider/all_stories_provider.dart';
import 'package:storyflutter/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:storyflutter/provider/localization_provider.dart';

class HomeScreenPage extends StatefulWidget {
  final Function() onLogout;
  final Function(String) onTapped;
  final Function() onPosted;

  const HomeScreenPage(
      {super.key,
      required this.onLogout,
      required this.onTapped,
      required this.onPosted});

  @override
  State<HomeScreenPage> createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    // AuthProvider authProvider =
    //     Provider.of<AuthProvider>(context, listen: false);
    // authProvider.gettingToken();
    // authProvider.getAllStories(context.read<AllStoriesProvider>());
    super.initState();
    final allProvider = context.read<AllStoriesProvider>();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        allProvider.nextLoad();
        allProvider.fetchallStories();
        // if (allProvider.pageItems != null) {
        //   allProvider.fetchallStories();
        // }
      }
    });
    Future.microtask(() async => allProvider.fetchallStories());
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        title: Image.asset(
          'assets/images/ic_splash.png',
          height: 50,
        ),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton(
              icon: const Icon(Icons.flag),
              items: AppLocalizations.supportedLocales.map((Locale locale) {
                final flag = Localization.getFlag(locale.languageCode);
                return DropdownMenuItem(
                  value: locale,
                  child: Center(
                    child: Text(
                      flag,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  onTap: () {
                    final provider = Provider.of<LocalizationProvider>(context,
                        listen: false);
                    provider.setLocale(locale);
                  },
                );
              }).toList(),
              onChanged: (_) {},
            ),
          ),
          IconButton(
            onPressed: () {
              widget.onPosted();
            },
            icon: const Icon(
              Icons.add,
              size: 24.0,
            ),
          ),
          IconButton(
            onPressed: () async {
              final authRead = context.read<AuthProvider>();
              final result = await authRead.logout();
              if (result) {
                widget.onLogout();
              }
            },
            icon: const Icon(
              Icons.logout,
              size: 24.0,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          var allStory = context.read<AllStoriesProvider>();
          allStory.setCurrentPage(1);
          allStory.fetchallStories();
        },
        child: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(color: Colors.white60),
            child: Column(
              children: [
                Expanded(
                  child: Consumer<AllStoriesProvider>(
                      builder: (context, value, child) {
                    if (value.state == ResultState.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (value.state == ResultState.hasData) {
                      return ListView.builder(
                        controller: scrollController,
                        itemCount: value.data.length + 1,
                        // + (value.pageItems != null ? 1 : 0),
                        itemBuilder: (context, int index) {
                          if (index < value.data.length) {
                            var allStory = value.data[index];
                            return InkWell(
                              onTap: () => widget.onTapped(allStory.id),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.network(
                                              "https://images.unsplash.com/flagged/photo-1559502867-c406bd78ff24?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=685&q=80",
                                              width: 40.0,
                                              height: 40.0,
                                              fit: BoxFit.cover,
                                            ),
                                            const SizedBox(
                                              width: 5.0,
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    allStory.name,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  const Text(
                                                    "Lihat Lokasi",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Image.network(
                                          allStory.photoUrl,
                                          width: double.infinity,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.7,
                                          fit: BoxFit.cover,
                                        ),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        Text.rich(
                                          maxLines: 3,
                                          overflow: TextOverflow.fade,
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "${allStory.name} ",
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text: allStory.description,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 16.0,
                                        ),
                                        Text(
                                          DateFormat('EEEE, MM/d/y HH:mm')
                                              .format(
                                            DateTime.parse(
                                              allStory.createdAt.toString(),
                                            ),
                                          ),
                                          style: const TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          if (value.hasMore
                              // && value.pageItems != null
                              ) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          
                          return const SizedBox();
                        },
                      );
                    } else if (value.state == ResultState.noData) {
                      return Center(
                        child: Material(
                          child: Text(value.message),
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text(
                            "Terjadi Masalah, Harap tunggu beberapa saat lagi"),
                      );
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
