import 'package:flutter/material.dart';

class CharacteristicFormsController extends ChangeNotifier {
  late Map<String, Set<String>> characteristics;

  late String _tempValue, _tempOption;

  String get tempValue => _tempValue;

  String get tempOption => _tempOption;

  bool get isValid {
    bool _isValid = true;
    for (var v in characteristics.values) {
      _isValid = _isValid && (v.isNotEmpty);
    }
    return (characteristics.isNotEmpty && _isValid);
  }

  CharacteristicFormsController(Map<String, Set<String>> characteristics) {
    this.characteristics =
        characteristics.map((key, value) => MapEntry(key, value.toSet()));
    _tempValue = '';
    _tempOption = '';
    notifyListeners();
  }

  void addOption() {
    if (_tempOption != '') {
      characteristics.addEntries([MapEntry(_tempOption, <String>{})]);
    }
    notifyListeners();
  }

  void removeOption(String value) {
    characteristics.remove(value);
    notifyListeners();
  }

  void changeOption(String value) {
    _tempOption = value;
    notifyListeners();
  }

  void addValue(String option) {
    if (_tempValue != '') {
      characteristics[option]!.add(_tempValue);
    }
    notifyListeners();
  }

  void removeValue(String option, value) {
    characteristics[option]!.remove(value);
    notifyListeners();
  }

  void changeValue(String value) {
    _tempValue = value;
    notifyListeners();
  }
}
