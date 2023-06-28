import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          title: const Text("About Us"),
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              Text(
                'Welcome to Pulse Music, a revolutionary new way to the working of the app. We\'re passionate about helping people to listen the music which they.\n\n'
                'Our team of developers, designers, and product experts have worked tirelessly to create an app that\'s both user-friendly and packed with useful features. Our mission is to provide an easy-to-use platform that helps you listen the music you love most.\n\n'
                'We understand that solve the problem to identify the songs which you like, and we wanted to create an app that could help you solve it. That\'s why we\'ve designed [Your App Name] to be intuitive and user-friendly, so you can get started right away.\n\n'
                'We believe in providing excellent customer support, and our team is always here to help if you have any questions or run into any issues. We value your feedback, and we\'re constantly working to improve our app based on your suggestions.\n\n'
                'Thank you for choosing Pulse Music. We hope you enjoy using our app and that it helps you [insert the main goal or benefit of your app] in your daily life.',
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ));
  }
}
