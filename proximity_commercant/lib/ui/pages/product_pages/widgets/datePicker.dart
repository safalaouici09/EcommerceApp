import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:proximity/config/values.dart';
import 'package:proximity_commercant/domain/product_repository/src/product_service.dart';

class DateInput extends StatefulWidget {
  const DateInput({Key? key}) : super(key: key);

  @override
  _DateInputState createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  final _controller = TextEditingController();

  DateTime? _selectedDate;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _controller.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
        Provider.of<ProductService>(context, listen: false)
            .setSelectedDate(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var formattedDate = Provider.of<ProductService>(context, listen: false)
        .formattedDate
        .toString();
    /*if (formattedDate != null) {
      _controller.text = formattedDate;
    }*/

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: normal_100),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                // initialValue:
                //    Provider.of<ProductService>(context, listen: false)
                //      .formattedDate,
                controller: _controller,
                //initialValue: ,
                //  focusNode: _focus,

                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),

                decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).dividerColor),
                      borderRadius: const BorderRadius.all(smallRadius),
                    ),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(
                      color: (() {
                        return Theme.of(context).primaryColor;
                      })(),
                    )),
                    border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(normalRadius)),
                    label: Text('yyyy-MM-dd',
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).textTheme.bodyText2!.color)),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                    contentPadding: null),
                onTap: () => _selectDate(context),
              ),
            ]));
  }
}
    /* TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'yyyy-MM-dd',
        labelText: 'Date',
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () => _selectDate(context),
        ),
      ),
      onTap: () => _selectDate(context),
      keyboardType: TextInputType.datetime,
    )*/