part of 'add_to_cart_bloc.dart';

@immutable
abstract class AddToCartEvent {}

class AddToCart extends AddToCartEvent {
  final ProductModel data;
  final String selectedVariant;

  AddToCart(this.data, this.selectedVariant);
}
