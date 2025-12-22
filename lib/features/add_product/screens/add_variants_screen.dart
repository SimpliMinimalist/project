
import 'package:flutter/material.dart';

class AddVariantsScreen extends StatefulWidget {
  const AddVariantsScreen({super.key});

  @override
  State<AddVariantsScreen> createState() => _AddVariantsScreenState();
}

class _AddVariantsScreenState extends State<AddVariantsScreen> {
  final List<TextEditingController> _optionControllers = [];
  final List<TextEditingController> _valueControllers = [];

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
        _valueControllers.add(TextEditingController());
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    for (var controller in _valueControllers) {
      controller.dispose();
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
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Option ${i + 1}', style: Theme.of(context).textTheme.titleMedium),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      setState(() {
                        _optionControllers.removeAt(i);
                        _valueControllers.removeAt(i);
                      });
                    },
                  )
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _optionControllers[i],
                decoration: const InputDecoration(
                  labelText: 'Option (e.g., Size)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _valueControllers[i],
                decoration: const InputDecoration(
                  labelText: 'Values (comma-separated, e.g., S, M, L)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return fields;
  }
}
