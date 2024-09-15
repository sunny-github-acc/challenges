import 'package:challenges/components/text.dart';
import 'package:flutter/material.dart';

class EditableTextWidget extends StatefulWidget {
  final String text;
  final String hint;
  final bool isTitle;
  final void Function(String) onSave;
  final bool isTextRequired;

  const EditableTextWidget({
    super.key,
    required this.text,
    required this.onSave,
    this.hint = '',
    this.isTitle = false,
    this.isTextRequired = false,
  });

  @override
  EditableTextWidgetState createState() => EditableTextWidgetState();
}

class EditableTextWidgetState extends State<EditableTextWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isEditing = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    handleSubmit(String input) {
      if (_textEditingController.text != widget.text &&
          (widget.isTextRequired ? _textEditingController.text != '' : true)) {
        widget.onSave(input);
      }
      setState(() {
        _isEditing = false;
      });
    }

    return GestureDetector(
      child: Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus && _isEditing) {
            handleSubmit(_textEditingController.text);
          }
        },
        child: GestureDetector(
          onTap: () {
            setState(() {
              _isEditing = true;
              _textEditingController.text = widget.text;
            });
            FocusScope.of(context).requestFocus(_focusNode);
          },
          child: _isEditing
              ? SizedBox(
                  height: 40.0,
                  child: TextField(
                    controller: _textEditingController,
                    focusNode: _focusNode,
                    onEditingComplete: () => handleSubmit(
                      _textEditingController.text,
                    ),
                  ),
                )
              : CustomText(
                  text: widget.text.trim() != '' ? widget.text : widget.hint,
                  fontSize:
                      widget.isTitle ? FontSizeType.large : FontSizeType.medium,
                ),
        ),
      ),
    );
  }
}
