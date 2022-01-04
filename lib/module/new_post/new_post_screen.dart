import 'package:chat/shared/components/components.dart';
import 'package:flutter/material.dart';

class NewPostScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(
          context: context,
        title: 'Add Post',
      ),
    );
  }
}
