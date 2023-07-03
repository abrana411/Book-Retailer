import 'package:flutter/material.dart';

import '../widgets/show_image_slider.dart';
import '../widgets/show_user_address.dart';
import '../widgets/famous_categories.dart';
import '../../search/screens/search_screen.dart';
import '../../../constants/global_variables.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //In the appbar we will be showing a text form field and then a mic icon in a row
        appBar: PreferredSize(
          //using thr preffered size again to give the height to the appb ar
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            elevation: 0,
            //flexible space for giving the gradient
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: GlobalVariables.appBarGradient,
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 42,
                    margin: const EdgeInsets.only(left: 15),
                    child: Material(
                      //A material widget is used for simply providing us with border radius ,(which we could have gotten by wrapping in a container too) and the elevation as we want this container to stand out (which is having thr text field) , and this elevation was not in the container so thats why used this
                      borderRadius: BorderRadius.circular(7),
                      elevation: 1,
                      child: TextFormField(
                        //field for searching some items , and onfieldSubmitted method will call whatever function is given with the serached text into it as an parameter automatically when the user presses enter(or tap done), so we will redirect the user to the search screen in this case
                        onFieldSubmitted: (String searched) {
                          if (searched.isNotEmpty) {
                            Navigator.pushNamed(context, SearchScreen.routeName,
                                arguments: searched);
                          }
                        },
                        decoration: InputDecoration(
                          //inkwell for showing the ripple effect on tapping on the search icon(else there was no use of this, could add the navigaton to search screen on this icon too , but for now it is only happening when the user press enter(or done))
                          prefixIcon: InkWell(
                            onTap: () {},
                            child: const Padding(
                              padding: EdgeInsets.only(
                                left: 6,
                              ),
                              child: Icon(
                                Icons.search,
                                color: Colors.black,
                                size: 23,
                              ),
                            ),
                          ),
                          //some other decoratons
                          filled:
                              true, //if true then the decoration container will have fill color
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.only(top: 10),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(7),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(7),
                            ),
                            borderSide: BorderSide(
                              color: Colors.black38,
                              width: 1,
                            ),
                          ),
                          hintText: 'Search for any product..',
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //for showing the mic button
                Container(
                  color: Colors.transparent,
                  height: 42,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: const Icon(Icons.mic, color: Colors.black, size: 25),
                ),
              ],
            ),
          ),
        ),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              ShowUserAddress(),
              SizedBox(
                height: 10,
              ),
              FamCategories(),
              SizedBox(
                height: 10,
              ),
              ImageSlider(),
              SizedBox(
                height: 10,
              ),
              // DealOfTheDay(),
            ],
          ),
        ));
  }
}
