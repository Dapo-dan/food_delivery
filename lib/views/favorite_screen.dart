import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/providers/favorite_provider.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/image_path.dart';
import 'package:food_delivery/utils/ui_helpers.dart';
import 'package:food_delivery/widgets/shimmer_list_widget.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    final favoriteItems = provider.favorites;

    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        backgroundColor: kbackgroundColor,
        centerTitle: true,
        title: const Text(
          "Favorites",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: favoriteItems.isEmpty
          ? const Center(
              child: Text(
                "No Favorites yet",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ListView.builder(
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                String favorite = favoriteItems[index];
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("Food-delivery")
                      .doc(favorite)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const ShimmerLoadingList(
                        count: 5,
                      );
                    }
                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(
                        child: Text("Error loading favorites"),
                      );
                    }
                    var favoriteItem = snapshot.data!;
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 80,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            width: 100,
                                            height: 80,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: FadeInImage.assetNetwork(
                                          placeholder: ImagePath.empty,
                                          image: favoriteItem['image'],
                                          fit: BoxFit.cover,
                                          width: 100,
                                          height: 80,
                                          imageErrorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              width: 100,
                                              height: 80,
                                              color: Colors.grey,
                                              child: const Icon(Icons.error,
                                                  color: Colors.red),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                horizontalSpaceSmall,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      favoriteItem['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    verticalSpaceTiny,
                                    Row(
                                      children: [
                                        const Icon(
                                          Iconsax.flash_1,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          "${favoriteItem['cal']} Cal",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
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
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        horizontalSpaceTiny,
                                        Text(
                                          "${favoriteItem['time']} Min",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        // for delete button
                        Positioned(
                          top: 50,
                          right: 35,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                provider.toggleFavorite(favoriteItem);
                              });
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 25,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
    );
  }
}
