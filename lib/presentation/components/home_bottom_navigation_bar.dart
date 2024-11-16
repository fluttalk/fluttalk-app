import 'package:fluttalk/presentation/common/bottom_navigation_items.dart';
import 'package:fluttalk/presentation/theme/my_text_styles.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class HomeBottonNavigationBar extends StatelessWidget {
  static const _navigationItems = [
    BottomNavigationItems.friendList,
    BottomNavigationItems.chatList,
    BottomNavigationItems.more,
  ];

  final ValueNotifier<BottomNavigationItems> navigationItemNotifier;
  const HomeBottonNavigationBar(this.navigationItemNotifier, {super.key});

  get _selectedIndex => navigationItemNotifier.value;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: navigationItemNotifier,
      builder: (context, value, child) {
        return BottomNavigationBar(
          currentIndex: _selectedIndex.index,
          selectedLabelStyle: MyTextStyles.bodyText1,
          items: _navigationItems
              .mapIndexed(
                (index, item) => item.bottomNavigationBarItem(
                  isSelected: item.index == _selectedIndex.index,
                ),
              )
              .toList(),
          onTap: (index) =>
              navigationItemNotifier.value = _navigationItems[index],
        );
      },
    );
  }
}
