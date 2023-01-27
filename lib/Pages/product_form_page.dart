import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product_list.dart';

import '../models/product.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  // controla o focus do input
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  // acessa o valor do input
  final _imageUrlController = TextEditingController();
  // acessa o estado do form
  final _formKey = GlobalKey<FormState>();
  // armazena o estado do form
  final Map<String, Object> _formData = {};

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg != null) {
        final product = arg as Product;

        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;

        // carrega aqui tbm para mudar o estado e mostrar a imagem
        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.removeListener(updateImageUrl);
    _imageUrlFocus.dispose();
  }

  void updateImageUrl() {
    if (!_imageUrlFocus.hasFocus) {
      setState(() {});
    }
  }

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.isAbsolute ?? false;
    bool endsWithFile =
        url.toLowerCase().endsWith('.png') || url.toLowerCase().endsWith('.jpg') || url.toLowerCase().endsWith('.jpeg');

    return isValidUrl && endsWithFile;
  }

  void submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    _formKey.currentState?.save();

    Provider.of<ProductList>(context, listen: false).saveProduct(_formData);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Produto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: submitForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _formData['name']?.toString(),
                decoration: const InputDecoration(labelText: 'Nome'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_priceFocus),
                onSaved: (value) => _formData['name'] = value ?? '',
                validator: (value) {
                  final String name = value ?? '';
                  if (name.trim().isEmpty) return 'Informe um nome válido';
                  if (name.trim().length < 3) return 'Informe um nome com mais de 3 caracteres';
                  return null;
                },
              ),
              TextFormField(
                initialValue: _formData['price']?.toString(),
                decoration: const InputDecoration(labelText: 'Preço'),
                textInputAction: TextInputAction.next,
                // keyboardType: TextInputType.number, // Android somente
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                focusNode: _priceFocus,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_descriptionFocus),
                onSaved: (value) => _formData['price'] = double.parse(value ?? '0'),
                validator: (value) {
                  final double? newPrice = double.tryParse(value ?? '0');
                  if (newPrice == null) return 'Informe um preço válido';
                  if (newPrice <= 0) return 'Informe um preço maior que 0';

                  return null;
                },
              ),
              TextFormField(
                initialValue: _formData['description']?.toString(),
                decoration: const InputDecoration(labelText: 'Descrição'),
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocus,
                maxLines: 3,
                onSaved: (value) => _formData['description'] = value ?? '',
                validator: (value) => value?.trim().isEmpty ?? true ? 'Descrição é obrigatório.' : null,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'URL da Imagem'),
                      textInputAction: TextInputAction.done,
                      focusNode: _imageUrlFocus,
                      keyboardType: TextInputType.url,
                      controller: _imageUrlController,
                      onFieldSubmitted: (_) => submitForm(),
                      onSaved: (value) => _formData['imageUrl'] = value ?? '',
                      validator: (value) => isValidImageUrl(value ?? '') ? null : 'Informe uma URL válida',
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.only(top: 8, left: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1),
                      // borderRadius: BorderRadius.circular(100),
                    ),
                    alignment: Alignment.center,
                    child: _imageUrlController.text.isEmpty
                        ? Text('Imagem')
                        : SizedBox(
                            width: 100,
                            height: 100,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Image.network(_imageUrlController.text),
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
