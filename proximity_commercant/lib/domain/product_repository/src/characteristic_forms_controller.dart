import 'package:flutter/material.dart';
import 'package:proximity/domain_repository/models/validation_item.dart';

class CharacteristicFormsController extends ChangeNotifier {
  late Map<String, Set<String>> characteristics;

  //late String _tempValue;
  ValidationItem _tempValue = ValidationItem(null, null);
  ValidationItem _tempOption = ValidationItem(null, null);

  ValidationItem get tempValue => _tempValue;

  ValidationItem get tempOption => _tempOption;

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
    // _tempValue = '';
    // _tempOption = ValidationItem('', null);
    ;
    notifyListeners();
  }

  void addOption() {
    if (_tempOption.value != '') {
      characteristics.addEntries([MapEntry(_tempOption.value!, <String>{})]);
    }
    notifyListeners();
  }

  void removeOption(String value) {
    characteristics.remove(value);
    notifyListeners();
  }

  /* void changeOption(String value) {
    _tempOption = value;
    notifyListeners();
  }*/
  void changeOption(String value) {
    if (value == '') {
      _tempOption = ValidationItem(null, null);
      notifyListeners();
    } else {
      bool _optionValid = RegExp(r'^[a-zA-Z]+$').hasMatch(value);
      print(_optionValid);
      if (_optionValid) {
        _tempOption = ValidationItem(value, null);
      } else {
        _tempOption = ValidationItem(null,
            "Option cannot contain numbers, spaces, or alphanumeric characters.");
      }
      print(_tempOption.value);
      notifyListeners();
    }
  }

  void addValue(String option) {
    if (_tempValue != '') {
      characteristics[option]!.add(_tempValue.value!);
    }
    notifyListeners();
  }

  void removeValue(String option, value) {
    characteristics[option]!.remove(value);
    notifyListeners();
  }

  /* void changeValue(String value) {
    _tempValue = value;
    notifyListeners();
  }*/
  void changeValue(String value) {
    if (value == '') {
      _tempValue = ValidationItem(null, "Value cannot be empty.");
      notifyListeners();
    } else {
      bool _valueValid = RegExp(r'^[A-Za-z0-9]+$').hasMatch(value);

      if (_valueValid) {
        _tempValue = ValidationItem(value, null);
      } else {
        _tempValue =
            ValidationItem(null, "Value can only contain numbers or letters.");
      }
      notifyListeners();
    }
  }
}
