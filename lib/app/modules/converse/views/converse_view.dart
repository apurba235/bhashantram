import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/converse_controller.dart';

class ConverseView extends GetView<ConverseController> {
  const ConverseView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ConverseView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ConverseView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
