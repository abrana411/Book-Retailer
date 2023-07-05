import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/order_model.dart';
import '../../../providers/user_provider.dart';
import '../../search/screens/search_screen.dart';
import '../../admin/services/admin_services.dart';
import '../../../constants/global_variables.dart';
import '../../../common/widgets/custom_button.dart';

class OrderDetailsScreen extends StatefulWidget {
  static const String routeName = "/order-details-screen";
  final Order currOrder;
  const OrderDetailsScreen({super.key, required this.currOrder});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  int currentStepInDelivery = 0;
  AdminServices adminServices = AdminServices();
  @override
  void initState() {
    super.initState();
    currentStepInDelivery = widget.currOrder
        .status; //now we have kept this status in indices because the stepper require indices only , so in order to not convert this into the stepper index again and again we have done this
    if (currentStepInDelivery >= 4) {
      currentStepInDelivery = 4;
    }
    // print("Init $currentStepInDelivery");
  }

  void changeStatus() {
    adminServices.changeOrderStatus(
        context: context,
        order: widget.currOrder,
        onSuccess: () {
          setState(() {
            currentStepInDelivery++;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      //Same search appbar as of the home screen and everywhere else
      appBar: PreferredSize(
        //using thr preffered size again to give the height to the appb ar
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
            elevation: 0,
            //flexible space for giving the gradient
            // flexibleSpace: Container(
            //   decoration: const BoxDecoration(
            //     gradient: GlobalVariables.appBarGradient,
            //   ),
            // ),
            title: const Text("Order")),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      height: 42,
                      margin: const EdgeInsets.only(left: 15),
                      child: Material(
                        //A material widget is used for simply providing us with border radius ,(which we could have gotten by wrapping in a container too) and the elevation as we want this container to stand out (which is having thr text field) , and this elevation was not in the container so thats why used this
                        borderRadius: BorderRadius.circular(20),
                        elevation: 1,
                        child: TextFormField(
                          //field for searching some items , and onfieldSubmitted method will call whatever function is given with the serached text into it as an parameter automatically when the user presses enter(or tap done), so we will redirect the user to the search screen in this case
                          onFieldSubmitted: (String searched) {
                            if (searched.isNotEmpty) {
                              Navigator.pushNamed(
                                  context, SearchScreen.routeName,
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
                                Radius.circular(20),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
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
              const SizedBox(
                height: 20,
              ),
              //Showing the order details first ie in a column three text fileds which are nothing but , the date at which the order is created , order id and the total amount of the order
              const Text(
                'Order details',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order Date:      ${DateFormat().format(
                      DateTime.fromMillisecondsSinceEpoch(
                          widget.currOrder.orderedAt),
                    )}'),
                    Text('Order ID:          ${widget.currOrder.id}'),
                    Text(
                        'Order Total:      Rs: ${widget.currOrder.totalPrice}'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              //Showing the purchase details now , ie a row having image and a column with other details of the image , and the image is the product at an index , since we will be showing all the produucts of this order using a for loop
              const Text(
                'Purchase Details',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //getting each product of this order
                    for (int i = 0; i < widget.currOrder.products.length; i++)
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        color: GlobalVariables.greyBackgroundColor,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5, top: 5),
                            child: Row(
                              children: [
                                Image.network(
                                  widget.currOrder.products[i].images[0],
                                  height: 120,
                                  width: 120,
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.currOrder.products[i].name,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        'Qty: ${widget.currOrder.quantity[i]}',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              //For the current status/ tracking part , we will show a stepper in which all the steps are defined
              const Text(
                'Delivery Status',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                child: Stepper(
                  currentStep: currentStepInDelivery,
                  controlsBuilder: (context, details) {
                    if (user.type == 'admin' && currentStepInDelivery <= 3) {
                      // print(currentStepInDelivery);
                      //Then we will give the admin to make this complete by showing a button named done
                      return CustomButton(
                        onTap: () {
                          changeStatus();
                        },
                        toShow: "Done",
                      );
                    }
                    //no option to change the ststus in case the user is not admin
                    return const SizedBox();
                  },
                  steps: [
                    //First step is pending:
                    Step(
                      title: const Text('Pending'),
                      //below content will be shown if this has completed
                      content: const Text(
                        'Your order is being prepared for shipping!',
                      ),
                      //This step will be completed only when the status is > 0 , no matter if it is 1,2,3 , but then this step will be complete , so we will show the active mark only when this is complete which will be when ststus > 0
                      isActive: currentStepInDelivery > 0,

                      //if not active then indexed ie 1,2,3,4 step will be shown and if complete ie >0 then tick (complete pe tick aata hai) will be shown
                      state: currentStepInDelivery > 0
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    //Same for all the other steps:-
                    //0(pending) ,1(shipped) , 2(delivered) , 3(done)
                    Step(
                      title: const Text('Shipped'),
                      content: const Text(
                        'Your order has been Shipped from the store!',
                      ),
                      isActive: currentStepInDelivery > 1,
                      state: currentStepInDelivery > 1
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                      title: const Text('Received'),
                      content: const Text(
                        'Order has been received by you!',
                      ),
                      isActive: currentStepInDelivery > 2,
                      state: currentStepInDelivery > 2
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                      title: const Text('Done'),
                      content: const Text(
                        'Order has been collected and verified by you! Thank you for shopping with us',
                      ),
                      isActive: currentStepInDelivery >= 3,
                      state: currentStepInDelivery >= 3
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                        title: const Text("Completed"),
                        content: const Text("Success"),
                        isActive: currentStepInDelivery > 3,
                        state: StepState.complete)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
