part of 'screens.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: colorName.white,
        iconTheme: const IconThemeData(color: colorName.black),
      ),
      bottomNavigationBar: BlocBuilder<DetailProductBloc, DetailProductState>(
        builder: (context, state) {
          if (state is DetailProductIsSuccess) {
            return BlocConsumer<AddToCartBloc, AddToCartState>(
              listener: (context, addToCartState) {
                if (addToCartState is AddToCartIsSuccess) {
                  Commons().showSnackBar(context, addToCartState.message);
                }
                if (addToCartState is AddToCartIsFailed) {
                  Commons().showSnackBar(context, addToCartState.message);
                }
              },
              builder: (context, addToCartState) {
                return BlocBuilder<CheckVariantCubit, CheckVariantState>(
                  builder: (context, variantState) {
                    return ButtonWidget(
                      text: 'Add To Cart',
                      isLoading: (addToCartState is AddToCartIsLoading),
                      onPressed: () {
                        BlocProvider.of<AddToCartBloc>(context).add(AddToCart(
                            //untuk data
                            state.data,
                            //untuk variant yang dipilih
                            (variantState as CheckVariantIsSelected)
                                .selectedVariant));
                      },
                    ).p16().box.white.withShadow([
                      BoxShadow(
                          blurRadius: 10, color: colorName.grey.withOpacity(.1))
                    ]).make();
                  },
                );
              },
            );
          }
          return 0.heightBox;
        },
      ),
      body: BlocBuilder<DetailProductBloc, DetailProductState>(
        builder: (context, state) {
          if (state is DetailProductIsSuccess) {
            return VStack([
              _buildListImage(state),
              _buildProductDetails(state),
            ]).scrollVertical();
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildProductDetails(DetailProductIsSuccess state) {
    return VStack([
      HStack([
        VStack([
          state.data.name!.text.size(20).semiBold.make(),
          8.heightBox,
          Commons().setPriceToIDR(state.data.price!).text.size(16).make(),
        ]).expand(),
        BlocListener<WishlistCubit, WishlistState>(
          listener: (context, wishlistState) {
            if (wishlistState is WishlistIsSuccess) {
              Commons().showSnackBar(context, wishlistState.message);
            }
            if (wishlistState is WishlistIsFailed) {
              Commons().showSnackBar(context, wishlistState.message);
            }
          },
          child: BlocBuilder<CheckSavedCubit, CheckSavedState>(
            builder: (context, checkSavedState) {
              if (checkSavedState is CheckSavedIsSuccess) {
                return IconButton(
                    onPressed: () {
                      BlocProvider.of<WishlistCubit>(context)
                          .removeFromWishList(state.data.id!);
                    },
                    icon: const Icon(
                      Icons.favorite,
                      color: colorName.accentRed,
                    ));
              }
              return IconButton(
                  onPressed: () {
                    BlocProvider.of<WishlistCubit>(context)
                        .addToWishList(state.data);
                  },
                  icon: const Icon(Icons.favorite_border_rounded));
            },
          ),
        )
      ]),
      VStack([
        'Deskripsi'.text.size(16).bold.make(),
        4.heightBox,
        state.data.desc!.text.size(14).color(colorName.grey).make(),
      ]).py16(),
      VStack([
        'Variant Produk'.text.bold.make(),
        8.heightBox,
        BlocBuilder<CheckVariantCubit, CheckVariantState>(
          builder: (context, variantState) {
            return HStack(state.data.variant!
                .map((e) => VxBox(
                            child: e.text
                                .color((variantState as CheckVariantIsSelected)
                                        .selectedVariant
                                        .contains(e)
                                    ? colorName.white
                                    : colorName.black)
                                .make())
                        .color(variantState.selectedVariant.contains(e)
                            ? colorName.secondary
                            : colorName.white)
                        .border(
                            color: variantState.selectedVariant.contains(e)
                                ? colorName.white
                                : colorName.grey)
                        .p16
                        .rounded
                        .make()
                        .onTap(() {
                      BlocProvider.of<CheckVariantCubit>(context).selectItem(e);
                    }).pOnly(right: 4))
                .toList());
          },
        )
      ])
    ]).p16();
  }

  Widget _buildListImage(DetailProductIsSuccess state) {
    return VxSwiper.builder(
      itemCount: state.data.pictures!.length,
      autoPlay: true,
      aspectRatio: 16 / 9,
      itemBuilder: (context, index) {
        return AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.network(
            state.data.pictures![index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
