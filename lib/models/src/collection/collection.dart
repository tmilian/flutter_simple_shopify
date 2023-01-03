import 'package:flutter_simple_shopify/models/models.dart';
import 'package:flutter_simple_shopify/models/src/product/product_variant/product_variant.dart';
import 'package:flutter_simple_shopify/models/src/product/products/products.dart';
import 'package:flutter_simple_shopify/models/src/product/shopify_image/shopify_image.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'collection.freezed.dart';
part 'collection.g.dart';

@freezed
class Collection with _$Collection {
  const Collection._();
  factory Collection({
    required String title,
    required String id,
    required Products products,
    String? cursor,
    String? description,
    String? descriptionHtml,
    String? handle,
    String? updatedAt,
    ShopifyImage? image,
  }) = _Collection;

  static Collection fromGraphJson(Map<String, dynamic> json, {String? cursor}) {
    var _products = Products.fromGraphJson(json['products'] ?? const {});
    final _realProducts = <Product>[];

    for (final _product in _products.productList) {
      final _realProductVariants = <ProductVariant>[];
      for (final _variant in _product.productVariants) {
        if (_variant.title.toLowerCase().contains('default')) {
          _realProductVariants
              .add(_variant.copyWith.call(title: _product.title));
        } else {
          _realProductVariants.add(_variant);
        }
      }
      _realProducts
          .add(_product.copyWith.call(productVariants: _realProductVariants));
    }

    _products = _products.copyWith.call(productList: _realProducts);

    return Collection(
      title: json['title'],
      description: json['description'],
      descriptionHtml: json['descriptionHtml'],
      handle: json['handle'],
      id: json['id'],
      updatedAt: json['updatedAt'],
      image: json['image'] != null
          ? ShopifyImage.fromJson(json['image'] ?? const {})
          : null,
      products: _products,
      cursor: cursor,
    );
  }

  factory Collection.fromJson(Map<String, dynamic> json) =>
      _$CollectionFromJson(json);
}
