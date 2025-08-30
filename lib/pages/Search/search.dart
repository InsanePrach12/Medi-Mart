import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medi_mart/pages/cart/cart_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = ""; // what user types

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 20,
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title:       
            SizedBox(
              height: 50,
              child: CupertinoSearchTextField(
                placeholder: "Search products...",
                onChanged: (value) {
                  setState(() {
                    query = value.trim().toLowerCase();
                  });
                },
              ),
            ),
            actions: [
            IconButton(onPressed: (){
            Navigator.pushNamed(context, "/cart");
          }, icon: Icon(Icons.shopping_cart,
          color: Colors.black54,
          size: 30,))
            ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Products")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
        
                  final data = snapshot.data!.docs;
                  final results = data.where((doc) {
                    final name = doc["Name"].toString().toLowerCase();
                    return name.contains(query);
                  }).toList();
        
                  if (results.isEmpty) {
                    return const Center(child: Text("No results found"));
                  }
        
                  return ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final product = results[index];
                      return ListTile(
                        leading: (product['Imageurl'] != null)
                            ? Image.network(
                                product['Imageurl'].trim(),
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  print('Error loading image: $error');
                                  return const Icon(Icons.broken_image, size: 50);
                                },
                              )
                            : const Icon(Icons.image, size: 50),
                        title: Text(product["Name"],
                        style: const TextStyle(fontWeight: FontWeight.bold),),
                        subtitle: Text("Price: ${product["Price"]}"),
                        trailing:ElevatedButton(
                                    
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
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
