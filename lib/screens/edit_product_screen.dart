import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();

  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var _editedProduct =
      Product(id: '', title: '', description: '', price: 0, imageUrl: '');

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    // adding a listener to focus event -> once the focus changed the _updateImageUrl will be executed
    _imageFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments;

      if (productId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .findById(productId as String);
      }

      // ! important: we cannot assign initialValue while using a controller to the input
      _initValues = {
        'title': _editedProduct.title,
        'description': _editedProduct.description,
        'price': _editedProduct.price.toString(),
        'imageUrl': ''
      };

      _imageUrlController.text = _editedProduct.imageUrl;
    }

    _isInit = false;
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _imageFocusNode.dispose();
    _descriptionFocusNode.dispose();

    _imageUrlController.dispose();
    _imageFocusNode.removeListener(_updateImageUrl);
  }

  void _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();

    setState(() {
      _isLoading = true;
    });

    //edit mode
    if (_editedProduct.id.isNotEmpty) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
    // add mode
    else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        // we added await next to showDialog because we need to wait until the future is resolved (user clicked on ok or took action) to execute the finally block
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('An error occurred!'),
                  content: Text(error.toString()),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Okay'))
                  ],
                ));
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(onPressed: () => _saveForm(), icon: const Icon(Icons.save))
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                children: [
                  TextFormField(
                    initialValue: _initValues['title'],
                    onSaved: (newValue) {
                      _editedProduct = Product(
                          id: _editedProduct.id,
                          title: newValue!.isEmpty ? '' : newValue,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite);
                    },

                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a valid title';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      icon: Icon(Icons.title),
                      labelText: 'Title',
                    ),
                    textInputAction: TextInputAction
                        .next, // this will be the button on the bottom right corner, it can be done, next , new line...
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: _initValues['price'],
                    focusNode: _priceFocusNode,
                    keyboardType: TextInputType.number,
                    onSaved: (newValue) {
                      _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: (newValue!.isNotEmpty &&
                                  double.parse(newValue) > 0)
                              ? double.parse(newValue)
                              : 0,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a valid price';
                      }

                      if (double.tryParse(value) == null) {
                        return 'Enter a valid number';
                      }

                      if (double.parse(value) <= 0) {
                        return 'Enter an amount greater than 0';
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                      icon: Icon(Icons.price_check_sharp),
                      labelText: 'Price',
                    ),
                    textInputAction: TextInputAction
                        .next, // this will be the button on the bottom right corner, it can be done, next , new line...
                    onFieldSubmitted: (value) => FocusScope.of(context)
                        .requestFocus(
                            _descriptionFocusNode), // this is used to set focus on fields when submitting the value
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: _initValues['description'],
                    focusNode: _descriptionFocusNode,
                    onSaved: (newValue) {
                      _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: newValue!.isNotEmpty ? newValue : '',
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a valid description';
                      }

                      if (value.length < 10) {
                        return 'Should be at least 10 characters';
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                      icon: Icon(Icons.description),
                      labelText: 'Description',
                    ),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          decoration:
                              BoxDecoration(border: Border.all(width: 1)),
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(top: 8, right: 10),
                          child: _imageUrlController.text.isEmpty
                              ? const Text('No image selected')
                              : FittedBox(
                                  fit: BoxFit.fill,
                                  child:
                                      Image.network(_imageUrlController.text),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            onSaved: (newValue) {
                              _editedProduct = Product(
                                  id: _editedProduct.id,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  imageUrl: newValue!.isNotEmpty
                                      ? newValue
                                      : _editedProduct.imageUrl,
                                  isFavorite: _editedProduct.isFavorite);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter a valid image url';
                              }

                              if (!value.startsWith('https') &&
                                  !value.startsWith('http')) {
                                return 'Not a valid url';
                              }

                              return null;
                            },
                            onFieldSubmitted: (_) => _saveForm(),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageFocusNode,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.image),
                              labelText: 'Image',
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )),
    );
  }
}
