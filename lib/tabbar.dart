import 'package:flutter/cupertino.dart';
import 'store_cart.dart' show CupertinoStoreCartPage;
import 'store_search.dart' show CupertinoStoreSearchPage;
import 'store_home.dart' show CupertinoStoreHomePage;

class TabbarPage extends StatelessWidget {
  final List<dynamic> _tabTabs = [
    {'icon': CupertinoIcons.home, 'title': '商品', 'body': CupertinoStoreHomePage()},
    {'icon': CupertinoIcons.search, 'title': '搜索', 'body': CupertinoStoreSearchPage()},
    {'icon': CupertinoIcons.shopping_cart, 'title': '购物车', 'body': CupertinoStoreCartPage()},
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: _tabTabs.map((tab) => BottomNavigationBarItem(icon: Icon(tab['icon']), title: Text(tab['title']))).toList(),
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            return CupertinoPageScaffold(
              child: _tabTabs[index]['body'],
            );
          },
        );
      },
    );
  }
}
