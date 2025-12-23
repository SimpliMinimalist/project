import 'package:flutter/material.dart';

class AddVariantsScreen extends StatefulWidget {
  const AddVariantsScreen({super.key});

  @override
  State<AddVariantsScreen> createState() => _AddVariantsScreenState();
}

class _AddVariantsScreenState extends State<AddVariantsScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _optionControllers = [];
  final List<List<TextEditingController>> _valueControllers = [];
  final List<FocusNode> _optionFocusNodes = [];
  final List<List<FocusNode>> _valueFocusNodes = [];
  final List<String> _optionPlaceholders = ['Size', 'Color', 'Material'];
  final List<List<String>> _valuePlaceholders = [
    ['Small', 'Medium', 'Large'],
    ['Red', 'Blue', 'Green'],
    ['Cotton', 'Silk', 'Nylon']
  ];

  @override
  void initState() {
    super.initState();
    _addOption();
  }

  void _addOption() {
    if (_optionControllers.length < 3) {
      final optionController = TextEditingController();
      final focusNode = FocusNode(); // Create a new FocusNode here
      final valueController = TextEditingController();

      setState(() {
        _optionControllers.add(optionController);
        _valueControllers.add([valueController]);
        _optionFocusNodes.add(focusNode); // Add it to the list
        _valueFocusNodes.add([FocusNode()]);
      });
      // Add listener to the new focus node
      focusNode.addListener(_onFocusChange);
    }
  }

  void _onFocusChange() {
    // This rebuilds the UI to update the dynamic label
    setState(() {});
  }

  void _addValue(int optionIndex) {
    final newFocusNode = FocusNode();
    final newValueController = TextEditingController();
    setState(() {
      _valueControllers[optionIndex].add(newValueController);
      _valueFocusNodes[optionIndex].add(newFocusNode);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(newFocusNode);
    });
  }

  void _removeOption(int optionIndex) {
    _optionControllers[optionIndex].dispose();
    for (var controller in _valueControllers[optionIndex]) {
      controller.dispose();
    }
    for (var focusNode in _valueFocusNodes[optionIndex]) {
      focusNode.dispose();
    }
    _optionFocusNodes[optionIndex].removeListener(_onFocusChange); // Remove listener
    _optionFocusNodes[optionIndex].dispose();

    setState(() {
      _optionControllers.removeAt(optionIndex);
      _valueControllers.removeAt(optionIndex);
      _optionFocusNodes.removeAt(optionIndex);
      _valueFocusNodes.removeAt(optionIndex);
    });
  }

  void _removeValue(int optionIndex, int valueIndex) {
    _valueControllers[optionIndex][valueIndex].dispose();
    _valueFocusNodes[optionIndex][valueIndex].dispose();
    setState(() {
      _valueControllers[optionIndex].removeAt(valueIndex);
      _valueFocusNodes[optionIndex].removeAt(valueIndex);
    });
  }

  @override
  void dispose() {
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    for (var valueList in _valueControllers) {
      for (var controller in valueList) {
        controller.dispose();
      }
    }
    for (var focusNode in _optionFocusNodes) {
      focusNode.removeListener(_onFocusChange); // Remove listener on dispose
      focusNode.dispose();
    }
    for (var focusNodeList in _valueFocusNodes) {
      for (var focusNode in focusNodeList) {
        focusNode.dispose();
      }
    }
    super.dispose();
  }

  bool _isFormSufficient() {
    // True if at least one option has a name and at least one value.
    return _optionControllers.any((optCtrl) {
      if (optCtrl.text.trim().isEmpty) return false;
      int index = _optionControllers.indexOf(optCtrl);
      return _valueControllers[index].any((valCtrl) => valCtrl.text.trim().isNotEmpty);
    });
  }

  void _saveVariants() {
    if (_formKey.currentState!.validate()) {
      if (_isFormSufficient()) { // Only pop if the form is also sufficient
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSaveEnabled = _isFormSufficient();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Variants'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              onPressed: _saveVariants, // Always call _saveVariants
              style: ElevatedButton.styleFrom(
                backgroundColor: isSaveEnabled
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade300,
                foregroundColor:
                    isSaveEnabled ? Colors.white : Colors.grey.shade600,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: const Text('Save'),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled, // Form validation still disabled until manual call
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              ..._buildVariantFields(),
              if (_optionControllers.length < 3)
                ElevatedButton.icon(
                  onPressed: _addOption,
                  icon: const Icon(Icons.add),
                  label: const Text('Add another option'),
                ),
              const SizedBox(height: 24),
              Text(
                'In the next step, you will add images, prices, and stock for each variant.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildVariantFields() {
    List<Widget> fields = [];
    for (int i = 0; i < _optionControllers.length; i++) {
      // Determine the dynamic labelText
      final bool isFocused = _optionFocusNodes[i].hasFocus;
      final bool hasText = _optionControllers[i].text.isNotEmpty;
      final String currentPlaceholder = (i < _optionPlaceholders.length)
          ? _optionPlaceholders[i]
          : 'Custom';

      final String dynamicLabelText = (isFocused || hasText)
          ? 'Option name'
          : 'Option name e.g., $currentPlaceholder';

      fields.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Option ${i + 1}',
                      style: Theme.of(context).textTheme.titleMedium),
                  if (_optionControllers.length > 1)
                    IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _removeOption(i))
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _optionControllers[i],
                focusNode: _optionFocusNodes[i],
                decoration: InputDecoration(
                  labelText: dynamicLabelText, // Use dynamic labelText
                  // hintText is removed as per requirement for dynamic labelText
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Option name is required';
                  }
                  return null;
                },
                onChanged: (value) { // Added onChanged callback
                  setState(() {}); // Rebuild to update labelText based on text presence
                },
                autovalidateMode: AutovalidateMode.onUserInteraction, // Changed to onUserInteraction
              ),
              const SizedBox(height: 16),
              Text('Values (${_valueControllers[i].length})',
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    ..._buildValueFields(i),
                    const Divider(height: 1),
                    InkWell(
                      onTap: () => _addValue(i),
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 20),
                            SizedBox(width: 8),
                            Text('Add value'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
    return fields;
  }

  List<Widget> _buildValueFields(int optionIndex) {
    List<Widget> valueFields = [];
    for (int j = 0; j < _valueControllers[optionIndex].length; j++) {
      final String hintText = (optionIndex < _valuePlaceholders.length && j < _valuePlaceholders[optionIndex].length)
          ? 'e.g., ${_valuePlaceholders[optionIndex][j]}'
          : 'Value';

      valueFields.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Row(
          children: [
            const Icon(Icons.drag_handle, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: _valueControllers[optionIndex][j],
                focusNode: _valueFocusNodes[optionIndex][j],
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                ),
                validator: (value) {
                  // Unconditionally make value fields required.
                  if (value == null || value.trim().isEmpty) {
                    return 'Value is required';
                  }
                  return null;
                },
                onChanged: (value) { // Added onChanged callback
                  setState(() {});
                },
                autovalidateMode: AutovalidateMode.onUserInteraction, // Changed to onUserInteraction
              ),
            ),
            if (_valueControllers[optionIndex].length > 1)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.grey),
                onPressed: () => _removeValue(optionIndex, j),
              ),
          ],
        ),
      ));
      if (j < _valueControllers[optionIndex].length - 1) {
        valueFields.add(const Divider(height: 1, indent: 12, endIndent: 12));
      }
    }
    return valueFields;
  }
}