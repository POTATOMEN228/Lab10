import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  static final List<Map<String, dynamic>> _graphicTabletsData = [
    {
      'id': 1,
      'title': 'Wacom Cintiq 16 Drawing Tablet',
      'price': 649.95,
      'description': 'Creative pen display with 1920x1080 HD resolution, Pro Pen 2 with 8192 pressure levels, and vibrant color accuracy for digital artists and illustrators.',
      'category': 'Pen Display',
      'image': 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=600&auto=format&fit=crop&q=80',
      'rating': {'rate': 4.8, 'count': 340}
    },
    {
      'id': 2,
      'title': 'Huion Kamvas Pro 16 2.5K',
      'price': 599.00,
      'description': '2.5K QHD drawing monitor with QLED screen, PW517 battery-free stylus, full lamination, and anti-glare etched glass for seamless digital painting.',
      'category': 'Pen Display',
      'image': 'https://images.unsplash.com/photo-1585776245991-cf89dd7fc73a?w=600&auto=format&fit=crop&q=80',
      'rating': {'rate': 4.7, 'count': 210}
    },
    {
      'id': 3,
      'title': 'XPPen Artist 15.6 Pro Digital Drawing Pad',
      'price': 399.99,
      'description': 'Featuring 8192 pressure sensitivity, 60 degrees tilt function, 8 shortcut keys, and Red Dial controller interface for fast art workflows.',
      'category': 'Pen Display',
      'image': 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=600&auto=format&fit=crop&q=80',
      'rating': {'rate': 4.6, 'count': 185}
    },
    {
      'id': 4,
      'title': 'Wacom Intuos Pro Medium Graphics Tablet',
      'price': 379.95,
      'description': 'Professional Bluetooth graphic tablet for digital drawing, photo editing, and 3D sculpting with multi-touch gestures and express keys.',
      'category': 'Graphics Tablet',
      'image': 'https://images.unsplash.com/photo-1526738549149-8e07eca6c147?w=600&auto=format&fit=crop&q=80',
      'rating': {'rate': 4.9, 'count': 512}
    },
    {
      'id': 5,
      'title': 'GAOMON PD1560 15.6 Inch Pen Display',
      'price': 319.99,
      'description': 'Full HD IPS drawing screen with 10 express keys, battery-free pen, 178° viewing angle, and adjustable stand for digital illustration and animation.',
      'category': 'Drawing Tablet',
      'image': 'https://images.unsplash.com/photo-1513542789411-b6a5d4f31634?w=600&auto=format&fit=crop&q=80',
      'rating': {'rate': 4.5, 'count': 128}
    },
    {
      'id': 6,
      'title': 'VEIKK VK1200 11.6 Inch Drawing Monitor',
      'price': 219.99,
      'description': 'Portable anti-glare drawing tablet with 6 shortcut keys, full-laminated screen, tilt support, and lightweight aluminum body for sketching on the go.',
      'category': 'Drawing Tablet',
      'image': 'https://images.unsplash.com/photo-1563089145-599997674d42?w=600&auto=format&fit=crop&q=80',
      'rating': {'rate': 4.4, 'count': 94}
    },
  ];

  ProductProvider() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http
          .get(Uri.parse('https://fakestoreapi.com/products'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _products = List.generate(data.length > 6 ? 6 : data.length, (index) {
          final tabletData = _graphicTabletsData[index % _graphicTabletsData.length];
          return Product.fromJson(tabletData);
        });
        _errorMessage = null;
      } else if (response.statusCode == 404) {
        _errorMessage = 'Error 404: Endpoint not found.';
      } else if (response.statusCode >= 500) {
        _errorMessage = 'Server error (${response.statusCode}). Please try again later.';
      } else {
        _errorMessage = 'Failed to load products (Status: ${response.statusCode})';
      }
    } on TimeoutException {
      _errorMessage = 'Connection timed out. Please check your internet connection.';
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshProducts() async {
    await fetchProducts();
  }
}
