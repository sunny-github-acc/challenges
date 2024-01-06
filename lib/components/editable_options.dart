import 'package:challenges/components/button.dart';
import 'package:challenges/components/row.dart';
import 'package:challenges/components/text.dart';
import 'package:flutter/material.dart';

class EditableOptionsWidget extends StatefulWidget {
  final String option;
  final List options;
  final void Function(String) onSave;

  const EditableOptionsWidget({
    super.key,
    required this.option,
    required this.options,
    required this.onSave,
  });

  @override
  _EditableOptionsWidgetState createState() => _EditableOptionsWidgetState();
}

class _EditableOptionsWidgetState extends State<EditableOptionsWidget> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    handleSubmit(String input) {
      widget.onSave(input);
      setState(() {
        _isEditing = false;
      });
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _isEditing = true;
        });
      },
      child: _isEditing
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: CustomRow(
                children: widget.options.map((option) {
                  return CustomButton(
                    type: option == widget.option
                        ? ButtonType.primary
                        : ButtonType.secondary,
                    text: option,
                    size: ButtonSize.small,
                    onPressed: () {
                      handleSubmit(option);
                    },
                  );
                }).toList(),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey), // Set border properties
                borderRadius:
                    BorderRadius.circular(5.0), // Optional: Set border radius
              ),
              child: TextCustom(
                text: widget.option,
                fullWidth: true,
              )),
    );
  }
}
