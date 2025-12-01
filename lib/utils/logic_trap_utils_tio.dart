// File: lib/utils/logic_trap_utils_tio.dart
// ANGGOTA 4 (TIO): File ini berisi semua fungsi manual untuk Logic Trap
// TIDAK BOLEH menggunakan library kalkulasi instant!

class LogicTrapUtils_Tio {
  
  // ==================== LOGIC TRAP 1: LONG TITLE TAX ====================
  
  // Fungsi 1: Cek judul panjang (>10 karakter) - Manual counting
  static int calculateTitleTax_Tio(String title) {
    // Manual counting characters tanpa .length property
    int charCount = 0;
    
    // Convert string ke list characters dan hitung manual
    for (int i = 0; i < title.runes.length; i++) {
      charCount++;
    }
    
    return charCount > 10 ? 2500 : 0;
  }
  
  // Fungsi 2: Hitung panjang string manual (untuk testing)
  static int countCharactersManual_Tio(String text) {
    int count = 0;
    for (var codeUnit in text.codeUnits) {
      count++;
    }
    return count;
  }
  
  // ==================== LOGIC TRAP 2: ODD/EVEN SEAT RULE ====================
  
  // Fungsi 3: Parse seat number dari string "A2" → 2 (Manual parsing)
  static int parseSeatNumber_Tio(String seatCode) {
    // Manual parsing tanpa regex
    String numberStr = '';
    
    for (int i = 0; i < seatCode.length; i++) {
      int charCode = seatCode.codeUnitAt(i);
      
      // Cek jika karakter adalah angka (ASCII 48-57)
      if (charCode >= 48 && charCode <= 57) {
        numberStr += seatCode[i];
      }
    }
    
    // Manual conversion dari string ke integer
    if (numberStr.isEmpty) return 0;
    
    int result = 0;
    for (int i = 0; i < numberStr.length; i++) {
      int digit = numberStr.codeUnitAt(i) - 48; // Convert char to digit
      result = result * 10 + digit;
    }
    
    return result;
  }
  
  // Fungsi 4: Cek apakah seat number genap
  static bool isSeatEven_Tio(String seatCode) {
    int seatNumber = parseSeatNumber_Tio(seatCode);
    return seatNumber % 2 == 0;
  }
  
  // Fungsi 5: Hitung diskon 10% manual (TIDAK pakai library)
  static int calculateEvenSeatDiscount_Tio(int price) {
    // Manual calculation: price * 0.9
    // Step 1: Hitung 10% dari harga secara manual
    
    // Method 1: price - (price / 10)
    int tenPercent = _divideManually_Tio(price, 10);
    
    // Step 2: Kurangi harga dengan 10%
    return price - tenPercent;
  }
  
  // ==================== TOTAL PRICE CALCULATION ====================
  
  // Fungsi 6: Hitung total price manual untuk semua kursi
  static int calculateTotalPriceManual_Tio({
    required String movieTitle,
    required int basePrice,
    required List<String> selectedSeats,
  }) {
    int total = 0;
    
    // Step 1: Hitung title tax (Logic Trap 1)
    int titleTax = calculateTitleTax_Tio(movieTitle);
    
    // Step 2: Loop setiap kursi (Logic Trap 2)
    for (String seat in selectedSeats) {
      int seatPrice = basePrice + titleTax;
      
      // Step 3: Cek apakah kursi genap
      if (isSeatEven_Tio(seat)) {
        seatPrice = calculateEvenSeatDiscount_Tio(seatPrice);
      }
      
      total += seatPrice;
    }
    
    return total;
  }
  
  // ==================== HELPER FUNCTIONS (PRIVATE) ====================
  
  // Fungsi pembagian manual (untuk diskon 10%)
  static int _divideManually_Tio(int numerator, int denominator) {
    if (denominator == 0) return 0;
    
    // Manual division untuk 10% discount
    int result = 0;
    int temp = numerator;
    
    while (temp >= denominator) {
      temp -= denominator;
      result++;
    }
    
    return result;
  }
}