import 'package:flutter/material.dart';
import 'package:after_init/after_init.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Example(),
      ),
    ),
  );
}

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> with AfterInitMixin<Example> {
  late Size size;

  /// This gets called first, as usual.
  @override
  void initState() {
    super.initState();
    // Your code here
  }

  /// This gets called after initState(), only once.
  /// Safely access inherited widgets here.
  @override
  void didInitState() {
    // No need to call super.didInitState().
    // setState() is not required because build() will automatically be called by Flutter.
    size = MediaQuery.of(context).size;
  }

  /// This gets called after didInitState().
  /// And anytime the widget's dependencies change, as usual.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Your code here
  }

  /// Finally this gets called, as usual.
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(size.toString()),
    );
  }
}
