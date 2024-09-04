// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class PostStoryScreen extends StatefulWidget {
  const PostStoryScreen({Key? key}) : super(key: key);

  @override
  State<PostStoryScreen> createState() => _PostStoryScreenState();
}

class _PostStoryScreenState extends State<PostStoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Story"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              
            ],
          ),
        ),
      ),
    );
  }
}
