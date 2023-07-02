import 'package:a_to_z_shop/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowUserAddress extends StatelessWidget {
  const ShowUserAddress({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;
    return Container(
      height: 45,
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromARGB(255, 114, 226, 221),
        Color.fromARGB(255, 162, 236, 233),
      ], stops: [
        0.5,
        1.0
      ])),
      child: Row(
        children: [
          const Icon(
            Icons.location_on_rounded,
            // color: Colors.black,
          ),
          const SizedBox(
            width: 10,
          ),
          //Now we want to show the Delivery to (name of the user) - Users current selected address (and this can overflow , so to make the text appear like ... or anything like that we have to wrap that into expanded widget) and then in the text widget itself we will have overlfow property which we will set to ellipses , could set to fade too if we want the text to fade away
          Expanded(
            child: Text(
              "Delivery to ${currentUser.name} -- ${currentUser.address}",
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          //Show the drop down icon which the user can tap to see the complete address in case it is fading away or ...
          const Padding(
            padding: EdgeInsets.only(
              left: 5,
              top: 2,
            ),
            child: Icon(
              Icons.arrow_drop_down_outlined,
              size: 22,
            ),
          )
        ],
      ),
    );
  }
}
