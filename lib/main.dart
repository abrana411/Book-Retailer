import 'package:a_to_z_shop/commonThings/widgets/bottom_nav_bar.dart';
import 'package:a_to_z_shop/features/auth/screens/authscreen.dart';
import 'package:a_to_z_shop/features/auth/services/auth_services.dart';
import 'package:a_to_z_shop/helperConstants/global_variables.dart';
import 'package:a_to_z_shop/providers/user_provider.dart';
import 'package:a_to_z_shop/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/admin/screens/admin_screen.dart';

void main() {
  runApp(MultiProvider(providers: [
    //Setting the provider here
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();
  @override
  void initState() {
    super.initState();

    //get the current user (which is looged in(if previously loggen in) data)
    //And if no user is logged in then we are checking below and showing the creen of login or home accordingly
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AtoZShop',
      theme: ThemeData(
          // useMaterial3: true, //For some better UI

          //For the background color of the scaffold(ie the app background color can say)
          scaffoldBackgroundColor: GlobalVariables.backgroundColor,

          //Change the normal light color (light blue primary color scheme) , which is shown in buttons too(which we want)
          colorScheme: const ColorScheme.light(
            primary: GlobalVariables
                .secondaryColor, //like golden (but it will change the color of everything having primary (light blue) color by default ie the app bar too but we dont want the app bar to have this color (but since we want a gradient to be the color of the app bar so we cant set a gradient as a color in the theme , so we have to do it manually each time we specify an appbar)
          ),
          //Setting the app bar theme:
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(
                color: Colors
                    .black), //the icon in the app bar should always be black(so setting it to a constant black here)
          )),

      //using on generate route property:- (This will run(automatically) whenever a named route like naviagtor.pushNamed is used) and the settings specified in that route will be used here(the name of route specified there will be in settings.name automatically) and passed to the getRoute method which will return a matrialPageRoute
      onGenerateRoute: (settings) => getRoute(settings), //like this

      //If a user is singed in then we will have the users token else not , so if no token is there (will get this token from the init state method above whenever the app starts if a user is signed in) then we will show the auth screen else the bottom nav bar (actual home screen)
      home: Provider.of<UserProvider>(
                  context) //by default listen is true , so listening here for the change when the user is set and then this will ru again
              .user
              .token
              .isNotEmpty
          ? Provider.of<UserProvider>(context).user.type != 'user'
              ? const AdminScreen() //If the user type is not 'user' then it means it is the admin and we will display the admin screen then, else the actual home ie the bottom nav screen with home seleceted by default
              : const BottomNavBar()
          : const AuthScreen(),
    );
  }
}
