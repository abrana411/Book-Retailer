import 'package:flutter/material.dart';

import '../screens/category_screen.dart';
import '../../../constants/global_variables.dart';

class FamCategories extends StatelessWidget {
  const FamCategories({super.key});

  //Function to navigate to a seperate category page:-
  void navigateToCatScreen(BuildContext context, String category) {
    Navigator.pushNamed(context, SingleCategoryScreen.routeName,
        arguments: category); //this is how we can pass in the srgument
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.only(left: 10, top: 10),
      child: ListView.builder(
          itemCount: GlobalVariables.categoryImages.length,
          scrollDirection: Axis.horizontal,
          itemExtent:
              80, //the amount of width (if direction is horizontal) a single itme will take and only then the next will be seen
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                navigateToCatScreen(
                    context, GlobalVariables.categoryImages[index]['title']!);
              },
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        GlobalVariables.categoryImages[index]['image']!,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
                  Text(
                    GlobalVariables.categoryImages[index]['title']!,
                    style: const TextStyle(fontSize: 13),
                  )
                ],
              ),
            );
          }),
    );
  }
}
