// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:storyflutter/core.dart';
import 'package:storyflutter/provider/detail_story_provider.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  final String userId;
  const DetailScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    final detailProvider = context.read<DetailStoryProvider>();
    Future.microtask(() async => detailProvider.fetchDetail(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
      ),
      body: SingleChildScrollView(
        child: Consumer<DetailStoryProvider>(
          builder: (context, value, child) {
            if (value.resultState == ResultState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (value.resultState == ResultState.hasData) {
              return Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(color: Colors.amber),
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.5,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              border: Border.all(width: 1.0),
                              borderRadius: BorderRadius.circular(8)),
                          child: Image.network(
                              fit: BoxFit.contain,
                              value.detailStories!.story.photoUrl),
                        ),
                        Text(value.detailStories!.story.name),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Text(value.detailStories!.story.description),
                        Text(value.detailStories!.story.createdAt.toString()),
                      ],
                    )),
              );
            } else if (value.resultState == ResultState.noData) {
              return Center(
                child: Text(value.message),
              );
            } else {
              return const Center(
                child: Text("Terjadi Kesalahan, periksa koneksi anda"),
              );
            }
          },
        ),
      ),
    );
  }
}
