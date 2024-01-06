import 'package:flutter/material.dart';

import 'package:challenges/components/date.dart';
import 'package:challenges/components/text.dart';

class EditableDateWidget extends StatefulWidget {
  final String text;
  final bool isTextRequired;
  final DateTime? customEndDate;
  final void Function(DateTime) onSave;

  const EditableDateWidget({
    Key? key,
    required this.text,
    this.customEndDate,
    this.isTextRequired = false,
    required this.onSave,
  }) : super(key: key);

  @override
  State<EditableDateWidget> createState() => _EditableDateWidgetState();
}

class _EditableDateWidgetState extends State<EditableDateWidget> {
  bool _isEditing = false;
  late String text = widget.text;
  late DateTime? customEndDate = widget.customEndDate;

  @override
  void didUpdateWidget(covariant EditableDateWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.customEndDate != oldWidget.customEndDate) {
      setState(() {
        customEndDate = widget.customEndDate;
        text = widget.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    handleSubmit(DateTime input) {
      widget.onSave(input);
      setState(() {
        _isEditing = false;
      });
    }

    return GestureDetector(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isEditing = true;
          });
        },
        child: _isEditing
            ? SizedBox(
                child: CustomDateRangePicker(
                customEndDate: customEndDate,
                onSelected: (date) {
                  handleSubmit(date.end);
                },
              ))
            : Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: TextCustom(
                  text: text,
                  fullWidth: true,
                )),
      ),
    );
  }
}
