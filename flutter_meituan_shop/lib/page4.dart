import 'package:flutter/material.dart';
import 'package:flutter_meituan_shop/shop/shop_scroll_controller.dart';
import 'package:flutter_meituan_shop/shop/shop_scroll_coordinator.dart';

class Page4 extends StatefulWidget {
  final ShopScrollCoordinator shopCoordinator;
  const Page4({Key key , this.shopCoordinator}) : super(key: key);

  @override
  _Page4State createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  ShopScrollCoordinator _shopCoordinator;
  ShopScrollController _listScrollController;
  @override
  void initState() {
    super.initState();
    _shopCoordinator = widget.shopCoordinator;
    _listScrollController = _shopCoordinator.newChildScrollController();
  }
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 100,
      controller: _listScrollController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10 
      ), 
      itemBuilder: (context, index) {
        return Container(height: 100, color: index % 2 == 0 ? Colors.red : Colors.blue,);
      }
    );
  }
}