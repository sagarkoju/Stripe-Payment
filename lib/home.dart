// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe/payment.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool hasDonated = false;

  Future<void> stripeMakePayment() async {
    try {
      // 1. create payment intent on the client side by calling stripe api
      final data = await createPaymentIntent(
        // convert string to double
        200.toString(),
        "npr",
      );
      print("ttttttttttt${data.toString()}");

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: 'Test Merchant',
          paymentIntentClientSecret: data['client_secret'],
          // Customer keys
          // customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['id'],
          billingDetails: const BillingDetails(
              name: 'YOUR NAME',
              email: 'YOUREMAIL@gmail.com',
              phone: 'YOUR NUMBER',
              address: Address(
                  city: 'YOUR CITY',
                  country: 'YOUR COUNTRY',
                  line1: 'YOUR ADDRESS 1',
                  line2: 'YOUR ADDRESS 2',
                  postalCode: 'YOUR PINCODE',
                  state: 'YOUR STATE')),
          //Go
          style: ThemeMode.dark,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent.shade400),
                        child: const Text(
                          "Proceed to Pay",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        onPressed: () async {
                          await stripeMakePayment();
                          await Stripe.instance.presentPaymentSheet();
                          // try {
                          //   await Stripe.instance.presentPaymentSheet();

                          //   ScaffoldMessenger.of(context)
                          //       .showSnackBar(const SnackBar(
                          //     content: Text(
                          //       "Payment Done",
                          //       style: TextStyle(color: Colors.white),
                          //     ),
                          //     backgroundColor: Colors.green,
                          //   ));

                          //   setState(() {
                          //     hasDonated = true;
                          //   });
                          //   nameController.clear();
                          //   addressController.clear();
                          //   cityController.clear();
                          //   stateController.clear();
                          //   countryController.clear();
                          //   pincodeController.clear();
                          // } catch (e) {
                          //   if (kDebugMode) {
                          //     print("payment sheet failed");
                          //   }
                          //   ScaffoldMessenger.of(context)
                          //       .showSnackBar(const SnackBar(
                          //     content: Text(
                          //       "Payment Failed",
                          //       style: TextStyle(color: Colors.white),
                          //     ),
                          //     backgroundColor: Colors.redAccent,
                          //   ));
                          // }
                        },
                      ),
                    )
                  ])),
        ],
      ),
    );
  }
}
