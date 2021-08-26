import 'package:flutter/material.dart';
import 'package:lightnote/model/consumption.dart';
import 'package:provider/provider.dart';

class TimePicker extends StatefulWidget {
  const TimePicker({Key? key}) : super(key: key);

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  DateTime _time = DateTime.now();

  @override
  void initState() {
    if (mounted) {
      setState(() {
        _time = DateTime.now();
      });
    }
    super.initState();
  }

  @override
  // ignore: must_call_super
  void didChangeDependencies() {
    WidgetsBinding.instance?.addPostFrameCallback(
        (_) => context.read<ComsumptionModel>().setTime(_time));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020, 6),
                    lastDate: DateTime.now(),
                    initialDatePickerMode: DatePickerMode.day)
                .then((value) {
              if (value != null) {
                print(value.day);
                setState(() {
                  _time = value;
                  context.read<ComsumptionModel>().setTime(value);
                });
              }
            });
          },
          child: Text(_time.year.toString() +
              '-' +
              _time.month.toString() +
              '-' +
              _time.day.toString()),
        ),
      ],
    );
  }
}
