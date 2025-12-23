
import 'package:flutter/material.dart';

class AddVariantsScreen extends StatefulWidget {
  const AddVariantsScreen({super.key});

  @override
  State<AddVariantsScreen> createState() => _AddVariantsScreenState();
}

class _AddVariantsScreenState extends State<AddVariantsScreen> {
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
      setState(() {
        _optionControllers.add(TextEditingController());
        _valueControllers.add([TextEditingController()]);
        _optionFocusNodes.add(FocusNode());
        _valueFocusNodes.add([FocusNode()]);
      });
    }
  }

  void _addValue(int optionIndex) {
    final newFocusNode = FocusNode();
    setState(() {
      _valueControllers[optionIndex].add(TextEditingController());
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
      focusNode.dispose();
    }
    for (var focusNodeList in _valueFocusNodes) {
      for (var focusNode in focusNodeList) {
        focusNode.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Variants'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
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
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildVariantFields() {
    List<Widget> fields = [];
    for (int i = 0; i < _optionControllers.length; i++) {
      fields.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Option ${i + 1}', style: Theme.of(context).textTheme.titleMedium),
                  if (_optionControllers.length > 1)
                    IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _removeOption(i),
                    )
                ],
              ),
              const SizedBox(height: 8),
              StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  final focusNode = _optionFocusNodes[i];
                  focusNode.addListener(() {
                    setState(() {});
                  });

                  return TextFormField(
                    controller: _optionControllers[i],
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: focusNode.hasFocus ? 'Variant name' : 'Variant name e.g., ${_optionPlaceholders[i]}',
                      border: const OutlineInputBorder(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Text('Values (${_valueControllers[i].length})', style: Theme.of(context).textTheme.titleSmall),
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
          final String hintText;
          if (optionIndex < _valuePlaceholders.length && j < _valuePlaceholders[optionIndex].length) {
            hintText = 'e.g., ${_valuePlaceholders[optionIndex][j]}';
          } else {
            hintText = 'Value';
          }

          valueFields.add(
              Padding(
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
                              ),
                          ),
                          if (_valueControllers[optionIndex].length > 1)
                            IconButton(
                                icon: const Icon(Icons.delete, color: Colors.grey),
                                onPressed: () => _removeValue(optionIndex, j),
                            ),
                      ],
                  ),
              )
          );
          if (j < _valueControllers[optionIndex].length -1) {
              valueFields.add(const Divider(height: 1, indent: 12, endIndent: 12));
          }
      }
      return valueFields;
  }
}
