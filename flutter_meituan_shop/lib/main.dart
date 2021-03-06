import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_meituan_shop/page4.dart';
import 'page1.dart';
import 'page2.dart';
import 'page3.dart';
import 'shop/shop_scroll_coordinator.dart';

import 'shop/shop_scroll_controller.dart';

void main() => runApp(MyApp());
MediaQueryData mediaQuery;
double statusBarHeight;
double screenHeight;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShopScroll',
      home: ShopPage(),
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}

class ShopPage extends StatefulWidget {
  ShopPage({Key key}) : super(key: key);

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage>
    with SingleTickerProviderStateMixin {
  ///页面滑动协调器
  ShopScrollCoordinator _shopCoordinator;
  ShopScrollController _pageScrollController;

  TabController _tabController;

  final double _sliverAppBarInitHeight = 200;
  final double _tabBarHeight = 50;
  double _sliverAppBarMaxHeight;

  @override
  void initState() {
    super.initState();
    _shopCoordinator = ShopScrollCoordinator();
    _tabController = TabController(vsync: this, length: 4);
  }

  @override
  Widget build(BuildContext context) {
    mediaQuery ??= MediaQuery.of(context);
    screenHeight ??= mediaQuery.size.height;
    statusBarHeight ??= mediaQuery.padding.top;

    _sliverAppBarMaxHeight ??= screenHeight;
    _pageScrollController ??= _shopCoordinator
        .pageScrollController(0);

    _shopCoordinator.pinnedHeaderSliverHeightBuilder ??= () {
      return statusBarHeight + kToolbarHeight + _tabBarHeight;
    };
    return Scaffold(
      body: Listener(
        onPointerUp: _shopCoordinator.onPointerUp,
        child: CustomScrollView(
          controller: _pageScrollController,
          physics: ClampingScrollPhysics(),
          slivers: <Widget>[
            // SliverAppBar(
            //   pinned: true,
            //   title: Text("店铺首页", style: TextStyle(color: Colors.white)),
            //   backgroundColor: Colors.blue,
            //   expandedHeight: _sliverAppBarMaxHeight,
            // ),
            SliverToBoxAdapter(
              child: Container(height: _sliverAppBarInitHeight, color: Colors.red,),
            ),
            SliverPersistentHeader(
              pinned: false,
              floating: true,
              delegate: _SliverAppBarDelegate(
                maxHeight: 100,
                minHeight: 100,
                child: Center(child: Text("我是活动Header")),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: _SliverAppBarDelegate(
                maxHeight: _tabBarHeight,
                minHeight: _tabBarHeight,
                child: Container(
                  color: Colors.white,
                  child: TabBar(
                    labelColor: Colors.black,
                    controller: _tabController,
                    tabs: <Widget>[
                      Tab(text: "动态"),
                      Tab(text: "商品"),
                      Tab(text: "评价"),
                      Tab(text: "商家"),
                    ],
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  Page4(shopCoordinator: _shopCoordinator,),
                  Page1(shopCoordinator: _shopCoordinator, parentController: _pageScrollController,),
                  Page2(shopCoordinator: _shopCoordinator),
                  Page3(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _pageScrollController?.dispose();
    super.dispose();
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => this.minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
