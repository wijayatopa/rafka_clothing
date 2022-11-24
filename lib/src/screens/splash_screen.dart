part of "screens.dart";

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VStack(['Rafka Clothing'.text.bold.make().centered()]),
    );
  }
}
