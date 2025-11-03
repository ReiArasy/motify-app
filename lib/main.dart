import 'package:flutter/material.dart';
import 'controller/quote_controller.dart';
import 'pages/home_page.dart';
import 'pages/explore_page.dart';
import 'pages/favorite_pages.dart';

void main() {
  runApp(MotifyApp());
}

class MotifyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final controller = QuoteController();

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
              borderRadius: BorderRadiusGeometry.circular(15),
            ),
          ),
        ),
      ),
      home: HomeShell(controller: controller),
    );
  }
}

class HomeShell extends StatefulWidget {
  final QuoteController controller;
  const HomeShell({Key? key, required this.controller}) : super(key: key);

  @override
  _HomeShellState createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> with SingleTickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Motify'),
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.filter_list, color: Colors.green[500]),
              onPressed: _showCategorySelector,
              tooltip: 'Filter by category',
            ),
            IconButton(
              icon: Icon(Icons.favorite, color: Colors.green[500]),
              onPressed: () => _tabController.animateTo(2),
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.green[900],
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.green[700],
            tabs: [
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
                      CircleAvatar(radius: 36, backgroundColor: Colors.green[200], child: Icon(Icons.self_improvement, size: 36, color: Colors.green[900])),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Motify', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[900])),
                            SizedBox(height: 6),
                            Text('Kata Kata Hari ini', style: TextStyle(color: Colors.grey[700])),
                          ],
                        ),
                      )
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(child: Text('Built with ❤️ Aracii', style: TextStyle(color: Colors.grey[700]))),
                      Text('v1.0', style: TextStyle(color: Colors.grey[500]))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        // TabBarView menggunakan halaman yang sudah dipisahkan
        body: TabBarView(
          controller: _tabController,
          children: [
            HomePage(controller: widget.controller),
            ExplorePage(controller: widget.controller),
            // FavoritesPage(controller: widget.controller),
          ],
        ),
      ),
    );
  }

  void _showCategorySelector() {
    //pop up daribawah
    showModalBottomSheet(
      context: context,
      builder: (ctx) => 
      Container(
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
