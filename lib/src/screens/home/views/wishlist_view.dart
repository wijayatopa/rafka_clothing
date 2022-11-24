part of '../../screens.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ListWishlistBloc, ListWishlistState>(
          builder: (context, state) {
            if (state is ListWishlistIsSuccess && state.data.isNotEmpty) {
              return ListView.separated(
                separatorBuilder: (context, index) =>
                    VxDivider(color: colorName.grey.withOpacity(.2)).px16(),
                itemCount: state.data.length,
                itemBuilder: (context, index) {
                  final data = state.data[index];
                  return VxBox(
                    child: HStack(
                      [
                        VxBox()
                            .bgImage(DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  data.pictures![0],
                                )))
                            .roundedSM
                            .size(context.percentWidth * 16,
                                context.percentWidth * 16)
                            .make(),
                        16.widthBox,
                        VStack(
                          [
                            data.name!.text.size(16).bold.make(),
                            4.heightBox,
                            Commons()
                                .setPriceToIDR(data.price!)
                                .text
                                .size(12)
                                .make(),
                          ],
                          alignment: MainAxisAlignment.start,
                        ).expand(),
                        BlocListener<WishlistCubit, WishlistState>(
                          listener: (context, state) {
                            if (state is WishlistIsSuccess) {
                              BlocProvider.of<ListWishlistBloc>(context)
                                  .add(FetchListWishlist());
                            }
                          },
                          child: IconButton(
                              onPressed: () {
                                BlocProvider.of<WishlistCubit>(context)
                                    .removeFromWishList(data.id!);
                              },
                              icon: const Icon(
                                Icons.delete_outline,
                                color: colorName.accentRed,
                              )),
                        )
                      ],
                      alignment: MainAxisAlignment.start,
                    ).p16(),
                  ).make().onTap(() {
                    context.go(routeName.detailPath, extra: data.id);
                  });
                },
              );
            }
            return VStack(
              [
                "Belum ada data wishlist"
                    .text
                    .bodyText1(context)
                    .makeCentered(),
                8.heightBox,
                ButtonWidget(
                    color: colorName.accentBlue,
                    text: 'Cari Produk',
                    onPressed: () {
                      BlocProvider.of<BottomNavBarCubit>(context)
                          .changeIndex(0);
                    })
              ],
              crossAlignment: CrossAxisAlignment.center,
            ).centered();
          },
        ),
      ),
    );
  }
}
