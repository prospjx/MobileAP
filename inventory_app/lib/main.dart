import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'models/item.dart';
import 'services/item_firestore_service.dart';
import 'widgets/item_form_sheet.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const InventoryApp());
}

class InventoryApp extends StatelessWidget {
  const InventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventory App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const FirebaseBootstrapPage(),
    );
  }
}

class FirebaseBootstrapPage extends StatelessWidget {
  const FirebaseBootstrapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Connecting to Firebase...'),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 52,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Firebase initialization failed',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('${snapshot.error}', textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          );
        }

        return const InventoryHomePage();
      },
    );
  }
}

class InventoryHomePage extends StatefulWidget {
  const InventoryHomePage({super.key});

  @override
  State<InventoryHomePage> createState() => _InventoryHomePageState();
}

class _InventoryHomePageState extends State<InventoryHomePage> {
  final ItemFirestoreService _service = ItemFirestoreService();

  Future<void> _openItemForm({Item? item}) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ItemFormSheet(
          initialItem: item,
          onSubmit: (draft) async {
            if (item == null) {
              await _service.createItem(
                Item(
                  name: draft.name,
                  quantity: draft.quantity,
                  price: draft.price,
                  isAvailable: draft.isAvailable,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ),
              );
            } else {
              await _service.updateItem(
                item.copyWith(
                  name: draft.name,
                  quantity: draft.quantity,
                  price: draft.price,
                  isAvailable: draft.isAvailable,
                ),
              );
            }
          },
        );
      },
    );
  }

  Future<void> _deleteItem(Item item) async {
    final itemId = item.id;
    if (itemId == null) {
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete item?'),
          content: Text('This will permanently delete "${item.name}".'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await _service.deleteItem(itemId);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Deleted ${item.name}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Inventory')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openItemForm(),
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
      body: StreamBuilder<List<Item>>(
        stream: _service.watchItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Loading inventory...'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off, size: 52, color: Colors.red),
                    const SizedBox(height: 12),
                    const Text(
                      'Could not load inventory',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('${snapshot.error}', textAlign: TextAlign.center),
                  ],
                ),
              ),
            );
          }

          final items = snapshot.data ?? const <Item>[];
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.inventory_2_outlined, size: 56),
                    const SizedBox(height: 12),
                    const Text(
                      'No items yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tap Add Item to create your first inventory record.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => _openItemForm(),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Item'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                child: ListTile(
                  title: Text(item.name),
                  subtitle: Text(
                    'Qty: ${item.quantity}  •  Price: \$${item.price.toStringAsFixed(2)}',
                  ),
                  leading: Icon(
                    item.isAvailable ? Icons.check_circle : Icons.pause_circle,
                    color: item.isAvailable ? Colors.green : Colors.orange,
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        await _openItemForm(item: item);
                      }
                      if (value == 'delete') {
                        await _deleteItem(item);
                      }
                    },
                    itemBuilder: (context) {
                      return const [
                        PopupMenuItem<String>(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ];
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
