import 'package:flutter/material.dart';

// Product Model
class Product {
  final String name;
  final String description;
  final int price;
  final String image;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });
}

// Home Page
class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final List<Product> products = [
    Product(
      name: "Laptop",
      description: "High performance laptop",
      price: 1200,
      image: "assets/appimages/laptop.png",
    ),
    Product(
      name: "Smartphone",
      description: "Latest model smartphone",
      price: 800,
      image: "assets/appimages/smartphone.png",
    ),
    Product(
      name: "Headphones",
      description: "Noise cancelling headphones",
      price: 150,
      image: "assets/appimages/headphones.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Listing")),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductBox(
            name: product.name,
            description: product.description,
            price: product.price,
            image: product.image,
          );
        },
      ),
    );
  }
}

// ProductBox Widget
class ProductBox extends StatelessWidget {
  const ProductBox({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  final String name;
  final String description;
  final int price;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      height: 120,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              padding: const EdgeInsets.all(8),
              child: Image.asset(image, fit: BoxFit.contain),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      description,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Text(
                      "\$ $price",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
