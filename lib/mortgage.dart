import 'dart:math';
import 'package:intl/intl.dart';
import 'sharedpreferences.dart';
import 'package:flutter/material.dart';

class MortgageProvider with ChangeNotifier {
  final NumberFormat money = NumberFormat("\$#,##0.00", 'en_US');
  double _amount;
  int _years;
  double _rate;
  
  MortgageProvider() :
    _amount = SharedPreferencesHelper.getDouble(SharedPreferencesKeys.amount) ?? 100000,
    _years = SharedPreferencesHelper.getInt(SharedPreferencesKeys.years) ?? 30,
    _rate = SharedPreferencesHelper.getDouble(SharedPreferencesKeys.rate) ?? 0.035;

  void setAmount(double newAmount) { 
    if (newAmount >= 0) _amount = newAmount; 
    notifyListeners();
  }
  void setYears(int newYears) { 
    if (newYears >= 0) _years = newYears; 
    notifyListeners();
  }
  void setRate(double newRate) { 
    if (newRate >= 0) _rate = newRate; 
    notifyListeners();
  }
  double getAmount() { return _amount; }
  int getYears() { return _years; }
  double getRate() { return _rate; }
  String? getFormattedAmount() { return money.format(_amount); }
  String? getFormattedRate() { return "${(_rate * 100).toStringAsPrecision(3)}%"; }

  Future<List<bool>> saveToSharedPreferences() async {
    return Future.wait([
      SharedPreferencesHelper.setDouble(SharedPreferencesKeys.amount, _amount),
      SharedPreferencesHelper.setInt(SharedPreferencesKeys.years, _years),
      SharedPreferencesHelper.setDouble(SharedPreferencesKeys.rate, _rate)
    ]);
  }

  double monthlyPayment() {
    var mRate = _rate / 12;
    var temp = pow(1 / (1 + mRate), _years * 12);
    return _amount * mRate / (1 - temp);
  }
  String? formattedMonthlyPayment() { return money.format(monthlyPayment()); }

  double totalPayment() { return monthlyPayment() * _years * 12; }
  String? formattedTotalPayment() { return money.format(totalPayment()); } 
}  