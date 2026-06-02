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
      body: IndexedStack(index: _selectedIndex, children: screens),
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

class MonAnListPage extends StatefulWidget {
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
  State<MonAnListPage> createState() => _MonAnListPageState();
}

class _MonAnListPageState extends State<MonAnListPage> {
  // [YÊU CẦU 1] 1. Khai báo TextEditingController để quản lý TextField
  final TextEditingController _searchController = TextEditingController();
  // Biến lưu trữ chuỗi tìm kiếm để hiển thị
  String _searchText = "";

  // [YÊU CẦU 1] 2. Hàm xử lý khi người dùng gõ phím
  void _onSearchChanged(String value) {
    setState(() {
      _searchText = _searchController.text; // Lấy dữ liệu từ controller
    });
  }

  @override
  void dispose() {
    _searchController.dispose(); // Bắt buộc hủy controller để tránh tràn bộ nhớ
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final monAns = context.read<AppRepository>().getMonAns();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
        ), // Lưu ý: dùng widget.title do đã chuyển sang StatefulWidget
        actions: [
          IconButton(
            tooltip: 'Giỏ hàng',
            icon: Badge(
              label: Text('${context.watch<CartNotifier>().totalQuantity}'),
              isLabelVisible: context.watch<CartNotifier>().totalQuantity > 0,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            onPressed: () {
              widget.onOpenCart?.call();
            },
          ),
          IconButton(
            tooltip: 'Đơn hàng của tôi',
            icon: const Icon(Icons.receipt_long),
            onPressed: () {
              widget.onOpenOrders?.call();
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- [YÊU CẦU 1] BẮT ĐẦU: Giao diện TextFormField ---
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextFormField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Tìm kiếm món ăn...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _onSearchChanged, // Bắt sự kiện gõ phím
            ),
          ),
          // Hiển thị đoạn text nếu người dùng có nhập chữ
          if (_searchText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Bạn đang tìm kiếm: $_searchText',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),

          // --- KẾT THÚC YÊU CẦU 1 ---
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: monAns.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final monAn = monAns[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text(monAn.id.toString())),
                    title: Text(monAn.getDisplayName()),
                    subtitle: Text(
                      '${monAn.category} • ${monAn.getFormattedPrice()}',
                    ),
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.receipt_long),
        label: const Text('Đơn hàng của tôi'),
        onPressed: () {
          widget.onOpenOrders?.call();
        },
      ),
    );
  }
}

class MonAnDetailPage extends StatefulWidget {
  const MonAnDetailPage({super.key, required this.monAn});

  final MonAn monAn;

  @override
  State<MonAnDetailPage> createState() => _MonAnDetailPageState();
}

class _MonAnDetailPageState extends State<MonAnDetailPage> {
  // [YÊU CẦU 2] Biến trạng thái để lưu dữ liệu của đối tượng Switch
  bool _isExpressDelivery = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.monAn.getDisplayName())),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.monAn.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('Danh mục: ${widget.monAn.category}'),
            Text('Giá: ${widget.monAn.getFormattedPrice()}'),
            Text('Đánh giá: ${widget.monAn.rating} / 5'),
            const SizedBox(height: 16),
            Text(widget.monAn.description),

            // --- [YÊU CẦU 2] BẮT ĐẦU: Đối tượng lấy dữ liệu KHÁC TextField (Switch) ---
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Giao hàng hỏa tốc',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Switch(
                        value: _isExpressDelivery,
                        activeColor: Colors.deepPurple,
                        onChanged: (bool value) {
                          // Lấy dữ liệu và cập nhật giao diện
                          setState(() {
                            _isExpressDelivery = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Text(
                    _isExpressDelivery
                        ? 'Phí ship +15.000 VNĐ. Giao ngay trong 30 phút!'
                        : 'Giao hàng tiêu chuẩn.',
                    style: TextStyle(
                      color: _isExpressDelivery
                          ? Colors.green[700]
                          : Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            // --- KẾT THÚC YÊU CẦU 2 ---
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<CartNotifier>().addMonAn(widget.monAn);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Đã thêm "${widget.monAn.name}" vào đơn tạm thời',
                      ),
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
