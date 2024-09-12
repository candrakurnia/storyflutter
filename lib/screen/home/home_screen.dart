import 'package:flutter/material.dart';
import 'package:storyflutter/core.dart';
import 'package:storyflutter/provider/all_stories_provider.dart';
import 'package:storyflutter/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:storyflutter/screen/story/post_story.dart';

class HomeScreenPage extends StatefulWidget {
  final Function() onLogout;
  final Function(String) onTapped;

  const HomeScreenPage({
    super.key,
    required this.onLogout,
    required this.onTapped,
  });

  @override
  State<HomeScreenPage> createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {
  @override
  void initState() {
    // AuthProvider authProvider =
    //     Provider.of<AuthProvider>(context, listen: false);
    // authProvider.gettingToken();
    // authProvider.getAllStories(context.read<AllStoriesProvider>());
    super.initState();
    final authProvider = context.read<AuthProvider>();
    final allProvider = context.read<AllStoriesProvider>();
    Future.microtask(() => authProvider.getAllStories(allProvider));

  }

  @override
  Widget build(BuildContext context) {
    // final authWatch = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        title: Image.asset(
          'assets/images/ic_splash.png',
          height: 50,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const PostStoryScreen(),
              ));
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
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/ic_background.png'),
                fit: BoxFit.cover),
          ),
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
                      itemCount: value.allStories!.listStory.length,
                      // physics: const ScrollPhysics(),
                      itemBuilder: (context, int index) {
                        var allStory = value.allStories!.listStory[index];
                        return InkWell(
                          onTap: () => widget.onTapped(allStory.id),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                border: Border.all(
                                  color: Colors.grey[900]!,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.network(
                                          "https://images.unsplash.com/flagged/photo-1559502867-c406bd78ff24?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=685&q=80",
                                          width: 50.0,
                                          height: 50.0,
                                          fit: BoxFit.cover,
                                        ),
                                        const SizedBox(
                                          width: 5.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              allStory.name,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              allStory.createdAt.toString(),
                                              style: const TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    Image.network(
                                      allStory.photoUrl,
                                      width: double.infinity,
                                      height: 200.0,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white70,
                                        border: Border.all(
                                            color: Colors.black26, width: 2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        allStory.description,
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
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
                      child: Material(
                        child: Text(""),
                      ),
                    );
                  }
                }),
              ),
              // ElevatedButton(
              //   onPressed: () async {
              // final authRead = context.read<AuthProvider>();
              // final result = await authRead.logout();
              // if (result) {
              //   widget.onLogout();
              // }
              //   },
              //   child: authWatch.isLoadingLogout
              //       ? const CircularProgressIndicator(
              //           color: Colors.white,
              //         )
              //       : const Text("Logout"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
