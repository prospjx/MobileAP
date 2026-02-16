import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: _TabsNonScrollableDemo(),
      ),
    );
  }
}

class _TabsNonScrollableDemo extends StatefulWidget {
  @override
  __TabsNonScrollableDemoState createState() =>
      __TabsNonScrollableDemoState();
}

class __TabsNonScrollableDemoState extends State<_TabsNonScrollableDemo>
    with SingleTickerProviderStateMixin, RestorationMixin {
  late TabController _tabController;
  final RestorableInt tabIndex = RestorableInt(0);
  
  Widget tab1(BuildContext context) {
    return Container(
      color: Colors.amber.shade50,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Welcome to Tab 1',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Alert'),
                    content: Text('This is an alert dialog.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Show Alert'),
            ),
          ],
        ),
      ),
    );
  }

  Widget tab2() {
  return Container(
    color: Colors.lightBlue.shade50,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Input Fields
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),

            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),

            // Network Image
            Image.network(
              'https://picsum.photos/200',
              height: 120,
              width: 120,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                // You can add logic here later
                print('Form Submitted');
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget tab3(BuildContext context) {
  return Container(
    color: Colors.green.shade50, // Light green background
    child: Center(
      child: ElevatedButton(
        onPressed: () {
          // Show a SnackBar when clicked
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Button pressed in Tab 3!'),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        child: Text('Click me'),
      ),
    ),
  );
}

Widget tab4() {
  return Container(
    color: Colors.purple.shade50,
    child: ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: 15, // Number of items to build
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.purple,
              child: Text(
                '${index + 1}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              'List Item ${index + 1}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('This is item number ${index + 1}.'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
        );
      },
    ),
  );
}


  @override
  String get restorationId => 'tab_non_scrollable_demo';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    _tabController.index = tabIndex.value;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );

    _tabController.addListener(() {
      setState(() {
        tabIndex.value = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    tabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4'];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Tabs Demo'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          tabs: [
            for (final tab in tabs) Tab(text: tab),
          ],
        ),
      ),
     body: TabBarView(
  controller: _tabController,
  children: [
    tab1(context),                 // 👈 Your custom tab
    tab2(),
    tab3(context),   // Tab 3
    tab4(), // Tab 4
  ],
),

      bottomNavigationBar : BottomAppBar (
        color : Colors . blueGrey . shade50 ,
        child : Padding (
          padding : EdgeInsets . symmetric (
            horizontal : 16.0 , vertical : 12.0
          ),
          child : Row(
            children : [
      Icon ( Icons . home, color : Colors . blueAccent ),
      SizedBox ( width : 12),
      Text (
      'Bottom App Bar' ,
      style : TextStyle ( fontWeight : FontWeight . bold ),
),
],
),
),
      )
    );
  }
}
