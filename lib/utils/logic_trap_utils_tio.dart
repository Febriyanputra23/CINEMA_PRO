class LogicTrapUtils_Tio {
  static int calculateTitleTax_Tio(String title) {
    int charCount = 0;
    for (int i = 0; i < title.length; i++) {
      if (title[i] != ' ') {
        charCount++;
      }
    }
    return charCount > 10 ? 2500 : 0;
  }

  static int parseSeatNumber_Tio(String seatCode) {
    String numberStr = '';
    for (int i = 0; i < seatCode.length; i++) {
      int charCode = seatCode.codeUnitAt(i);
      if (charCode >= 48 && charCode <= 57) {
        numberStr += seatCode[i];
      }
    }
    if (numberStr.isEmpty) return 0;
    int result = 0;
    for (int i = 0; i < numberStr.length; i++) {
      int digit = numberStr.codeUnitAt(i) - 48;
      result = result * 10 + digit;
    }
    return result;
  }

  static bool isSeatEven_Tio(String seatCode) {
    int seatNumber = parseSeatNumber_Tio(seatCode);
    return seatNumber % 2 == 0;
  }

  static int calculateEvenSeatDiscount_Tio(int price) {
    int tenPercent = _divideManually_Tio(price, 10);
    return price - tenPercent;
  }

  static int calculateTotalPriceManual_Tio({
    required String movieTitle,
    required int basePrice,
    required List<String> selectedSeats,
  }) {
    int total = 0;
    int titleTax = calculateTitleTax_Tio(movieTitle);
    for (String seat in selectedSeats) {
      int seatPrice = basePrice + titleTax;
      if (isSeatEven_Tio(seat)) {
        seatPrice = calculateEvenSeatDiscount_Tio(seatPrice);
      }
      total += seatPrice;
    }
    return total;
  }

  static int _divideManually_Tio(int numerator, int denominator) {
    if (denominator == 0) return 0;
    int result = 0;
    int temp = numerator;
    while (temp >= denominator) {
      temp -= denominator;
      result++;
    }
    return result;
  }
}