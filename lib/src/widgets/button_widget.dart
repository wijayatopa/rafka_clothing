part of 'widgets.dart';

class ButtonWidget extends StatelessWidget {
  final Function()? onPressed;
  final String text;
  final Color? color;
  final bool? isLoading;
  const ButtonWidget(
      {super.key,
      this.onPressed,
      this.text = 'Button',
      this.isLoading = false,
      this.color = colorName.primary});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading! ? null : onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )),
      child: isLoading!
          ? SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ).centered().p(14)
          : text.text.buttonText(context).color(colorName.white).make().p(14),
    ).wFull(context);
  }
}
