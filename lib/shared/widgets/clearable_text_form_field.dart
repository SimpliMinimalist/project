
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ClearableTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? prefixText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final int? maxLines;

  const ClearableTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.prefixText,
    this.keyboardType,
    this.validator,
    this.autovalidateMode,
    this.maxLines,
  });

  @override
  State<ClearableTextFormField> createState() => _ClearableTextFormFieldState();
}

class _ClearableTextFormFieldState extends State<ClearableTextFormField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      decoration: InputDecoration(
        labelText: widget.labelText,
        prefixText: widget.prefixText,
        border: const OutlineInputBorder(),
        suffixIcon: _isFocused && widget.controller.text.isNotEmpty
            ? IconButton(
                icon: SvgPicture.asset('assets/icons/cancel.svg', width: 20, height: 20),
                onPressed: () {
                  widget.controller.clear();
                },
              )
            : null,
      ),
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      maxLines: widget.maxLines,
    );
  }
}
