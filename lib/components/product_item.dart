import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/my_http_exceptions.dart';
import 'package:shop/models/product.dart';
import 'package:shop/routes/app_routes.dart';

import '../models/product_list.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);

    return ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(product.imageUrl),
        ),
        title: Text(product.name),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.productForm, arguments: product);
                },
                // color: Theme.of(context).colorScheme.primary,
                color: Theme.of(context).primaryColor,
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Excluir Produto'),
                      content: const Text('Tem certeza?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Não'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Sim'),
                        ),
                      ],
                    ),
                  ).then((confirmed) async {
                    if (confirmed ?? false) {
                      try {
                        await Provider.of<ProductList>(
                          context,
                          listen: false,
                        ).removeProduct(product);
                      } on MyHttpException catch (error) {
                        scaffold.showSnackBar(
                          SnackBar(
                            content: Text(error.toString()),
                            backgroundColor: Colors.deepOrangeAccent[400],
                          ),
                        );
                      }
                    }
                  });
                },
                color: Theme.of(context).colorScheme.error,
              ),
            ],
          ),
        ));
  }
}
