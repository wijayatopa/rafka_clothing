part of '../../screens.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserIsLoading) {
              return const CircularProgressIndicator().centered();
            } else if (state is UserIsSuccess) {
              return VStack(
                [
                  _buildAppBar(context, state.data),
                  24.heightBox,
                  _buildListProduct().expand(),
                ],
                alignment: MainAxisAlignment.start,
                axisSize: MainAxisSize.max,
              );
            }
            return 0.heightBox;
          },
        ).p16().centered(),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, UserModel data) {
    return VxBox(
      child: HStack(
        [
          //USER Profile
          HStack([
            VxCircle(
              radius: 56,
              backgroundImage: (data.photoProfile!.isNotEmpty)
                  ? DecorationImage(
                      image: NetworkImage(data.photoProfile!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ).onTap(() {
              context.go(routeName.adminPath);
            }),
            16.widthBox,
            "Selamat Datang,\n".richText.size(11).withTextSpanChildren([
              data.username!.textSpan.size(14).bold.make(),
            ]).make(),
          ]).expand(),

          //ICON Cart
          BlocBuilder<CartCountCubit, CartCountState>(
            builder: (context, state) {
              return ZStack(
                [
                  IconButton(
                    onPressed: () {
                      context.go(routeName.cartPath);
                    },
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: colorName.black,
                    ),
                  ),
                  (state as CartCountIsSuccess).value != 0
                      ? VxBox(
                              child: state.value.text
                                  .size(8)
                                  .white
                                  .makeCentered()
                                  .p4())
                          .roundedFull
                          .color(colorName.accentRed)
                          .make()
                          .positioned(right: 8, top: 2)
                      : 0.heightBox
                ],
                alignment: Alignment.topRight,
              );
            },
          )
        ],
        // alignment: MainAxisAlignment.spaceBetween,
        // axisSize: MainAxisSize.max,
      ),
    ).make();
  }

  Widget _buildListProduct() {
    return BlocConsumer<ListProductBloc, ListProductState>(
      listener: (context, state) {
        if (state is ListProductIsFailed) {
          Commons().showSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is ListProductIsLoading) {
          //Loading Widget
          return const CircularProgressIndicator();
        }
        if (state is ListProductIsSuccess) {
          //List Product Widget
          final data = state.products;

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3.5 / 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return _buildProductWidget(context, data[index]);
            },
          );
        }
        return Container();
      },
    );
  }

  Widget _buildProductWidget(BuildContext context, ProductModel data) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: VStack(
        [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: Image.network(
              data.pictures![0],
              fit: BoxFit.cover,
            ),
          ),
          VStack([
            data.name!.text.size(16).bold.make(),
            4.heightBox,
            Commons().setPriceToIDR(data.price!).text.size(12).make(),
          ]).p8()
        ],
      ).box.white.make(),
    ).onTap(() {
      context.go(routeName.detailPath, extra: data.id);
    });
  }
}
