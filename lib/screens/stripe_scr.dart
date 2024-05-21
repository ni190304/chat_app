import 'package:chat_app/screens/stripe_service.dart';
import 'package:flutter/material.dart';

class Stripe_Checkout extends StatefulWidget {
  const Stripe_Checkout({super.key});

  @override
  State<Stripe_Checkout> createState() => _Stripe_CheckoutState();
}

class _Stripe_CheckoutState extends State<Stripe_Checkout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stripe Checkout',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Unlock Premium Features with BuzzApp at an Unbeatable Price!',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    fontFamily: 'Gramonda',
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Discover the enhanced experience of BuzzApp with our premium features, now available at a minimal price. Upgrade today and enjoy:',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
              ),
              Center(
                child: Text(
                  '1. Accessiblity and Privacy',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'Gramonda',
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Users gain access to higher-grade encryption protocols, such as quantum-resistant algorithms, which provide an additional layer of security beyond standard end-to-end encryption. This ensures that even the most sensitive information remains protected from sophisticated cyber threats. Additionally, features like self-destructing messages allow users to set a timer for messages to automatically delete after being read, reducing the risk of sensitive information being stored on devices. Anonymity options further enhance privacy by allowing users to communicate without revealing their identities, protecting their personal data and reducing the risk of targeted attacks.',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 10,
                  ),
                ),
              ),
              Center(
                child: Text(
                  '2. Expanded multimedia sharing capabilities',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'Gramonda',
                  ),
                ),
              ),
              Center(
                child: Text(
                  'This allows users to send larger files and a broader range of media types, including high-definition videos, large document files, and uncompressed images, without the limitations found in the free version. Enhanced multimedia sharing often comes with advanced editing tools, enabling users to customize photos and videos before sending them. Paid subscribers may also benefit from increased cloud storage, ensuring their important messages and attachments are securely backed up and easily accessible from any device. These capabilities provide a richer, more versatile communication experience, accommodating both personal and professional needs with greater flexibility and convenience.',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 10,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  var items = [
                    {
                      "productPrice": 40,
                      "productName": "Accessiblity and Privacy",
                      "qty": 1
                    },
                    {
                      "productPrice": 60,
                      "productName": "Expanded multimedia sharing capabilities",
                      "qty": 1
                    }
                  ];

                  await StripeService.stripePaymentCheckout(
                      items, 500, context, mounted, onSuccess: () {
                    print("SUCCESS");
                  }, onCancel: () {
                    print("CANCEL");
                  }, onError: (e) {
                    print("Error: ${e.toString()}");
                  });
                },
                style: TextButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(1)),
                    )),
                child: Text('Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
