import 'package:flutter/material.dart';
import 'package:flutter_simple_shopify/flutter_simple_shopify.dart';
import 'package:flutter_simple_shopify/models/src/product/product_variant/product_variant.dart';
import 'package:collection/collection.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key, required this.productHandle})
      : super(key: key);
  final String productHandle;

  @override
  _ProductDetailScreenState createState() =>
      _ProductDetailScreenState(productHandle);
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  _ProductDetailScreenState(this.productHandle);
  final String productHandle;
  Product? product;
  String? checkoutId;
  String? checkoutUrl;
  List<LineItem> lineItems = [];

  @override
  void initState() {
    super.initState();
    _fetchProduct();
  }

  Future<void> _fetchProduct() async {
    final shopifyStore = ShopifyStore.instance;
    final collections = await shopifyStore.getProductByHandle(productHandle);
    if (mounted) {
      setState(() {
        this.product = collections;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = this.product;
    if (product == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: ListView(
        children: <Widget>[
          product.images.firstOrNull?.originalSrc != null
              ? Image.network(
                  product.images.first.originalSrc,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3,
                  fit: BoxFit.cover,
                )
              : Container(),
          Column(
            children: _buildProductVariants(product),
          )
        ],
      ),
    );
  }

  List<Widget> _buildProductVariants(Product product) {
    List<Widget> widgetList = [];
    product.productVariants.forEach((variant) => widgetList.add(ListTile(
          title: Text(variant.title),
          subtitle: Row(
            children: [
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _addProductToShoppingCart(variant)),
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () =>
                      _removeProductFromShoppingCart(lineItems.first))
            ],
          ),
          trailing: Text(variant.price.amount.toString()),
        )));
    return widgetList;
  }

  ///Adds a product variant to the checkout
  Future<void> _addProductToShoppingCart(ProductVariant variant) async {}

  Future<void> _removeProductFromShoppingCart(LineItem lineItem) async {
    print(lineItem.id);
  }
}
