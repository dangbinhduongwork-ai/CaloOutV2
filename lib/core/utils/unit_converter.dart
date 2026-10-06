/// Unit conversion utilities for Metric (kg, cm) and Imperial (lb, ft/in) systems.
/// Calculations maintain full double precision; rounding is reserved for UI display.
class UnitConverter {
  UnitConverter._();

  // 1 kg = 2.20462262185 lb
  static const double kgToLbRatio = 2.20462262185;

  // 1 inch = 2.54 cm
  static const double cmPerInch = 2.54;

  // 1 foot = 12 inches = 30.48 cm
  static const double cmPerFoot = 30.48;

  /// Convert kilograms to pounds (full double precision)
  static double kgToLb(double kg) => kg * kgToLbRatio;

  /// Convert pounds to kilograms (full double precision)
  static double lbToKg(double lb) => lb / kgToLbRatio;

  /// Convert centimeters to total inches
  static double cmToInches(double cm) => cm / cmPerInch;

  /// Convert total inches to centimeters
  static double inchesToCm(double inches) => inches * cmPerInch;

  /// Convert feet and inches to centimeters
  static double ftInToCm(int feet, double inches) {
    return (feet * 12 + inches) * cmPerInch;
  }

  /// Convert centimeters to feet and remainder inches without premature rounding
  static ({int feet, double inches}) cmToFeetAndInches(double cm) {
    final totalInches = cm / cmPerInch;
    final feet = totalInches ~/ 12;
    final inches = totalInches - (feet * 12);
    return (feet: feet, inches: inches);
  }

  /// Format weight string with unit for display
  static String formatWeight(double kg, {bool isImperial = false}) {
    if (isImperial) {
      final lb = kgToLb(kg);
      return '${lb.toStringAsFixed(1)} lb';
    }
    return '${kg.toStringAsFixed(1)} kg';
  }

  /// Format height string with unit for display
  static String formatHeight(double cm, {bool isImperial = false}) {
    if (isImperial) {
      final pair = cmToFeetAndInches(cm);
      return "${pair.feet}' ${pair.inches.toStringAsFixed(1)}\"";
    }
    return '${cm.toStringAsFixed(0)} cm';
  }
}
