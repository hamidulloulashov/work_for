import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// LocalStorage – savat va foydalanuvchi sozlamalarini saqlash va yuklash
class LocalStorage {
  static const String _cartKey = 'shopping_cart_items';
  static const String _userPrefsKey = 'user_preferences';

  SharedPreferences? _prefs;

  // SharedPreferences ni ishga tushirish
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Savatdagi mahsulotlarni local storage dan yuklash
  Future<List<Map<String, dynamic>>> loadCartItems() async {
    await init();
    try {
      final rawData = _prefs?.getString(_cartKey) ?? '[]';
      final List<dynamic> decodedData = json.decode(rawData);
      return decodedData
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } catch (e) {
      print('Error loading cart items: $e');
      return [];
    }
  }

  // Savatdagi mahsulotlarni local storage ga saqlash
  Future<bool> saveCartItems(List<Map<String, dynamic>> items) async {
    await init();
    try {
      final encodedData = json.encode(items);
      return await _prefs?.setString(_cartKey, encodedData) ?? false;
    } catch (e) {
      print('Error saving cart items: $e');
      return false;
    }
  }

  // Savatni tozalash
  Future<bool> clearCartItems() async {
    await init();
    try {
      return await _prefs?.remove(_cartKey) ?? false;
    } catch (e) {
      print('Error clearing cart items: $e');
      return false;
    }
  }

  // Foydalanuvchi sozlamalarini yuklash
  Future<Map<String, dynamic>> loadUserPreferences() async {
    await init();
    try {
      final rawData = _prefs?.getString(_userPrefsKey) ?? '{}';
      return Map<String, dynamic>.from(json.decode(rawData));
    } catch (e) {
      print('Error loading user preferences: $e');
      return {};
    }
  }

  // Foydalanuvchi sozlamalarini saqlash
  Future<bool> saveUserPreferences(Map<String, dynamic> prefs) async {
    await init();
    try {
      final encodedData = json.encode(prefs);
      return await _prefs?.setString(_userPrefsKey, encodedData) ?? false;
    } catch (e) {
      print('Error saving user preferences: $e');
      return false;
    }
  }

  // Legacy methodlar – backward compatibility uchun
  Future<List<Map<String, dynamic>>> load() => loadCartItems();
  Future<void> save(List<Map<String, dynamic>> items) => saveCartItems(items);
}
