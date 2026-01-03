import 'package:flutter/material.dart';
import 'package:motify/core/auth_guard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'controller/quote_controller.dart';
import 'controller/auth_controller.dart';

import 'pages/register_page.dart';

import 'pages/home_page.dart';
import 'pages/explore_page.dart';
import 'pages/favorite_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://avxuzbjqoafdbtzvvpdj.supabase.co',
    anonKey:
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF2eHV6Ympxb2FmZGJ0enZ2cGRqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjcyODYwNzIsImV4cCI6MjA4Mjg2MjA3Mn0.h3pHRIe3EOsJxYvjS9u5aXT85uSx9M9WWhH_eOgusnY',
  );

  runApp(MotifyApp());
}

class MotifyApp extends StatelessWidget {
  final AuthController authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.green[500]),
          titleTextStyle: TextStyle(
            color: Colors.green[500],
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
      home: AuthGate(authController: authController),
    );
  }
}

class HomeShell extends StatefulWidget {
  final QuoteController controller;
  final AuthController authController;

  const HomeShell({
    Key? key,
    required this.controller,
    required this.authController,
  }) : super(key: key);

  @override
  _HomeShellState createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (ok == true) {
      await widget.authController.logout(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Motify'),
          actions: [
            IconButton(
              icon: Icon(Icons.filter_list, color: Colors.green[500]),
              onPressed: _showCategorySelector,
              tooltip: 'Filter by category',
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.green[900],
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.green[700],
            tabs: const [
              Tab(text: 'Home'),
              Tab(text: 'List Quote'),
              Tab(text: 'Favorite'),
            ],
          ),
        ),
        drawer: Drawer(
          child: SafeArea(
            child: Column(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.green[50]),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.green[200],
                        child: Icon(
                          Icons.self_improvement,
                          size: 36,
                          color: Colors.green[900],
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Motify',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[900],
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Kata Kata Hari ini',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home, color: Colors.green[900]),
                  title: Text('Home'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _tabController.animateTo(0);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.category, color: Colors.green[900]),
                  title: Text('Categories'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showCategorySelector();
                  },
                ),
                Spacer(),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red[700]),
                  title: Text(
                    'Logout',
                    style: TextStyle(color: Colors.red[700]),
                  ),
                  onTap: () => _confirmLogout(context),
                ),
               
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            HomePage(
              controller: widget.controller,
              authController: widget.authController, 
            ),
            ExplorePage(controller: widget.controller),
            FavoritesPage(controller: widget.controller),
          ],
        ),
      ),
    );
  }

  void _showCategorySelector() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih Kategori',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            ...['All', 'motivasi', 'pelajaran', 'kehidupan', 'karir']
                .map(
                  (c) => ListTile(
                    title: Text(c),
                    trailing: widget.controller.selectedCategory == c
                        ? Icon(Icons.check)
                        : null,
                    onTap: () {
                      widget.controller.setSelectedCategory(c);
                      Navigator.of(ctx).pop();
                    },
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}
