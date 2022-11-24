part of 'product_picture_cubit.dart';

@immutable
abstract class ProductPictureState {}

class ProductPictureInitial extends ProductPictureState {}

class ProductPictureIsFailed extends ProductPictureState {}

class ProductPictureIsLoaded extends ProductPictureState {
  final List<File> files;
  ProductPictureIsLoaded({
    required this.files,
  });
}
