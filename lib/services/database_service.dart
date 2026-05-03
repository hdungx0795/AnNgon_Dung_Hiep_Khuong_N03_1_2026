import 'package:hive_flutter/hive_flutter.dart';
import 'seeding_service.dart';
import '../models/user_model.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';
import '../models/order_item_model.dart';
import '../models/cart_item_model.dart';
import '../models/review_model.dart';
import '../models/voucher_model.dart';
import '../models/chat_message_model.dart';
import '../models/user_prefs_model.dart';
import '../models/enums/category.dart';
import '../models/enums/order_status.dart';
import '../models/enums/payment_method.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._();
  factory DatabaseService() => _instance;
  DatabaseService._();

  // Box names
  static const String usersBoxName = 'users';
  static const String productsBoxName = 'products';
  static const String ordersBoxName = 'orders';
  static const String cartBoxName = 'cart';
  static const String reviewsBoxName = 'reviews';
  static const String vouchersBoxName = 'vouchers';
  static const String userPrefsBoxName = 'userPrefs';
  static const String sessionBoxName = 'session';

  Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(ProductModelAdapter());
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(OrderStatusAdapter());
    Hive.registerAdapter(PaymentMethodAdapter());
    Hive.registerAdapter(OrderModelAdapter());
    Hive.registerAdapter(OrderItemModelAdapter());
    Hive.registerAdapter(CartItemModelAdapter());
    Hive.registerAdapter(ReviewModelAdapter());
    Hive.registerAdapter(VoucherModelAdapter());
    Hive.registerAdapter(ChatMessageModelAdapter());
    Hive.registerAdapter(UserPrefsModelAdapter());

    // Open Boxes
    await Hive.openBox<UserModel>(usersBoxName);
    await Hive.openBox<ProductModel>(productsBoxName);
    await Hive.openBox<OrderModel>(ordersBoxName);
    await Hive.openBox(cartBoxName);
    await Hive.openBox<ReviewModel>(reviewsBoxName);
    await Hive.openBox<VoucherModel>(vouchersBoxName);
    await Hive.openBox<UserPrefsModel>(userPrefsBoxName);
    await Hive.openBox(sessionBoxName);

    await SeedingService.seedAll();
  }
}
