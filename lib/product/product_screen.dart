import 'package:flutter/material.dart';
import 'package:flutter_5iw1/home/blocs/home_bloc.dart';
import 'package:flutter_5iw1/product/blocs/product_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductScreen extends StatelessWidget {
  static const String routeName = '/product';

  static Future<dynamic> navigateTo(BuildContext context, {required int id}) async {
    context.read<ProductBloc>().add(ProductDataLoaded(id: id));
    return Navigator.of(context).pushNamed(routeName, arguments: id);
  }

  final int id;

  const ProductScreen({super.key, required this.id});

  Widget _buildRating(BuildContext context, {required double rating}) {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          Icons.star,
          color: index < rating ? Colors.blue : Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        final product = state.product;
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text(product?.title ?? ''),
            ),
            backgroundColor: Colors.white,
            body: Column(
              children: [
                if (state.status == ProductStatus.loading)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                if (state.status == ProductStatus.success && product != null)
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 200,
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${product.price} €',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(product.description),
                              const SizedBox(height: 10),
                              _buildRating(context, rating: product.rating),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: const Text('Click me!'),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
