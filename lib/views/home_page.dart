import 'package:flutter/material.dart';
import 'package:food_delivery/utils/constants.dart';
import 'package:food_delivery/widgets/icon_button.dart';
import 'package:iconsax/iconsax.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        "What are you\ncooking today?",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                      CustomIconButton(
                        icon: Iconsax.notification,
                        onPressed: () {},
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
