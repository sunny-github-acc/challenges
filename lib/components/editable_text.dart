import 'package:challenges/components/modal.dart';
import 'package:challenges/components/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextInput extends StatefulWidget {
  final String text;
  final String hint;
  final bool isTitle;
  final void Function(String) onSave;
  final bool isTextRequired;
  final int? minValue;
  final int? maxValue;
  final int? limit;

  const CustomTextInput({
    super.key,
    required this.text,
    required this.onSave,
    this.hint = '',
    this.isTitle = false,
    this.isTextRequired = false,
    this.minValue,
    this.maxValue,
    this.limit,
  });

  @override
  CustomTextInputState createState() => CustomTextInputState();
}

class CustomTextInputState extends State<CustomTextInput> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late String labelText;
  late String limitText;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();

    limitText = '(Reached limit ${widget.limit})';

    setState(() {
      labelText = widget.limit == widget.text.length ? limitText : '';
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    handleSubmit(String input) {
      if (widget.minValue != null) {
        if (input.isEmpty) {
          return Modal.show(context, 'Oops', 'Input cannot be empty');
        } else if (input.length < widget.minValue!) {
          return Modal.show(context, 'Oops',
              'Input must be at least ${widget.minValue} characters long');
        }
      }

      if (widget.maxValue != null) {
        if (input.length > widget.maxValue!) {
          return Modal.show(context, 'Oops',
              'Input must be at most ${widget.maxValue} characters long');
        }
      }

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

            WidgetsBinding.instance.addPostFrameCallback((_) {
              FocusScope.of(context).requestFocus(_focusNode);
            });
          },
          child: _isEditing
              ? TextField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: labelText,
                    hintText: widget.hint,
                  ),
                  controller: _textEditingController,
                  focusNode: _focusNode,
                  autofocus: true,
                  maxLines: null,
                  inputFormatters: widget.limit != null
                      ? [LengthLimitingTextInputFormatter(widget.limit)]
                      : null,
                  onEditingComplete: () => handleSubmit(
                    _textEditingController.text,
                  ),
                  onChanged: (value) => setState(() {
                    labelText = widget.limit == value.length ? limitText : '';
                  }),
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
