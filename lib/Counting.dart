import 'package:flutter/material.dart';

class Counting extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('記帳'),
      ),
      body: _Counting(),
    );
  }
}
class _Counting extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Page02'),
    );
  }
}