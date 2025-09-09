import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medi_mart/pages/cart/cart_model.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("Categories").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No categories yet"));
        }

        var categories = snapshot.data!.docs;

        return Column(
          children: categories.map((category) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category title
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      category['Name'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 180,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Products")
                          .where('CategoryId', isEqualTo: category.id)
                          .snapshots(),
                      builder: (context, productSnapshot) {
                        if (!productSnapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        var products = productSnapshot.data!.docs;

                        if (products.isEmpty) {
                          return const Center(child: Text("No products yet"));
                        }

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: products.length,
                          itemBuilder: (context, i) {
                            var product = products[i];

                            return Container(
                              width: 150,
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 5,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                // Product image
                                if (product['Imageurl'] != null) Image.network(
                                        product['Imageurl'].trim(),
                                        height: 80,
                                        fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                          print('Error loading image: $error');
                                          return const Icon(Icons.broken_image, size: 80);
                                          },
                                      ) else const Icon(Icons.image, size: 80),
                                  Text(
                                    product['Name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "৳${product['Price']}",
                                    style:
                                        const TextStyle(color: Colors.green),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final cart=CartService.fromAuth();
                                      await cart.addToCart({
                                        "ProductId": product.id,
                                        "Name": product['Name'],
                                        "Price": product['Price'],
                                        "Imageurl": product['Imageurl'],
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('${product['Name']} added to cart'),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text("Add to Cart",
                                    style: TextStyle(
                                      color: Colors.white
                                    ),),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
