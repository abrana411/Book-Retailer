import 'package:flutter/material.dart';
// import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

import '../widgets/razorpay_button.dart';
import '../services/address_services.dart';
import '../../../providers/user_provider.dart';
import '../../../constants/show_snack_bar.dart';
import '../../../constants/global_variables.dart';
import '../../../common/widgets/custom_textformfield.dart';

class AddressScreen extends StatefulWidget {
  static const routeName = "/address-screen";
  final String totalAmountToPay;
  const AddressScreen({super.key, required this.totalAmountToPay});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  AddressServices addressServices = AddressServices();
  TextEditingController flatBuildingController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController userCityController = TextEditingController();
  final _AddressFormKey = GlobalKey<FormState>();
  // final Future<PaymentConfiguration> _googlePayConfigFuture =
  //     PaymentConfiguration.fromAsset('gpay.json');
  // final List<PaymentItem> _paymentItems = [];

  //Address to use:-
  String addressToUse = "";

  @override
  void initState() {
    super.initState();
    // _paymentItems.add(
    //   PaymentItem(
    //       amount: widget.totalAmountToPay,
    //       label: "Total Amount",
    //       status: PaymentItemStatus.final_price),
    // );
  }

  //Disposing the controllers:-
  @override
  void dispose() {
    super.dispose();
    flatBuildingController.dispose();
    areaController.dispose();
    pinCodeController.dispose();
    userCityController.dispose();
  }

  //Validate which address to use (The users or the newly entered one)
  void whichAddressToUse(
      String userCurrentAddress) //passing the providers address to it
  {
    addressToUse = "";
    //If any of the below fields is entered then it means that the user is adding new address so validate the form then
    bool isNewAddressWritten = flatBuildingController.text.isNotEmpty ||
        areaController.text.isNotEmpty ||
        pinCodeController.text.isNotEmpty ||
        userCityController.text.isNotEmpty;
    if (isNewAddressWritten) {
      if (_AddressFormKey.currentState!.validate()) {
        //then giving the new error by concatenating all the fields
        addressToUse =
            '${flatBuildingController.text}, ${areaController.text}, ${userCityController.text} - ${pinCodeController.text}';
        // onGooglePayResult(
        //     ""); //for testing here since we can tuse gpay without actual gpay account and card
        throw Exception("Enter all values of the fields");
      } else {
        throw Exception("Enter all values of the fields");
      }
    } else {
      //then check if the user has any password saved before:
      if (userCurrentAddress.isNotEmpty) {
        //then we will use this
        addressToUse = userCurrentAddress;
        //Below for testing
        // onGooglePayResult("");
        throw Exception("Enter all values of the fields");
      } else {
        //Show an error:-
        ShowSnackBar(context: context, text: "Error", color: Colors.red);
        throw Exception("No address is saved");
      }
    }
  }

  //After paying when we got the result:- (Then we have to create API to update myOrders) (Below function will run only when the payment was successfull)
  // void onGooglePayResult(res) {
  //   if (Provider.of<UserProvider>(context, listen: false)
  //       .user
  //       .address
  //       .isEmpty) {
  //     addressServices.addUserAddress(
  //         context: context, addressToAdd: addressToUse);
  //   }

  //   addressServices.PlaceanOrder(
  //       context: context,
  //       addressToAdd: addressToUse,
  //       totalPrice: double.parse(widget.totalAmountToPay));
  // }

  @override
  Widget build(BuildContext context) {
    final currUser = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: const Text(
            "Shipping Address",
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            //If the address is not empty then we will show that in a bordered container too
            if (currUser.address.isNotEmpty)
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black12.withOpacity(0.06),
                      border: Border.all(
                        color: Colors.black12,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        currUser.address,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Or',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  const Text(
                    " Send To New Address",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            //Else the user can also fill new address using the below form (the form is similar to what we created in the auth screen)
            Container(
              color: Colors.black12.withOpacity(0.06),
              padding: const EdgeInsets.all(7),
              child: Form(
                key: _AddressFormKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      mycontroller: flatBuildingController,
                      hinttxt: 'Flat, House no, Building',
                    ),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      mycontroller: areaController,
                      hinttxt: 'Area, Street',
                    ),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      mycontroller: pinCodeController,
                      hinttxt: 'Pincode',
                    ),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      mycontroller: userCityController,
                      hinttxt: 'Town/City',
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            RazorpayButton(totalAmount: int.parse(widget.totalAmountToPay)),

            // FutureBuilder<PaymentConfiguration>(
            //     future: _googlePayConfigFuture,
            //     builder: (context, snapshot) => snapshot.hasData
            //         ? GooglePayButton(
            //             onPressed: () {
            //               whichAddressToUse(currUser.address);
            //             },
            //             paymentConfiguration: snapshot.data!,
            //             paymentItems: _paymentItems,
            //             type: GooglePayButtonType.buy,
            //             margin: const EdgeInsets.only(top: 15.0),
            //             onPaymentResult: onGooglePayResult,
            //             loadingIndicator: const Center(
            //               child: CircularProgressIndicator(),
            //             ),
            //           )
            //         : const SizedBox.shrink()),
          ]),
        ),
      ),
    );
  }
}
