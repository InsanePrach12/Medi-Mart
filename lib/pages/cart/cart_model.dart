// lib/services/cart_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartService {
  final String userId;
  final CollectionReference cartCollection;

  CartService(this.userId) : cartCollection = FirebaseFirestore.instance.collection('carts');

  /// Factory constructor to auto-use the logged-in user
  factory CartService.fromAuth() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Must be logged in to access cart');
    return CartService(user.uid);
  }

  Stream<QuerySnapshot> getCartItems() {
    return cartCollection
        .doc(userId)
        .collection('items')
        .snapshots();
  }

  Future<void> addToCart(Map<String, dynamic> product) async {
    final cartItemRef = cartCollection
        .doc(userId)
        .collection('items')
        .doc(product['ProductId']);

    final cartItem = await cartItemRef.get();

    if (cartItem.exists) {
      // Update quantity if item exists
      await cartItemRef.update({
        'Quantity': (cartItem.data()?['Quantity'] ?? 0) + 1,
      });
    } else {
      // Add new item with quantity 1
      await cartItemRef.set({
        ...product,
        'Quantity': 1,
        'AddedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> updateQuantity(String itemId, int change) async {
    final cartItemRef = cartCollection
        .doc(userId)
        .collection('items')
        .doc(itemId);

    final cartItem = await cartItemRef.get();
    if (!cartItem.exists) return;

    final currentQuantity = cartItem.data()?['Quantity'] ?? 0;
    final newQuantity = currentQuantity + change;

    if (newQuantity <= 0) {
      await cartItemRef.delete();
    } else {
      await cartItemRef.update({'Quantity': newQuantity});
    }
  }
}
