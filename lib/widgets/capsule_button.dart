import 'package:flutter/material.dart';

class MyCapsuleButton extends StatelessWidget {
  const MyCapsuleButton({
    super.key,
    this.text = '',
    this.textStyle,
    this.backgroundColor,
    this.borderRadius,
    this.onTap,
    this.isLoading = false,
  });

  final String text;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Function? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(100),
        color: backgroundColor ?? Colors.black,
      ),
      child: TextButton(
        onPressed: () => onTap!(),
        style: const ButtonStyle(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Text(
                  text,
                  style: textStyle ??
                      const TextStyle(
                        color: Colors.white,
                      ),
                ),
        ),
      ),
    );
  }
}
