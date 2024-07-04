import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:razorpay_integration/utils/api_key.dart';

class RazorPayPage extends StatefulWidget {
  const RazorPayPage({super.key});

  @override
  State<RazorPayPage> createState() => _RazorPayPageState();
}

class _RazorPayPageState extends State<RazorPayPage> {
  late Razorpay _razorpay;
  TextEditingController amtController = TextEditingController();

  void openCheckOut(amount) async {
    amount = amount * 100;
    var options = {
      'key': apiKey,
      'amount': amount,
      'name': 'Testing RazorPay',
      'prefill': {'contact': "123456789", 'email': 'test123@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "Payment Successfull${response.paymentId!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "Payment Failure${response.message!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "External Wallet${response.walletName!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RazorPay Payment Gateway'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              const Text(
                'Welcome to RayzorPay Payment Gateway',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 45,
              ),
              TextFormField(
                cursorColor: Colors.white,
                autofocus: false,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Enter the amount to be paid',
                  labelStyle: TextStyle(fontSize: 15),
                  border:
                      OutlineInputBorder(borderSide: BorderSide(width: 1.0)),
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide(width: 1.0)),
                  errorStyle: TextStyle(color: Colors.red, fontSize: 15),
                ),
                controller: amtController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the amount to be paid';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 45,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (amtController.text.toString().isNotEmpty) {
                      setState(() {
                        int amount = int.parse(amtController.text.toString());
                        openCheckOut(amount);
                      });
                    }
                  },
                  child: const Text('Proceed to payment'))
            ],
          ),
        ),
      ),
    );
  }
}
