
import 'package:flutter/material.dart';

class AddVariantsScreen extends StatefulWidget {
  const AddVariantsScreen({super.key});

  @override
  State<AddVariantsScreen> createState() => _AddVariantsScreenState();
}

class _AddVariantsScreenState extends State<AddVariantsScreen> {
  final List<TextEditingController> _optionControllers = [];
  // Each option will have a list of value controllers
  final List<List<TextEditingController>> _valueControllers = [];
  final List<String> _optionPlaceholders = ['Size', 'Color', 'Material'];
  // Each option will have a list of value placeholders
  final List<List<String>> _valuePlaceholders = [
    ['Small', 'Medium', 'Large'], // Placeholders for Size
    ['Red', 'Blue', 'Green'], // Placeholders for Color
    ['Cotton', 'Silk', 'Nylon'] // Placeholders for Material
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with one option
    _addOption();
  }

  void _addOption() {
    if (_optionControllers.length < 3) {
      setState(() {
        _optionControllers.add(TextEditingController());
        // Add a list for the new option's values, starting with one value field
        _valueControllers.add([TextEditingController()]);
      });
    }
  }

  void _addValue(int optionIndex) {
    setState(() {
      _valueControllers[optionIndex].add(TextEditingController());
    });
  }

  void _removeOption(int optionIndex) {
    // First, dispose the controllers that will be removed.
    _optionControllers[optionIndex].dispose();
    for (var controller in _valueControllers[optionIndex]) {
      controller.dispose();
    }
    // Then, remove them from the lists.
    setState(() {
      _optionControllers.removeAt(optionIndex);
      _valueControllers.removeAt(optionIndex);
    });
  }

  void _removeValue(int optionIndex, int valueIndex) {
    // First, dispose the controller that will be removed.
    _valueControllers[optionIndex][valueIndex].dispose();
    // Then, remove it from the list.
    setState(() {
      _valueControllers[optionIndex].removeAt(valueIndex);
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
              // TODO: Save variants logic
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
              TextFormField(
                controller: _optionControllers[i],
                decoration: InputDecoration(
                  labelText: 'Variant name',
                  hintText: 'e.g., ${_optionPlaceholders[i]}',
                  border: const OutlineInputBorder(),
                ),
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
