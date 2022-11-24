import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rafka_clothing/src/blocs/blocs.dart';
import 'package:rafka_clothing/src/cubits/cubits.dart';
import 'package:rafka_clothing/src/utilities/utilities.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RegisterBloc()),
        BlocProvider(create: (context) => LoginBloc()),
        BlocProvider(create: (context) => UserBloc()),
        BlocProvider(create: (context) => ProductPictureCubit()),
        BlocProvider(create: (context) => ListProductBloc()),
        BlocProvider(create: (context) => DetailProductBloc()),
        BlocProvider(create: (context) => ListWishlistBloc()),
        BlocProvider(create: (context) => CheckSavedCubit()),
        BlocProvider(create: (context) => CheckVariantCubit()),
        BlocProvider(create: (context) => CartCountCubit()),
        BlocProvider(create: (context) => BottomNavBarCubit()),
        BlocProvider(create: (context) => ListCartBloc()),
        BlocProvider(create: (context) => CheckboxCartCubit()),
        BlocProvider(create: (context) => AddToCartBloc()),
        BlocProvider(
            create: (context) =>
                WishlistCubit(BlocProvider.of<CheckSavedCubit>(context))),
        BlocProvider(
            create: (context) =>
                AdminBloc(BlocProvider.of<ProductPictureCubit>(context))),
      ],
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }
}
