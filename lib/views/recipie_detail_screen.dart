import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/providers/favorite_provider.dart';
import 'package:food_delivery/providers/quantity_provider.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/ui_helpers.dart';
import 'package:food_delivery/widgets/icon_button.dart';
import 'package:food_delivery/widgets/quantity_increment_decrement.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class RecipeDetailScreen extends StatefulWidget {
  final DocumentSnapshot<Object?> documentSnapshot;
  const RecipeDetailScreen({super.key, required this.documentSnapshot});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  @override
  void initState() {
    // initialize base ingredient amounts in the provider
    List<double> baseAmounts = widget.documentSnapshot['ingredientsAmount']
        .map<double>((amount) => double.parse(amount.toString()))
        .toList();
    Provider.of<QuantityProvider>(context, listen: false)
        .setBaseIngredientAmounts(baseAmounts);
    super.initState();
  }

// we have a Spelling mistake that's what we face a error, be carefully, all items name must be same in firebase
  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    final quantityProvider = Provider.of<QuantityProvider>(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: startCookingAndFavoriteButton(provider),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                // for image
                Container(
                  height: MediaQuery.of(context).size.height / 2.1,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        widget.documentSnapshot['image'],
                      ),
                    ),
                  ),
                ),
                // for back button
                Positioned(
                  top: 40,
                  left: 10,
                  right: 10,
                  child: Row(
                    children: [
                      CustomIconButton(
                          icon: Icons.arrow_back_ios_new,
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      const Spacer(),
                      CustomIconButton(
                        icon: Iconsax.notification,
                        onPressed: () {},
                      )
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: MediaQuery.of(context).size.width,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
            // for drag handle
            Center(
              child: Container(
                width: 40,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            verticalSpaceSmall,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.documentSnapshot['name'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  verticalSpaceSmall,
                  Row(
                    children: [
                      const Icon(
                        Iconsax.flash_1,
                        size: 20,
                        color: Colors.grey,
                      ),
                      Text(
                        "${widget.documentSnapshot['cal']} Cal",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const Text(
                        " · ",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.grey,
                        ),
                      ),
                      const Icon(
                        Iconsax.clock,
                        size: 20,
                        color: Colors.grey,
                      ),
                      horizontalSpaceTiny,
                      Text(
                        "${widget.documentSnapshot['time']} Min",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  verticalSpaceSmall,
                  // for rating
                  Row(
                    children: [
                      const Icon(
                        Iconsax.star1,
                        color: Colors.amberAccent,
                      ),
                      horizontalSpaceTiny,
                      Text(
                        widget.documentSnapshot['rating'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text("/5"),
                      horizontalSpaceTiny,
                      Text(
                        "${widget.documentSnapshot['review']} Reviews",
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  verticalSpaceMedium,
                  Row(
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Ingredients",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "How many servings?",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                      const Spacer(),
                      QuantityIncrementDecrement(
                        currentNumber: quantityProvider.currentNumber,
                        onAdd: () => quantityProvider.increaseQuantity(),
                        onRemov: () => quantityProvider.decreaseQuanity(),
                      )
                    ],
                  ),
                  // list of ingredients
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        widget.documentSnapshot['ingredientsName'].length,
                    itemBuilder: (context, index) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // ingredient image
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  widget.documentSnapshot['ingredientsImage']
                                      [index],
                                ),
                              ),
                            ),
                          ),
                          horizontalSpaceMedium,
                          // ingredient name
                          Center(
                            child: Text(
                              widget.documentSnapshot['ingredientsName'][index],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                          const Spacer(),
                          // ingredient amount
                          Center(
                            child: Text(
                              "${quantityProvider.updateIngredientAmounts[index]} g",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 15,
                    ),
                  ),
                 verticalSpaceMassive,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  FloatingActionButton startCookingAndFavoriteButton(
      FavoriteProvider provider) {
    return FloatingActionButton.extended(
      backgroundColor: Colors.transparent,
      elevation: 0,
      onPressed: () {},
      label: Row(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: kprimaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 13),
                foregroundColor: Colors.white),
            onPressed: () {},
            child: const Text(
              "Start Cooking",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            style: IconButton.styleFrom(
              shape: CircleBorder(
                side: BorderSide(
                  color: Colors.grey.shade300,
                  width: 2,
                ),
              ),
            ),
            onPressed: () {
              provider.toggleFavorite(widget.documentSnapshot);
            },
            icon: Icon(
              provider.isExist(widget.documentSnapshot)
                  ? Iconsax.heart5
                  : Iconsax.heart,
              color: provider.isExist(widget.documentSnapshot)
                  ? Colors.red
                  : Colors.black,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
