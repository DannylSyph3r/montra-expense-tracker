import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

abstract class CategoryResources {
  // Available icons for custom categories (100+ icons)
  static const List<IconData> availableIcons = [
    // Money & Finance
    PhosphorIconsBold.coins,
    PhosphorIconsBold.money,
    PhosphorIconsBold.creditCard,
    PhosphorIconsBold.bank,
    PhosphorIconsBold.piggyBank,
    PhosphorIconsBold.wallet,
    PhosphorIconsBold.currencyCircleDollar,
    PhosphorIconsBold.receipt,
    PhosphorIconsBold.calculator,
    
    // Transportation
    PhosphorIconsBold.car,
    PhosphorIconsBold.bicycle,
    PhosphorIconsBold.bus,
    PhosphorIconsBold.taxi,
    PhosphorIconsBold.train,
    PhosphorIconsBold.airplane,
    PhosphorIconsBold.motorcycle,
    PhosphorIconsBold.boat,
    PhosphorIconsBold.subway,
    PhosphorIconsBold.scooter,
    
    // Food & Dining
    PhosphorIconsBold.hamburger,
    PhosphorIconsBold.pizza,
    PhosphorIconsBold.coffee,
    PhosphorIconsBold.wine,
    PhosphorIconsBold.beerStein,
    PhosphorIconsBold.iceCream,
    PhosphorIconsBold.cookie,
    PhosphorIconsBold.cake,
    PhosphorIconsBold.fish,
    PhosphorIconsBold.orangeSlice,
    
    // Health & Fitness
    PhosphorIconsBold.heartbeat,
    PhosphorIconsBold.heart,
    PhosphorIconsBold.firstAid,
    PhosphorIconsBold.pill,
    PhosphorIconsBold.syringe,
    PhosphorIconsBold.barbell,
    PhosphorIconsBold.personSimpleRun,
    PhosphorIconsBold.personSimpleWalk,
    PhosphorIconsBold.personSimpleTaiChi,
    PhosphorIconsBold.basketball,
    
    // Entertainment & Hobbies
    PhosphorIconsBold.gameController,
    PhosphorIconsBold.musicNote,
    PhosphorIconsBold.camera,
    PhosphorIconsBold.filmReel,
    PhosphorIconsBold.book,
    PhosphorIconsBold.palette,
    PhosphorIconsBold.guitar,
    PhosphorIconsBold.microphone,
    PhosphorIconsBold.headphones,
    PhosphorIconsBold.television,
    PhosphorIconsBold.filmSlate,
    PhosphorIconsBold.ticket,
    PhosphorIconsBold.diceFive,
    PhosphorIconsBold.puzzlePiece,
    
    // Home & Living
    PhosphorIconsBold.house,
    PhosphorIconsBold.bed,
    PhosphorIconsBold.toilet,
    PhosphorIconsBold.shower,
    PhosphorIconsBold.lamp,
    PhosphorIconsBold.chair,
    PhosphorIconsBold.plant,
    PhosphorIconsBold.flower,
    PhosphorIconsBold.tree,
    PhosphorIconsBold.key,
    PhosphorIconsBold.doorOpen,
    PhosphorIconsBold.garage,
    
    // Shopping & Retail
    PhosphorIconsBold.shoppingBag,
    PhosphorIconsBold.shoppingCart,
    PhosphorIconsBold.gift,
    PhosphorIconsBold.dress,
    PhosphorIconsBold.tShirt,
    PhosphorIconsBold.pants,
    PhosphorIconsBold.sneaker,
    PhosphorIconsBold.eyeglasses,
    PhosphorIconsBold.watch,
    PhosphorIconsBold.handbag,
    
    // Technology
    PhosphorIconsBold.laptop,
    PhosphorIconsBold.desktop,
    PhosphorIconsBold.phone,
    PhosphorIconsBold.monitor,
    PhosphorIconsBold.keyboard,
    PhosphorIconsBold.mouse,
    PhosphorIconsBold.hardDrive,
    PhosphorIconsBold.usb,
    PhosphorIconsBold.wifiHigh,
    PhosphorIconsBold.bluetooth,
    
    // Nature & Animals
    PhosphorIconsBold.pawPrint,
    PhosphorIconsBold.dog,
    PhosphorIconsBold.cat,
    PhosphorIconsBold.bird,
    PhosphorIconsBold.butterfly,
    PhosphorIconsBold.sun,
    PhosphorIconsBold.moon,
    PhosphorIconsBold.star,
    PhosphorIconsBold.cloud,
    PhosphorIconsBold.lightning,
    PhosphorIconsBold.fire,
    PhosphorIconsBold.leaf,
    
    // Travel & Places
    PhosphorIconsBold.suitcase,
    PhosphorIconsBold.compass,
    PhosphorIconsBold.mapTrifold,
    PhosphorIconsBold.tent,
    PhosphorIconsBold.mountains,
    PhosphorIconsBold.umbrella,
    PhosphorIconsBold.flag,
    PhosphorIconsBold.globe,
    PhosphorIconsBold.mapPin,
    
    // Work & Education
    PhosphorIconsBold.briefcase,
    PhosphorIconsBold.graduationCap,
    PhosphorIconsBold.pencil,
    PhosphorIconsBold.pen,
    PhosphorIconsBold.notebook,
    PhosphorIconsBold.backpack,
    PhosphorIconsBold.presentation,
    PhosphorIconsBold.chalkboard,
    PhosphorIconsBold.certificate,
    PhosphorIconsBold.target,
    
    // Miscellaneous
    PhosphorIconsBold.trophy,
    PhosphorIconsBold.crown,
    PhosphorIconsBold.diamond,
    PhosphorIconsBold.shield,
    PhosphorIconsBold.lock,
    PhosphorIconsBold.bell,
    PhosphorIconsBold.envelope,
    PhosphorIconsBold.calendar,
    PhosphorIconsBold.clock,
    PhosphorIconsBold.timer,
    PhosphorIconsBold.alarm,
    PhosphorIconsBold.thermometer,
    PhosphorIconsBold.carBattery,
    PhosphorIconsBold.lightbulb,
    PhosphorIconsBold.gear,
    PhosphorIconsBold.wrench,
    PhosphorIconsBold.hammer,
    PhosphorIconsBold.paintBrush,
  ];

  // Available colors for custom categories (50+ colors)
  static const List<Color> availableColors = [
    // Primary Colors
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.cyan,
    
    // Material Design Colors
    Colors.indigo,
    Colors.teal,
    Colors.lime,
    Colors.amber,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    
    // Darker Shades
    Color(0xFFD32F2F), // Red 600
    Color(0xFF1976D2), // Blue 700
    Color(0xFF388E3C), // Green 600
    Color(0xFF7B1FA2), // Purple 600
    Color(0xFFF57C00), // Orange 600
    Color(0xFFE91E63), // Pink 500
    Color(0xFF00796B), // Teal 600
    Color(0xFF303F9F), // Indigo 600
    
    // Lighter Shades
    Color(0xFFEF5350), // Red 400
    Color(0xFF42A5F5), // Blue 400
    Color(0xFF66BB6A), // Green 400
    Color(0xFFAB47BC), // Purple 400
    Color(0xFFFF7043), // Deep Orange 400
    Color(0xFFEC407A), // Pink 400
    Color(0xFF26A69A), // Teal 400
    Color(0xFF5C6BC0), // Indigo 400
    
    // Pastel Colors
    Color(0xFFFFCDD2), // Red 100
    Color(0xFFBBDEFB), // Blue 100
    Color(0xFFC8E6C9), // Green 100
    Color(0xFFE1BEE7), // Purple 100
    Color(0xFFFFE0B2), // Orange 100
    Color(0xFFF8BBD9), // Pink 100
    Color(0xFFB2DFDB), // Teal 100
    Color(0xFFC5CAE9), // Indigo 100
    
    // Vivid Colors
    Color(0xFFFF1744), // Red A400
    Color(0xFF2979FF), // Blue A400
    Color(0xFF00E676), // Green A400
    Color(0xFFD500F9), // Purple A400
    Color(0xFFFF6D00), // Orange A400
    Color(0xFFF50057), // Pink A400
    Color(0xFF1DE9B6), // Teal A400
    Color(0xFF3D5AFE), // Indigo A400
    
    // Neutral & Earth Tones
    Color(0xFF5D4037), // Brown 600
    Color(0xFF8D6E63), // Brown 400
    Color(0xFF455A64), // Blue Grey 600
    Color(0xFF78909C), // Blue Grey 400
    Color(0xFF424242), // Grey 800
    Color(0xFF757575), // Grey 600
    Color(0xFF9E9E9E), // Grey 500
    Color(0xFFBDBDBD), // Grey 400
  ];

  // Helper method to get icons by category
  static List<IconData> getIconsByCategory(CategoryType category) {
    switch (category) {
      case CategoryType.moneyFinance:
        return availableIcons.sublist(0, 9);
      case CategoryType.transportation:
        return availableIcons.sublist(9, 19);
      case CategoryType.foodDining:
        return availableIcons.sublist(19, 29);
      case CategoryType.healthFitness:
        return availableIcons.sublist(29, 39);
      case CategoryType.entertainment:
        return availableIcons.sublist(39, 53);
      case CategoryType.homeLiving:
        return availableIcons.sublist(53, 65);
      case CategoryType.shopping:
        return availableIcons.sublist(65, 75);
      case CategoryType.technology:
        return availableIcons.sublist(75, 85);
      case CategoryType.nature:
        return availableIcons.sublist(85, 97);
      case CategoryType.travel:
        return availableIcons.sublist(97, 107);
      case CategoryType.workEducation:
        return availableIcons.sublist(107, 117);
      case CategoryType.miscellaneous:
        return availableIcons.sublist(117);
      default:
        return availableIcons;
    }
  }

  // Helper method to get colors by palette type
  static List<Color> getColorsByPalette(ColorPalette palette) {
    switch (palette) {
      case ColorPalette.primary:
        return availableColors.sublist(0, 8);
      case ColorPalette.material:
        return availableColors.sublist(8, 19);
      case ColorPalette.dark:
        return availableColors.sublist(19, 27);
      case ColorPalette.light:
        return availableColors.sublist(27, 35);
      case ColorPalette.pastel:
        return availableColors.sublist(35, 43);
      case ColorPalette.vivid:
        return availableColors.sublist(43, 51);
      case ColorPalette.neutral:
        return availableColors.sublist(51);
      default:
        return availableColors;
    }
  }
}

// Enums for categorizing icons and colors
enum CategoryType {
  moneyFinance,
  transportation,
  foodDining,
  healthFitness,
  entertainment,
  homeLiving,
  shopping,
  technology,
  nature,
  travel,
  workEducation,
  miscellaneous,
  all,
}

enum ColorPalette {
  primary,
  material,
  dark,
  light,
  pastel,
  vivid,
  neutral,
  all,
}