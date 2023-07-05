import 'package:a_to_z_shop/features/admin/screens/admin_screen.dart';
import 'package:a_to_z_shop/features/auth/screens/login_screen.dart';
import 'package:a_to_z_shop/features/auth/screens/signup_screen.dart';
import 'package:flutter/material.dart';

import 'models/order_model.dart';
import 'models/product_model.dart';
import 'features/auth/screens/auth_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'common/widgets/bottom_nav_bar.dart';
import 'features/search/screens/search_screen.dart';
import 'features/home/screens/category_screen.dart';
import 'features/address/screens/address_screen.dart';
import 'features/account/screens/add_products_screen.dart';
import 'features/account/screens/sell_products_screen.dart';
import 'features/order_details/screens/order_details_screen.dart';
import 'features/product_details/screens/product_detail_screen.dart';

//So what is happending here is , we are simply returning MaterialPageRoute() which is needed to naviagte to
//different routes , but how do we know which page we have to go? we will use the routeSettings for that in this we have name property in which all the route name will have a corresponding switch case for them selves
//and which ever case matches with the name we will simply return the correcponding route , there is a default case too ie when no case mathes then it means this route does not exist so returning a screen with message of the screen does not exist then

//And we use this method in the onGenerateRoute property of the materialApp (which will be called whenever a named route is used in the project)
Route<dynamic> getRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );
    case BottomNavBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomNavBar(),
      );
    case AddProductScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddProductScreen(),
      );
    case SellProductsScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SellProductsScreen(),
      );
    case SingleCategoryScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SingleCategoryScreen(
          category: routeSettings.arguments
              as String, //this is how we can pass the arguments using the routeSettings
        ),
      );
    case SearchScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SearchScreen(
          whatIsSearched: routeSettings.arguments
              as String, //this is how we can pass the arguments using the routeSettings which here will be the query the user has searched for in the search bar
        ),
      );
    case ProductDetailScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ProductDetailScreen(
          product: routeSettings.arguments
              as Product, //this is how we can pass the arguments using the routeSettings which here will be the Product instance which the user wants to see the details of
        ),
      );
    case AddressScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AddressScreen(
          totalAmountToPay: routeSettings.arguments as String,
        ),
      );
    case OrderDetailsScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OrderDetailsScreen(
          currOrder: routeSettings.arguments as Order,
        ),
      );
    case LogInScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => const LogInScreen(),
      );
    case SignUpScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => const SignUpScreen(),
      );
    case AdminScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => const AdminScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(
            child: Text("This screen does not exist!!"),
          ),
        ),
      );
  }
}
