import 'package:flutter/material.dart';
import 'package:flutter_hangman/utilities/constants.dart';

class WordButton extends StatelessWidget {
  const WordButton({
    super.key, 
    required this.buttonTitle, 
    this.onPress,
    this.isUsed = false,
  });

  final VoidCallback? onPress;
  final String buttonTitle;
  final bool isUsed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: isUsed ? 1.0 : 4.0, // Less elevation when used
        backgroundColor: isUsed ? Colors.grey.shade400 : kWordButtonColor,
        foregroundColor: isUsed ? Colors.white60 : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // More rounded for cartoon feel
        ),
        padding: const EdgeInsets.all(8.0),
        side: isUsed ? BorderSide(color: const Color(0xFFFF6B6B), width: 3) : null,
        shadowColor: isUsed ? Colors.transparent : Colors.black26,
      ),
      onPressed: onPress,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            buttonTitle,
            textAlign: TextAlign.center,
            style: kWordButtonTextStyle.copyWith(
              color: isUsed ? Colors.white54 : Colors.white,
            ),
          ),
          if (isUsed)
            Container(
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.7),
              ),
              child: Text(
                buttonTitle,
                textAlign: TextAlign.center,
                style: kWordButtonTextStyle.copyWith(
                  color: Colors.white54,
                  decoration: TextDecoration.lineThrough,
                  decorationThickness: 2.0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}