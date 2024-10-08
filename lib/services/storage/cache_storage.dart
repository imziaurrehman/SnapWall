import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheStorage {
  static const String _keyData = 'myData';
  static const String _keyExpiration = 'expirationTime';

  // Function to save data with an expiration date to SharedPreferences
  Future<bool> saveDataWithExpiration(
      String data, Duration expirationDuration) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      DateTime expirationTime = DateTime.now().add(expirationDuration);
      await prefs.setString(_keyData, data);
      await prefs.setString(_keyExpiration, expirationTime.toIso8601String());
      debugPrint('Data saved to SharedPreferences.');
      return true;
    } catch (e) {
      debugPrint('Error saving data to SharedPreferences: $e');
      return false;
    }
  }

  // Function to get data from SharedPreferences if it's not expired
  Future<String?> getDataIfNotExpired() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? data = prefs.getString(_keyData);
      String? expirationTimeStr = prefs.getString(_keyExpiration);
      if (data == null || expirationTimeStr == null) {
        debugPrint('No data or expiration time found in SharedPreferences.');
        return null; // No data or expiration time found.
      }

      DateTime expirationTime = DateTime.parse(expirationTimeStr);
      if (expirationTime.isAfter(DateTime.now())) {
        debugPrint('Data has not expired.');
        // The data has not expired.
        return data;
      } else {
        // Data has expired. Remove it from SharedPreferences.
        await prefs.remove(_keyData);
        await prefs.remove(_keyExpiration);
        debugPrint('Data has expired. Removed from SharedPreferences.');
        return null;
      }
    } catch (e) {
      debugPrint('Error retrieving data from SharedPreferences: $e');
      return null;
    }
  }

  // Function to clear data from SharedPreferences
  Future<void> clearData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyData);
      await prefs.remove(_keyExpiration);
      debugPrint('Data cleared from SharedPreferences.');
    } catch (e) {
      debugPrint('Error clearing data from SharedPreferences: $e');
    }
  }
}
