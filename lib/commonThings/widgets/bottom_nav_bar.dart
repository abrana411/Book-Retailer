import 'package:a_to_z_shop/features/account/screens/account_screen.dart';
import 'package:a_to_z_shop/features/cart/screens/cart_screen.dart';
import 'package:a_to_z_shop/features/home/screens/home_screen.dart';
import 'package:a_to_z_shop/helperConstants/global_variables.dart';
import 'package:a_to_z_shop/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  static const String routeName = "/actual-home";
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> AllScreens = [
    const HomeScreen(),
    const AccountScreen(),
    const CartScreen(),
  ];

  void updateTheSelectedPage(int newPageNumber) {
    setState(() {
      _page = newPageNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    final NumberOfItemsInUsersCart =
        Provider.of<UserProvider>(context).user.cart.length;
    return Scaffold(
      body: AllScreens[_page], //showing the current screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        onTap: updateTheSelectedPage,
        items: [
          // HOME (For the home screen)
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 0
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.home_outlined,
              ),
            ),
            label: '',
          ),
          // ACCOUNT
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 1
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.person_outline_outlined,
              ),
            ),
            label: '', //(have to give label in each to avoid error)
          ),
          // CART (for showing the cart and also the items in it(using the badges package for that))
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 2
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: badges.Badge(
                badgeStyle: const badges.BadgeStyle(
                  badgeColor: Colors.white,
                  elevation: 0,
                ),
                badgeContent: Text(NumberOfItemsInUsersCart.toString()),
                child: const Icon(
                  Icons.shopping_cart_outlined,
                ),
              ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
