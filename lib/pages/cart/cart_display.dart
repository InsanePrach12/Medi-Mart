import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medi_mart/pages/cart/cart_model.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartService = CartService.fromAuth();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white24,
        title: Text("My Cart",
        style: TextStyle(
          fontSize:30,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade300
        ),),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: cartService.getCartItems(),
        builder: (context, snapshot) {
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle error state
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            );
          }

          // Handle empty cart
          final cartDocs = snapshot.data?.docs ?? [];
          if (cartDocs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, 
                       size: 100, 
                       color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text("Your cart is empty",
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      backgroundColor: Colors.blue.shade300,
                    ),
                    child: const Text("Continue Shopping",
                        style: TextStyle(fontSize: 16,
                        color: Colors.white)),
                  ),
                ],
              ),
            );
          }

          // Display cart items
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: cartDocs.length,
            itemBuilder: (context, index) {
              final item = cartDocs[index].data() as Map<String, dynamic>;
              final itemId = cartDocs[index].id;
              final quantity = item["Quantity"] ?? 1;
              final price = item["Price"] ?? 0;

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                color: Colors.white,
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image .network(
                      item["Imageurl"] ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 50);
                      },
                    ),
                  ),
                  title: Text(
                    item["Name"] ?? "Unknown Item",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Price: ৳${price.toString()} x $quantity",
                    style: const TextStyle(color: Colors.green),
                  ),
                  trailing: SizedBox(
                    width: 130,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle),
                          color: Colors.red,
                          onPressed: () => cartService.updateQuantity(itemId, -1),
                        ),
                        Text(
                          quantity.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle),
                          color: Colors.green,
                          onPressed: () => cartService.updateQuantity(itemId, 1),
                        ),
                        IconButton(onPressed: ()=> cartService.clearCart(itemId), icon: const Icon(Icons.delete, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: StreamBuilder<QuerySnapshot>(
        stream: cartService.getCartItems(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const SizedBox.shrink();
          }

          double total = 0;
          for (var doc in snapshot.data!.docs) {
            final item = doc.data() as Map<String, dynamic>;
            total += (item["Price"] ?? 0) * (item["Quantity"] ?? 1);
          }

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Total Amount",
                        style: TextStyle(color: Colors.grey)),
                    Text(
                      "৳${total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Checkout coming soon!")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text("Checkout"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
