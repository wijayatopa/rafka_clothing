part of '../screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController pageController = PageController();
  final bottomNavBarItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      label: 'Beranda',
      activeIcon: Icon(Icons.home),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.favorite_outline_rounded),
      label: 'Wishlist',
      activeIcon: Icon(Icons.favorite),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline_rounded),
      label: 'Profil',
      activeIcon: Icon(Icons.person),
    ),
  ];

  final pageItems = const [DashboardView(), WishlistView(), UserView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorName.background,
        bottomNavigationBar: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
          builder: (context, state) {
            return BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedItemColor: colorName.primary,
              unselectedItemColor: colorName.grey,
              items: bottomNavBarItems,
              currentIndex: (state as BottomNavBarIsChanged).index,
              onTap: (value) {
                BlocProvider.of<BottomNavBarCubit>(context).changeIndex(value);
                if (value == 1) {
                  BlocProvider.of<ListWishlistBloc>(context)
                      .add(FetchListWishlist());
                }
              },
            );
          },
        ),
        body: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
          builder: (context, state) {
            return pageItems[(state as BottomNavBarIsChanged).index];
          },
        ));
  }
}
