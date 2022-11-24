part of 'screens.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorName.background,
      bottomNavigationBar: BlocBuilder<ListCartBloc, ListCartState>(
        builder: (context, state) {
          if (state is ListCartIsSuccess) {
            return BlocBuilder<CheckboxCartCubit, CheckboxCartState>(
              builder: (context, checkState) {
                if (checkState is CheckboxCartIsChecked) {
                  List tempList = <ProductModel>[];

                  double cartTotalPrice() {
                    double total = 0;

                    for (var item in checkState.model) {
                      for (var u in state.data) {
                        if (u.variant![0] == item.variant![0]) {
                          tempList.add(u);
                          total += item.price!;
                        }
                      }
                    }
                    return total;
                  }

                  return HStack([
                    VStack([
                      'Total,\n'.richText.withTextSpanChildren([
                        Commons()
                            .setPriceToIDR(cartTotalPrice())
                            .textSpan
                            .size(16)
                            .bold
                            .make()
                      ]).make(),
                    ]).expand(),
                    ButtonWidget(
                      text: 'Beli',
                      onPressed: () {},
                    )
                  ]).p16().box.white.withShadow([
                    BoxShadow(
                        blurRadius: 10, color: colorName.grey.withOpacity(.1))
                  ]).make();
                }
                return 0.heightBox;
              },
            );
          }
          return 0.heightBox;
        },
      ),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: colorName.white,
        title: 'Keranjang'.text.color(colorName.black).make(),
        iconTheme: const IconThemeData(color: colorName.black),
        actions: [
          BlocBuilder<ListCartBloc, ListCartState>(
            builder: (context, state) {
              return (state is ListCartIsSuccess)
                  ? BlocBuilder<CheckboxCartCubit, CheckboxCartState>(
                      builder: (context, checkState) {
                        if (checkState is CheckboxCartIsChecked) {
                          return ((checkState.model
                                      .containsAll(state.retrainData))
                                  ? 'Batalkan'
                                  : 'Pilih Semua')
                              .text
                              .medium
                              .color((checkState.model
                                      .containsAll(state.retrainData))
                                  ? colorName.accentRed
                                  : colorName.accentBlue)
                              .makeCentered()
                              .pOnly(right: 16)
                              .onTap(() {
                            if ((checkState.model
                                .containsAll(state.retrainData))) {
                              BlocProvider.of<CheckboxCartCubit>(context)
                                  .removeAllCheckBox();
                            } else {
                              BlocProvider.of<CheckboxCartCubit>(context)
                                  .addAllCheckBox(state.retrainData);
                            }
                          });
                        }
                        return 0.heightBox;
                      },
                    )
                  : 0.heightBox;
            },
          )
        ],
      ),
      body: BlocBuilder<ListCartBloc, ListCartState>(
        builder: (context, state) {
          if (state is ListCartIsSuccess) {
            final data = state.data;

            return ListView.separated(
              separatorBuilder: (context, index) => VxDivider(
                color: colorName.grey.withOpacity(.1),
              ),
              itemCount: state.retrainData.length,
              itemBuilder: (context, index) {
                List tempList = <ProductModel>[];
                for (var u in data) {
                  if (u.variant![0] == state.retrainData[index].variant![0]) {
                    tempList.add(u);
                  }
                }

                return VxBox(
                  child: HStack(
                    [
                      BlocBuilder<CheckboxCartCubit, CheckboxCartState>(
                        builder: (context, checkState) {
                          if (checkState is CheckboxCartIsChecked) {
                            return checkState.model
                                    .contains(state.retrainData[index])
                                ? const Icon(
                                    Icons.check_box,
                                    color: colorName.accentBlue,
                                  ).onTap(() {
                                    BlocProvider.of<CheckboxCartCubit>(context)
                                        .removeCheckBox(
                                            state.retrainData[index]);
                                  })
                                : const Icon(
                                    Icons.check_box_outline_blank_rounded,
                                    color: colorName.accentBlue,
                                  ).onTap(() {
                                    BlocProvider.of<CheckboxCartCubit>(context)
                                        .addCheckBox(state.retrainData[index]);
                                  });
                          }
                          return 0.heightBox;
                        },
                      ),
                      16.widthBox,
                      VxBox()
                          .bgImage(DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                state.retrainData[index].pictures![0],
                              )))
                          .roundedSM
                          .size(context.percentWidth * 16,
                              context.percentWidth * 16)
                          .make(),
                      16.widthBox,
                      VStack(
                        [
                          state.retrainData[index].name!.text
                              .size(16)
                              .bold
                              .make(),
                          4.heightBox,
                          Commons()
                              .setPriceToIDR(state.retrainData[index].price!)
                              .text
                              .size(12)
                              .make(),
                          4.heightBox,
                          state.retrainData[index].variant![0].text
                              .size(12)
                              .make()
                              .pSymmetric(h: 12, v: 6)
                              .box
                              .color(colorName.grey.withOpacity(.1))
                              .make(),
                          4.heightBox,
                          HStack([
                            const Icon(Icons.remove_circle_outline_rounded)
                                .onTap(() {
                              BlocProvider.of<ListCartBloc>(context)
                                  .add(DecrementCart(state.retrainData[index]));
                            }),
                            4.widthBox,
                            tempList.length.text
                                .size(12)
                                .make()
                                .pSymmetric(h: 12, v: 6)
                                .box
                                .color(colorName.grey.withOpacity(.1))
                                .make(),
                            4.widthBox,
                            BlocListener<AddToCartBloc, AddToCartState>(
                              listener: (context, state) {
                                if (state is AddToCartIsSuccess) {
                                  BlocProvider.of<ListCartBloc>(context)
                                      .add(FetchListCart());
                                }
                              },
                              child:
                                  const Icon(Icons.add_circle_outline_rounded)
                                      .onTap(() {
                                BlocProvider.of<AddToCartBloc>(context).add(
                                    AddToCart(state.retrainData[index],
                                        state.retrainData[index].variant![0]));
                              }),
                            )
                          ])
                        ],
                        alignment: MainAxisAlignment.start,
                      ).expand(),
                      BlocListener<ListCartBloc, ListCartState>(
                        listener: (context, state) {},
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.delete_outline,
                              color: colorName.accentRed,
                            )),
                      )
                    ],
                    alignment: MainAxisAlignment.start,
                  ).p16(),
                ).make();
              },
            );
          }
          return 0.heightBox;
        },
      ),
    );
  }
}
