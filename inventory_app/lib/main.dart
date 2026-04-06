import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'models/item.dart';
import 'services/item_firestore_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? initError;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (error) {
    initError = error.toString();
    if (kDebugMode) {
      debugPrint('Firebase initialization failed: $error');
    }
  }

  runApp(MyApp(initializationError: initError));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.initializationError});

  final String? initializationError;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: InventoryHomePage(initializationError: initializationError),
    );
  }
}

class InventoryHomePage extends StatefulWidget {
  const InventoryHomePage({super.key, this.initializationError});

  final String? initializationError;

  @override
  State<InventoryHomePage> createState() => _InventoryHomePageState();
}

class _InventoryHomePageState extends State<InventoryHomePage> {
  ItemFirestoreService? _itemService;

  @override
  void initState() {
    super.initState();
    if (widget.initializationError == null) {
      _itemService = ItemFirestoreService();
    }
  }

  Future<void> _addSampleItem() async {
    final service = _itemService;
    if (service == null) {
      return;
    }

    await service.createItem(
      name: 'Item ${DateTime.now().millisecondsSinceEpoch % 10000}',
      quantity: 1,
      price: 19.99,
    );
  }

  @override
  Widget build(BuildContext context) {
    final initializationError = widget.initializationError;
    final service = _itemService;

    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: initializationError != null
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Firebase is not fully configured for this platform. '
                'Run flutterfire configure for your target platform.\n\n'
                'Details: $initializationError',
              ),
            )
            : service == null
            ? const SizedBox.shrink()
            : StreamBuilder<List<Item>>(
              stream: service.watchItems(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error loading items: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final items = snapshot.data!;
                if (items.isEmpty) {
                  return const Center(child: Text('No items yet. Add one.'));
                }

                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text(
                        'Qty: ${item.quantity} | '
                        'Price: ${item.price.toStringAsFixed(2)}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => service.deleteItem(item.id),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: initializationError != null
          ? null
          : FloatingActionButton.extended(
              onPressed: _addSampleItem,
              icon: const Icon(Icons.add),
              label: const Text('Add Item'),
            ),
    );
  }
}
