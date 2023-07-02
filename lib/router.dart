import 'package:a_to_z_shop/commonThings/widgets/bottom_nav_bar.dart';
import 'package:a_to_z_shop/features/address/screens/address_screen.dart';
import 'package:a_to_z_shop/features/admin/screens/add_prod_screen.dart';
import 'package:a_to_z_shop/features/auth/screens/authscreen.dart';
import 'package:a_to_z_shop/features/home/screens/Cat_screen.dart';
import 'package:a_to_z_shop/features/home/screens/home_screen.dart';
import 'package:a_to_z_shop/features/orderDetails/screens/order_detail_screen.dart';
import 'package:a_to_z_shop/features/prodDetails/screens/product_detail_screen.dart';
import 'package:a_to_z_shop/features/search/screens/search_screen.dart';
import 'package:a_to_z_shop/models/order_model.dart';
import 'package:a_to_z_shop/models/product_model.dart';
import 'package:flutter/material.dart';

//So what is happending here is , we are simply returning MaterialPageRoute() which is needed to naviagte to
//different routes , but how do we know which page we have to go? we will use the routeSettings for that in this we have name property in which all the route name will have a corresponding switch case for them selves
//and which ever case matches with the name we will simply return the correcponding route , there is a default case too ie when no case mathes then it means this route does not exist so returning a screen with message of the screen does not exist then

//And we use this method in the onGenerateRoute property of the materialApp (which will be called whenever a named route is used in the project)
Route<dynamic> getRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const AuthScreen());
    case HomeScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const HomeScreen());
    case BottomNavBar.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const BottomNavBar());
    case AddProductScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const AddProductScreen());
    case SingleCategoryScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => SingleCategoryScreen(
                category: routeSettings.arguments
                    as String, //this is how we can pass the arguments using the routeSettings
              ));
    case SearchScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => SearchScreen(
                whatIsSearched: routeSettings.arguments
                    as String, //this is how we can pass the arguments using the routeSettings which here will be the query the user has searched for in the search bar
              ));
    case ProductDetailScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => ProductDetailScreen(
                product: routeSettings.arguments
                    as Product, //this is how we can pass the arguments using the routeSettings which here will be the Product instance which the user wants to see the details of
              ));
    case AddressScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => AddressScreen(
                totalAmountToPay: routeSettings.arguments as String,
              ));
    case OrderDetailsScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => OrderDetailsScreen(
                currOrder: routeSettings.arguments as Order,
              ));
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
