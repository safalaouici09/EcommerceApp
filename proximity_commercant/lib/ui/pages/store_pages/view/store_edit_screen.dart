import 'package:flutter/material.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_commercant/domain/store_repository/store_repository.dart';
import 'package:proximity_commercant/ui/pages/store_pages/store_pages.dart';

class StoreEditScreen extends StoreCreationScreen {
  const StoreEditScreen({Key? key, required int index, required Store store})
      : super(key: key, index: index, store: store, editScreen: true);
}