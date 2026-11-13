import 'package:flutter/material.dart';

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String imageUrl;
  final double rating;
  final int reviewCount;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final ratingMap = json['rating'] as Map<String, dynamic>?;
    return Product(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? 'No Title',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      imageUrl: json['image'] as String? ?? '',
      rating: (ratingMap?['rate'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (ratingMap?['count'] as num?)?.toInt() ?? 0,
    );
  }

  IconData get icon {
    switch (category) {
      case 'electronics':
        return Icons.headphones;
      case 'jewelery':
        return Icons.diamond;
      case "men's clothing":
      case "women's clothing":
        return Icons.checkroom;
      default:
        return Icons.shopping_bag;
    }
  }
}
