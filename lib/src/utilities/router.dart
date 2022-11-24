part of 'utilities.dart';

mixin routeName {
  static const login = '/login';
  static const splash = '/splash';
  static const register = '/register';
  static const home = '/home';
  static const admin = 'admin';
  static const adminPath = '/home/admin';
  static const cart = 'cart';
  static const cartPath = '/home/cart';
  static const detail = 'detail';
  static const detailPath = '/home/detail';
}

final GoRouter router = GoRouter(initialLocation: routeName.splash, routes: [
  GoRoute(
    path: routeName.splash,
    redirect: (context, state) {
      if (FirebaseAuth.instance.currentUser != null) {
        Commons().setUID(FirebaseAuth.instance.currentUser!.uid);
        BlocProvider.of<UserBloc>(context).add(LoadUserData());
        return routeName.home;
      } else {
        return routeName.login;
      }
    },
    builder: (context, state) {
      return const SplashScreen();
    },
  ),
  GoRoute(
    path: routeName.register,
    builder: (context, state) {
      return const RegisterScreen();
    },
  ),
  GoRoute(
    path: routeName.login,
    builder: (context, state) {
      return const LoginScreen();
    },
  ),
  GoRoute(
    path: routeName.home,
    builder: (context, state) {
      BlocProvider.of<UserBloc>(context).add(LoadUserData());
      BlocProvider.of<ListProductBloc>(context).add(FetchListProduct());
      return const HomeScreen();
    },
    routes: [
      GoRoute(
        path: routeName.cart,
        builder: (context, state) {
          BlocProvider.of<ListCartBloc>(context).add(FetchListCart());
          return const CartScreen();
        },
      ),
      GoRoute(
        path: routeName.admin,
        builder: (context, state) {
          return const AdminScreen();
        },
      ),
      GoRoute(
        path: routeName.detail,
        builder: (context, state) {
          BlocProvider.of<DetailProductBloc>(context)
              .add(FetchDetailProduct(state.extra as String));
          return const DetailScreen();
        },
      ),
    ],
  ),
]);
