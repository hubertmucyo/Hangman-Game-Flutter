import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

const kActionButtonTextStyle = TextStyle(
  fontSize: 26,
  color: Colors.white,
  fontWeight: FontWeight.bold,
  letterSpacing: 1.0,
  fontFamily: 'Chewy', // Cartoon-style font
  shadows: [
    Shadow(
      color: Colors.black26,
      offset: Offset(2, 2),
      blurRadius: 3,
    ),
  ],
);

// Cartoon Theme Colors - Child Friendly
const kActionButtonColor = Color(0xFFFF6B35); // Bright Orange
const kActionButtonHighlightColor = Color(0xFFFF8C42); // Lighter Orange

const kWordButtonColor = Color(0xFF4ECDC4); // Sky Blue
const kTooltipColor = Color(0xFF4ECDC4);

// Additional cartoon colors
const kCartoonYellow = Color(0xFFFFD700); // Sunny Yellow
const kCartoonGreen = Color(0xFF32CD32); // Bright Green
const kCartoonRed = Color(0xFFFF6B6B); // Soft Red
const kSkyBlue = Color(0xFF87CEEB); // Background sky blue

const kWordButtonTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 24,
  fontFamily: 'Baloo2', // Soft, child-friendly font
  shadows: [
    Shadow(
      color: Colors.black12,
      offset: Offset(1, 1),
      blurRadius: 2,
    ),
  ],
);

const kHighScoreTableHeaders = TextStyle(
  color: Colors.white,
  fontSize: 28.0,
  fontWeight: FontWeight.bold,
  letterSpacing: 1.0,
  fontFamily: 'LuckiestGuy',
  shadows: [
    Shadow(
      color: Colors.black45,
      offset: Offset(2, 2),
      blurRadius: 4,
    ),
  ],
);

const kHighScoreTableRowsStyle = TextStyle(
  color: Colors.white,
  fontSize: 24.0,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.8,
  fontFamily: 'Baloo2',
  shadows: [
    Shadow(
      color: Colors.black38,
      offset: Offset(1, 1),
      blurRadius: 2,
    ),
  ],
);

var kSuccessAlertStyle = AlertStyle(
  animationType: AnimationType.grow,
  isCloseButton: false,
  isOverlayTapDismiss: false,
  animationDuration: const Duration(milliseconds: 600),
  backgroundColor: Colors.white,
  alertBorder: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20.0),
    side: BorderSide(color: kCartoonGreen, width: 4),
  ),
  titleStyle: const TextStyle(
    color: kCartoonGreen,
    fontWeight: FontWeight.bold,
    fontSize: 32.0,
    letterSpacing: 1.5,
    fontFamily: 'Chewy',
    shadows: [
      Shadow(
        color: Colors.black26,
        offset: Offset(2, 2),
        blurRadius: 4,
      ),
    ],
  ),
);
var kExitAlertStyle = AlertStyle(
  animationType: AnimationType.grow,
  isCloseButton: false,
  isOverlayTapDismiss: false,
  descStyle: const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 27.0,
    letterSpacing: 2.0,
  ),
  animationDuration: const Duration(milliseconds: 500),
  backgroundColor: const Color(0xFF2C1E68),
  alertBorder: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
  ),
  titleStyle: const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 27.0,
    letterSpacing: 2.0,
  ),
);

var kGameOverAlertStyle = AlertStyle(
  animationType: AnimationType.grow,
  isCloseButton: false,
  isOverlayTapDismiss: false,
  animationDuration: const Duration(milliseconds: 500),
  backgroundColor: Colors.white,
  alertBorder: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20.0),
    side: BorderSide(color: kCartoonRed, width: 4),
  ),
  titleStyle: const TextStyle(
    color: kCartoonRed,
    fontWeight: FontWeight.bold,
    fontSize: 28.0,
    letterSpacing: 1.5,
    fontFamily: 'Chewy',
  ),
  descStyle: const TextStyle(
    color: Color(0xFF2F4F4F),
    fontWeight: FontWeight.bold,
    fontSize: 22.0,
    letterSpacing: 1.2,
    fontFamily: 'Baloo2',
  ),
);

var kFailedAlertStyle = AlertStyle(
  animationType: AnimationType.grow,
  isCloseButton: false,
  isOverlayTapDismiss: false,
  animationDuration: const Duration(milliseconds: 500),
  backgroundColor: Colors.white,
  alertBorder: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20.0),
    side: BorderSide(color: kActionButtonColor, width: 4),
  ),
  titleStyle: const TextStyle(
    color: kActionButtonColor,
    fontWeight: FontWeight.bold,
    fontSize: 28.0,
    letterSpacing: 1.5,
    fontFamily: 'Chewy',
  ),
);

const kDialogButtonTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 25,
  fontWeight: FontWeight.w300,
  letterSpacing: 0.5,
);

const kWordTextStyle = TextStyle(
    fontSize: 48,
    color: Colors.white,
    fontFamily: 'Baloo2', // More readable for children
    letterSpacing: 6,
    fontWeight: FontWeight.bold,
    shadows: [
      Shadow(
        color: Colors.black45,
        offset: Offset(3, 3),
        blurRadius: 5,
      ),
    ]);

const kDialogButtonColor = Color(0x00000000);

const kWordCounterTextStyle = TextStyle(
    fontSize: 32.0, 
    color: kCartoonYellow, 
    fontWeight: FontWeight.w900,
    fontFamily: 'LuckiestGuy', // Bold, cartoon title font
    shadows: [
      Shadow(
        color: Colors.black54,
        offset: Offset(2, 2),
        blurRadius: 3,
      ),
    ]);

// Cartoon Category Style
const kCategoryTextStyle = TextStyle(
  color: Color(0xFF2F4F4F), // Dark gray for readability
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'PatrickHand', // Handwritten style
  shadows: [
    Shadow(
      color: Colors.white54,
      offset: Offset(1, 1),
      blurRadius: 2,
    ),
  ],
);

// Main title style
const kCartoonTitleStyle = TextStyle(
  fontSize: 52.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'LuckiestGuy',
  color: kActionButtonColor,
  shadows: [
    Shadow(
      color: Colors.black45,
      offset: Offset(4, 4),
      blurRadius: 8,
    ),
    Shadow(
      color: Colors.white24,
      offset: Offset(-2, -2),
      blurRadius: 4,
    ),
  ],
);
