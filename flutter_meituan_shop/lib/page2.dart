import 'package:flutter/material.dart';

import 'shop/shop_scroll_controller.dart';
import 'shop/shop_scroll_coordinator.dart';

class Page2 extends StatefulWidget {
  final ShopScrollCoordinator shopCoordinator;

  const Page2({@required this.shopCoordinator, Key key}) : super(key: key);

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> with AutomaticKeepAliveClientMixin{
  ShopScrollCoordinator _shopCoordinator;
  ShopScrollController _listScrollController;

  @override
  void initState() {
    _shopCoordinator = widget.shopCoordinator;
    _listScrollController = _shopCoordinator.newChildScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      physics: ClampingScrollPhysics(),
      controller: _listScrollController,
      itemExtent: 150,
      itemBuilder: (context, index) => InkWell(
        onTap: () => _listScrollController.animateTo(1000, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
        child: Container(
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(5.0),
            color: index % 2 == 0 ? Colors.cyan : Colors.deepOrange,
            child: Center(child: Text(index.toString())),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _listScrollController?.dispose();
    _listScrollController = null;
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
