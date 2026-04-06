import 'package:flutter/material.dart';

import '../models/item.dart';

class ItemFormDraft {
  const ItemFormDraft({
    required this.name,
    required this.quantity,
    required this.price,
    required this.isAvailable,
  });

  final String name;
  final int quantity;
  final double price;
  final bool isAvailable;
}

class ItemFormSheet extends StatefulWidget {
  const ItemFormSheet({super.key, this.initialItem, required this.onSubmit});

  final Item? initialItem;
  final Future<void> Function(ItemFormDraft draft) onSubmit;

  @override
  State<ItemFormSheet> createState() => _ItemFormSheetState();
}

class _ItemFormSheetState extends State<ItemFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  late final TextEditingController _priceController;
  late bool _isAvailable;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final item = widget.initialItem;
    _nameController = TextEditingController(text: item?.name ?? '');
    _quantityController = TextEditingController(
      text: item?.quantity.toString() ?? '0',
    );
    _priceController = TextEditingController(
      text: item?.price.toStringAsFixed(2) ?? '0.00',
    );
    _isAvailable = item?.isAvailable ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSaving) {
      return;
    }

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
    final price = double.tryParse(_priceController.text.trim()) ?? 0;

    final draft = ItemFormDraft(
      name: _nameController.text.trim(),
      quantity: quantity,
      price: price,
      isAvailable: _isAvailable,
    );

    setState(() {
      _isSaving = true;
    });

    try {
      await widget.onSubmit(draft);
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.initialItem == null
                ? 'Item added successfully.'
                : 'Item updated successfully.',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Save failed: $error'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialItem != null;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, bottomInset + 16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isEditing ? 'Edit Item' : 'Add Item',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final text = (value ?? '').trim();
                    if (text.isEmpty) {
                      return 'Please enter an item name.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final parsed = int.tryParse((value ?? '').trim());
                    if (parsed == null || parsed < 0) {
                      return 'Enter a valid quantity (0 or more).';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _priceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final parsed = double.tryParse((value ?? '').trim());
                    if (parsed == null || parsed < 0) {
                      return 'Enter a valid price (0 or more).';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Available'),
                  value: _isAvailable,
                  onChanged: _isSaving
                      ? null
                      : (value) {
                          setState(() {
                            _isAvailable = value;
                          });
                        },
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: _isSaving ? null : _submit,
                  icon: _isSaving
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(
                    _isSaving ? 'Saving...' : (isEditing ? 'Update' : 'Create'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
