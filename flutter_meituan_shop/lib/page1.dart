import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'shop/shop_scroll_controller.dart';
import 'shop/shop_scroll_coordinator.dart';

class Page1 extends StatefulWidget {
  final ShopScrollCoordinator shopCoordinator;
  final ShopScrollController parentController;
  const Page1({@required this.shopCoordinator, this.parentController, Key key}) : super(key: key);

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  ShopScrollCoordinator _shopCoordinator;
  ShopScrollController _listScrollController1;
  ShopScrollController _listScrollController2;
  
  @override
  void initState() {
    _shopCoordinator = widget.shopCoordinator;
    
    _listScrollController1 = _shopCoordinator.newChildScrollController();
    _listScrollController2 = _shopCoordinator.newChildScrollController();
    _listScrollController2.addListener(() { 
      print("current scroll index" + (_listScrollController2.offset ~/ 200).toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(0),
            physics: AlwaysScrollableScrollPhysics(),
            controller: _listScrollController1,
            itemExtent: 50.0,
            itemCount: 20,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                widget.parentController.animateTo(500, duration: const Duration(seconds: 1), curve: Curves.easeInOut);
                _listScrollController2.animateTo(index.toDouble() * 200, duration: const Duration(seconds: 1), curve: Curves.easeInOut);
              },
              child: Container(
                child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(5.0),
                  color: index % 2 == 0 ? Colors.cyan : Colors.deepOrange,
                  child: Center(child: Text(index.toString())),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: ListView.builder(
            padding: EdgeInsets.all(0),
            physics: AlwaysScrollableScrollPhysics(),
            controller: _listScrollController2,
            itemExtent: 200.0,
            itemCount: 30,
            itemBuilder: (context, index) => Container(
              padding: EdgeInsets.symmetric(horizontal: 1),
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(5.0),
                color: index % 2 == 0 ? Colors.cyan : Colors.deepOrange,
                child: Center(child: Text(index.toString())),
              ),
            ),
          ),
          // child: ScrollablePositionedList.builder(
          //   itemCount: 500,
          //   itemBuilder: (context, index) => Text('Item $index'),
          //   itemScrollController: itemScrollController,
          //   itemPositionsListener: itemPositionsListener,
          // ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _listScrollController1?.dispose();
    _listScrollController2?.dispose();
    _listScrollController1 = _listScrollController2 = null;
    super.dispose();
  }
}
