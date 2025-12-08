
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/providers/store_provider.dart';
import 'package:provider/provider.dart';

class StoreSetupScreen extends StatefulWidget {
  const StoreSetupScreen({super.key});

  @override
  State<StoreSetupScreen> createState() => _StoreSetupScreenState();
}

class _StoreSetupScreenState extends State<StoreSetupScreen> {
  final _storeNameController = TextEditingController();
  File? _logo;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _logo = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Set Up Your Store',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _logo != null ? FileImage(_logo!) : null,
                child: _logo == null
                    ? const Icon(
                        Icons.add_a_photo,
                        size: 30,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text('Add Store Logo'),
            const SizedBox(height: 24.0),
            TextField(
              controller: _storeNameController,
              decoration: const InputDecoration(
                labelText: 'Store Name',
              ),
            ),
            const SizedBox(height: 24.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final storeProvider = Provider.of<StoreProvider>(context, listen: false);
                  storeProvider.setStore(_logo, _storeNameController.text);
                  context.go('/home');
                },
                child: const Text('Create Store'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
