import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../models/product.dart';

import '../shared/dialog_utils.dart';

import 'products_manager.dart';

import 'package:intl/intl.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  EditProductScreen (
    Product? product, {
      super.key,
    }) {
      if(product==null) {
        this.product = Product (
          id: null,
          title: '',
          price: 0,
          description: '',
          imageUrl: '',
        );
      } else {
        this.product = product;
      }
    }
    
    late final Product product;

    @override
    State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _editForm = GlobalKey<FormState>();
  late Product _editedProduct;
  var _isLoading = false;

  bool _isValidImageUrl(String value) {
    return (value.startsWith('http') || value.startsWith('https')) &&
      (value.endsWith('.png') ||
        value.endsWith('.jpg') ||
        value.endsWith('.jpeg'));
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(() {
      if(!_imageUrlFocusNode.hasFocus) {
        if(!_isValidImageUrl(_imageUrlController.text)) {
          return ;
        }
        setState(() {});
      }
    });
    _editedProduct = widget.product;
    _imageUrlController.text = _editedProduct.imageUrl;
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _editForm.currentState!.validate();
    if(!isValid) {
      return ;
    }
    _editForm.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      final productsManager = context.read<ProductsManager>();
      if(_editedProduct.id != null){
        await productsManager.updateProduct(_editedProduct);
      } else {
        await productsManager.addProduct(_editedProduct);
      } 
    }catch (error){
        if(mounted) {
          await showErrorDialog(context, "Something went wrong.");
        }
      }

    setState(() {
      _isLoading = false;
    });

    if(mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông Tin Sản Phẩm'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save_outlined),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
        )
        : Padding (
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _editForm,
              child: ListView(
                children: <Widget>[
                  _buildProductPreview(),
                  _buildTitleField(),
                  _buildPriceField(),
                  _buildDescriptionField(),
                  
                ],
              ),
            ),
        )
    );
  }

Widget _buildProductPreview () {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Center(
        child: Container (
          width: 170, 
          height: 170, 
          margin: const EdgeInsets.only(top: 8, bottom: 8),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(15),
          ),
          child: _imageUrlController.text.isEmpty
            ? const Text ('Nhập URL')
            : ClipRRect( // Sử dụng ClipRRect để áp dụng bo góc cho hình ảnh
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                _imageUrlController.text,
                fit: BoxFit.cover,
              ),
            ),
        ),
      ),
      _buildImageURLField(),
    ],
  );
}

  TextFormField _buildTitleField () {
    return TextFormField(
      initialValue: _editedProduct.title,
      decoration: const InputDecoration(labelText: 'Tên Sản Phẩm'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if(value!.isEmpty) {
          return 'Hãy cung cấp thông tin.';
        }
        return null;
      },
      onSaved: (value) {
        _editedProduct = _editedProduct.copyWith(title: value);
      },
    );
  }


TextFormField _buildPriceField() {
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  return TextFormField(
    initialValue: _editedProduct.price != null ? currencyFormat.format(_editedProduct.price) : '',
    decoration: const InputDecoration(labelText: 'Giá'),
    textInputAction: TextInputAction.next,
    keyboardType: TextInputType.number,
    validator: (value) {
      if (value!.isEmpty) {
        return 'Hãy nhập giá sản phẩm.';
      }
      if (double.tryParse(value) == null) {
        return 'Hãy điền con số hợp lệ';
      }
      if (double.parse(value) <= 0) {
        return 'Hãy điền con số lớn hơn 0';
      }
      return null;
    },
    onSaved: (value) {
      _editedProduct = _editedProduct.copyWith(price: double.parse(value!));
    },
  );
}


  TextFormField _buildDescriptionField () {
    return TextFormField(
      initialValue: _editedProduct.description,
      decoration: const InputDecoration(labelText: 'Mô tả'),
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      validator: (value) {
        if(value!.isEmpty) {
          return 'Hãy nhập mô tả sản phẩm';
        }
        if(value.length < 10) {
          return 'Nên có ít nhất 10 ký tự';
        }
        return null;
      },

      onSaved: (value) {
        _editedProduct = _editedProduct.copyWith(description: value);
      },
    );
  }

  TextFormField _buildImageURLField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'URL Hình Ảnh'),
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.done,
      controller: _imageUrlController,
      focusNode: _imageUrlFocusNode,
      onFieldSubmitted: (vale) => _saveForm(),
      validator: (value) {
        if(value!.isEmpty) {
          return 'Hãy nhập URL cho hình ảnh sản phẩm';
        }
        if(!_isValidImageUrl(value)) {
          return 'Hãy nhập URL hợp lệ';
        }
        return null;
      },
      onSaved: (value) {
        _editedProduct = _editedProduct.copyWith(imageUrl: value);
      },
    );
  }
}