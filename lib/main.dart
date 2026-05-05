import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/mon_an.dart';
import 'notifiers/cart_notifier.dart';
import 'pages/don_hang_cua_toi_page.dart';
import 'pages/gio_hang_page.dart';
import 'repositories/app_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => AppRepository(),
      child: Builder(
        builder: (context) {
          final repository = context.read<AppRepository>();
          return ChangeNotifierProvider(
            create: (_) =>
                CartNotifier(initialItems: repository.getInitialCartItems()),
            child: MaterialApp(
              title: 'An Ngon App',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              ),
              home: const MainTabScreen(),
            ),
          );
        },
      ),
    );
  }
}

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      MonAnListPage(
        title: 'Khám phá món ngon',
        onOpenCart: () => _onItemTapped(1),
        onOpenOrders: () => _onItemTapped(2),
      ),
      GioHangPage(
        userId: MonAnListPage.currentUserId,
        onOrderCreatedNavigate: () => _onItemTapped(2),
      ),
      const DonHangCuaToiPage(userId: MonAnListPage.currentUserId),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Giỏ hàng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Đơn hàng',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class MonAnListPage extends StatelessWidget {
  const MonAnListPage({
    super.key,
    required this.title,
    this.onOpenCart,
    this.onOpenOrders,
  });

  static const int currentUserId = 23010438;
  final String title;
  final VoidCallback? onOpenCart;
  final VoidCallback? onOpenOrders;

  @override
  Widget build(BuildContext context) {
    final monAns = context.read<AppRepository>().getMonAns();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        actions: [
          IconButton(
            tooltip: 'Giỏ hàng',
            icon: Badge(
              label: Text('${context.watch<CartNotifier>().totalQuantity}'),
              isLabelVisible: context.watch<CartNotifier>().totalQuantity > 0,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            onPressed: () {
              onOpenCart?.call();
            },
          ),
          IconButton(
            tooltip: 'Đơn hàng của tôi',
            icon: const Icon(Icons.receipt_long),
            onPressed: () {
              onOpenOrders?.call();
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: monAns.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final monAn = monAns[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text(monAn.id.toString()),
              ),
              title: Text(monAn.getDisplayName()),
              subtitle: Text('${monAn.category} • ${monAn.getFormattedPrice()}'),
              trailing: Text('⭐ ${monAn.rating}'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MonAnDetailPage(monAn: monAn),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.receipt_long),
        label: const Text('Đơn hàng của tôi'),
        onPressed: () {
          onOpenOrders?.call();
        },
      ),
    );
  }
}

class MonAnDetailPage extends StatelessWidget {
  const MonAnDetailPage({super.key, required this.monAn});

  final MonAn monAn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(monAn.getDisplayName()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              monAn.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('Danh mục: ${monAn.category}'),
            Text('Giá: ${monAn.getFormattedPrice()}'),
            Text('Đánh giá: ${monAn.rating} / 5'),
            const SizedBox(height: 16),
            Text(monAn.description),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<CartNotifier>().addMonAn(monAn);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã thêm "${monAn.name}" vào đơn tạm thời'),
                    ),
                  );
                },
                child: const Text('Đặt món'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

