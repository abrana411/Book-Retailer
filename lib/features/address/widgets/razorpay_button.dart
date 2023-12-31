import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayButton extends StatefulWidget {
  final int totalAmount;
  const RazorpayButton({required this.totalAmount, super.key});

  @override
  State<RazorpayButton> createState() => _RazorpayButtonState();
}

class _RazorpayButtonState extends State<RazorpayButton> {
  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    showAlertDialog(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    showAlertDialog(
        context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        Razorpay razorpay = Razorpay();
        var options = {
          'key': 'rzp_test_zQbYJvBIibImJj',
          'amount': widget.totalAmount, //in the smallest currency sub-unit.
          'currency': 'INR',
          'name': 'NSUT Book Resellers',
          'order_id':
              'order_EMBFqjDHEEn80l', // Generate order_id using Orders API
          'send_sms_hash': true,
          'timeout': 120, // in seconds
          'prefill': {
            'contact': '9599410396',
            'email': 'rishabh.prasad2003@gmail.com'
          }
        };
        razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
        razorpay.on(
            Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
        razorpay.on(
            Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
        razorpay.open(options);
      },
      icon: const Icon(Icons.payment),
      label: const Text('Pay with Razorpay'),
    );
  }
}
