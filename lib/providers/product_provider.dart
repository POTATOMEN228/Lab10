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
        _products = data.map((json) => Product.fromJson(json)).toList();
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
