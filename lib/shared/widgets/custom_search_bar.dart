
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onBack;
  final bool hasBackButton;
  final List<Widget>? trailing;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.onClear,
    this.onBack,
    this.hasBackButton = true,
    this.trailing,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: SearchBar(
        constraints: const BoxConstraints(minHeight: 48, maxHeight: 48),
        controller: widget.controller,
        hintText: widget.hintText,
        elevation: WidgetStateProperty.all(0.0),
        backgroundColor: WidgetStateProperty.all(Colors.white),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
        ),
        onChanged: widget.onChanged,
        leading: widget.hasBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onBack ?? () => Navigator.of(context).pop(),
              )
            : null,
        trailing: widget.trailing ??
            [
              if (widget.controller.text.isNotEmpty)
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/cancel.svg',
                    width: 20,
                    height: 20,
                  ),
                  onPressed: widget.onClear ??
                      () {
                        widget.controller.clear();
                        widget.onChanged('');
                      },
                ),
            ],
      ),
    );
  }
}
