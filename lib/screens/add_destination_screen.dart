import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/destination.dart';

/// Form screen. Stateful because every input is reactive; the constructed
/// [Destination] is returned to the caller through [Navigator.pop].
class AddDestinationScreen extends StatefulWidget {
  const AddDestinationScreen({super.key});

  @override
  State<AddDestinationScreen> createState() => _AddDestinationScreenState();
}

class _AddDestinationScreenState extends State<AddDestinationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  Category _category = Category.city;
  bool _isVisited = false;

  bool get _isValid =>
      _nameController.text.trim().isNotEmpty &&
      _countryController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    // Rebuild the button's enabled state as the user types.
    _nameController.addListener(() => setState(() {}));
    _countryController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _countryController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final website = _websiteController.text.trim();
    Navigator.pop(
      context,
      Destination(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        country: _countryController.text.trim(),
        category: _category,
        description: 'A place added by you.',
        imagePath: _category.imagePath,
        latitude: 0,
        longitude: 0,
        websiteUrl: website.isEmpty ? null : website,
        rating: 0,
        isVisited: _isVisited,
      ),
    );
  }

  void _cancel() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a destination')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Where do you want to go?',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Place name',
                    hintText: 'e.g. Kyoto',
                    prefixIcon: Icon(Icons.place_outlined),
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Enter a place name'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _countryController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Country',
                    hintText: 'e.g. Japan',
                    prefixIcon: Icon(Icons.flag_outlined),
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Enter a country'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _websiteController,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    labelText: 'Website (optional)',
                    hintText: 'https://...',
                    prefixIcon: Icon(Icons.language),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Type of place',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                RadioGroup<Category>(
                  groupValue: _category,
                  onChanged: (selected) {
                    if (selected != null) {
                      setState(() => _category = selected);
                    }
                  },
                  child: Column(
                    children: [
                      for (final value in Category.values)
                        RadioListTile<Category>(
                          value: value,
                          title: Text(value.label),
                          secondary: Icon(
                            value == Category.beach
                                ? Icons.beach_access_outlined
                                : value == Category.mountain
                                    ? Icons.terrain_outlined
                                    : value == Category.culture
                                        ? Icons.museum_outlined
                                        : Icons.location_city_outlined,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  value: _isVisited,
                  title: const Text('I have already visited'),
                  secondary: const Icon(Icons.check_circle_outline),
                  onChanged: (value) =>
                      setState(() => _isVisited = value ?? false),
                ),
                const SizedBox(height: 28),
                ElevatedButton.icon(
                  onPressed: _isValid ? _submit : null,
                  icon: const Icon(Icons.add),
                  label: const Text('Add to my list'),
                ),
                TextButton(
                  onPressed: _cancel,
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
