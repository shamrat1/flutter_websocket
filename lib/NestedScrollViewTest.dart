

import 'package:flutter/material.dart';

class NestedScrollViewTest extends StatefulWidget {

  const NestedScrollViewTest({ Key? key }) : super(key: key);

  @override
  _NestedScrollViewTestState createState() => _NestedScrollViewTestState();
}

class _NestedScrollViewTestState extends State<NestedScrollViewTest> with SingleTickerProviderStateMixin {

  late TabController tabController = TabController(length: 3, vsync: this);
    int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    // tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {
        selectedIndex = tabController.index;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: NestedScrollView(
            physics: NeverScrollableScrollPhysics(),
            headerSliverBuilder: (context,isScrolled){
              return [
                SliverAppBar(
                  title: Text('Nested Scroll View'),
                  // actions: [],
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black,
                  ),
                ),
                SliverPersistentHeader(
                  floating: true,
                  pinned: true,
                  delegate: SliverPersistantHeaderDelegateImplementation(
                    height: 40,
                    child: TabBar(
                      controller: tabController,
                      tabs: [
                        Tab(
                          icon: Text("one",style: TextStyle(color: Colors.black),),
                        ),
                        Tab(
                          icon: Text("two",style: TextStyle(color: Colors.black),),
                        ),
                        Tab(
                          icon: Text("three",style: TextStyle(color: Colors.black),),
                        ),
                      ],
                    )
                  )
                )
              ];
            },
            body: Container(
              // height: 400,
              child: TabBarView(
                controller: tabController,
                children: [
                _tabOne(),
                _tabOne(),
                _tabOne(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabOne() {
  return SingleChildScrollView(
    padding: EdgeInsets.all(0.0),
    physics: AlwaysScrollableScrollPhysics(),
    child: Container(
      // height: 400,
      color: Colors.black,
      child: Column(
        children: [
        Container(margin: EdgeInsets.all(20),color: Colors.red,height: 50 + (tabController.index * 101),),
        Container(margin: EdgeInsets.all(20),color: Colors.red,height: 50 + (tabController.index * 10),),
        Container(margin: EdgeInsets.all(20),color: Colors.red,height: 50  + (tabController.index * 44),),
        Container(margin: EdgeInsets.all(20),color: Colors.red,height: 50 + (tabController.index * 5),),
        Container(margin: EdgeInsets.all(20),color: Colors.red,height: 550  + (tabController.index * 2),),
        Container(margin: EdgeInsets.all(20),color: Colors.red,height: 50 + (tabController.index * 55),),
      ],),
    ),
  );
}
}



class SliverPersistantHeaderDelegateImplementation extends SliverPersistentHeaderDelegate
{
  final double height;
  final Widget child;

  SliverPersistantHeaderDelegateImplementation({required this.height,required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      height: height,
      child: child,
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

}