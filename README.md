# 🍔 PKA Food v2.0 — Báo cáo Đồ án Ứng dụng Đặt Đồ Ăn Trực Tuyến
Một dự án ứng dụng di động đặt đồ ăn thông minh cao cấp được xây dựng bằng **Flutter & Dart**, áp dụng mô hình thiết kế **Clean & Layered Architecture** (Kiến trúc phân lớp), quản lý trạng thái tập trung với **Provider Pattern**. Ứng dụng kết hợp sức mạnh của **Firebase Firestore** (Cloud Backend) để đồng bộ dữ liệu thời gian thực và **Hive NoSQL Database** (Local-First) để lưu trữ cục bộ tốc độ siêu cao.

---

## 👥 Thành Viên Nhóm & Phân Công Nhiệm Vụ (Lớp N03 - 2025-2026)

| Thành viên | Mã Sinh Viên | Vai Trò Chính | Các module chính phụ trách |
| :--- | :---: | :--- | :--- |
| **Lưu Đức Hiệp** | **23010437** | Team Leader / Principal Developer | - Trưởng nhóm quản lý tiến độ, thiết lập kiến trúc **Clean Architecture**.<br>- Trực tiếp cấu hình và tích hợp **Firebase (Auth, Firestore)** để đồng bộ dữ liệu thời gian thực với **Hive NoSQL** cục bộ.<br>- Xây dựng các luồng nghiệp vụ cốt lõi: Giỏ hàng, Đặt hàng, Tracking bản đồ và Thanh toán QR.<br>- Thiết kế toàn bộ hệ thống UI/UX cao cấp, tích hợp Provider Pattern quản lý trạng thái toàn cục. |
| **Hoàng Văn Dũng** | **23010438** | Backend & Admin Developer | - Phát triển các tính năng dành riêng cho Quản trị viên (Admin Dashboard).<br>- Xây dựng luồng quản lý thêm/sửa/xóa sản phẩm và theo dõi duyệt đơn hàng.<br>- Hỗ trợ tích hợp đổ dữ liệu mẫu (Seed Data) lên Firestore. |
| **Nguyễn Kim Khương** | **23010428** | Frontend Developer | - Xây dựng các tab giao diện Trang chủ, Khám phá và Yêu thích.<br>- Hỗ trợ tối ưu hóa hiển thị thiết kế UI (Responsive) trên màn hình thiết bị khác nhau.<br>- Tham gia viết một số Widgets dùng chung (Common Widgets). |

---

## 📂 Sơ Đồ Cấu Trúc Thư Mục Hệ Thống (Detailed Directory Tree)

Dưới đây là sơ đồ chi tiết toàn bộ các file nguồn trong thư mục `lib/` của dự án **PKA Food v2.0**:

```text
lib/
├── core/                         # Các tài nguyên dùng chung của ứng dụng (Core)
│   ├── constants/                # Định nghĩa các hằng số dùng chung cho thiết kế
│   │   ├── app_colors.dart       # Bảng màu sắc chủ đạo hệ thống (Light/Dark palette)
│   │   ├── app_sizes.dart        # Kích thước chuẩn cho margins, paddings, border radiuses
│   │   └── app_strings.dart      # Các chuỗi văn bản tĩnh, thông báo mặc định của app
│   ├── theme/                    # Cấu hình giao diện tổng thể
│   │   └── app_theme.dart        # Cấu hình chi tiết ThemeData cho cả Sáng (Light) và Tối (Dark)
│   └── utils/                    # Các công cụ hỗ trợ tiện ích
│       ├── format_utils.dart     # Định dạng tiền tệ VND (1.000đ) và thời gian hiển thị
│       ├── hash_utils.dart       # Mã hóa bảo mật mật khẩu người dùng (Băm SHA-256)
│       └── validators.dart       # Xác thực định dạng Form (Email, Số điện thoại, Mật khẩu)
├── models/                       # Định nghĩa các thực thể dữ liệu (Data Entity Models)
│   ├── enums/                    # Các tập hợp hằng số cố định (Enumerations)
│   │   ├── admin_image_preset.dart # Các tùy chọn hình ảnh mặc định trong trang quản trị
│   │   ├── category.dart         # Phân loại danh mục món ăn (Đồ ăn, Đồ uống, Combo)
│   │   ├── order_status.dart     # Các trạng thái đơn (Chờ xác nhận, Chuẩn bị, Đang giao, Đã giao, Đã hủy)
│   │   └── payment_method.dart   # Phương thức thanh toán (Tiền mặt COD, Chuyển khoản QR, Ví điện tử)
│   ├── admin_product_model.dart  # Model sản phẩm dành riêng cho quản trị viên admin
│   ├── cart_item_model.dart      # Model đại diện cho một mặt hàng trong giỏ mua sắm
│   ├── chat_message_model.dart   # Model dòng tin nhắn trò chuyện giữa người dùng và shipper
│   ├── order_item_model.dart     # Model dòng mặt hàng bên trong đơn hàng đã tạo
│   ├── order_model.dart          # Model lưu trữ tổng quan thông tin của một hóa đơn
│   ├── product_model.dart        # Model thông tin chi tiết món ăn (tên, giá, ảnh, đánh giá...)
│   ├── review_model.dart         # Model lưu trữ phản hồi, chấm điểm của khách hàng
│   ├── user_model.dart           # Model tài khoản người dùng cuối (End-User Profile)
│   ├── user_prefs_model.dart     # Model lưu trữ tùy chọn cài đặt cá nhân (Dark mode, thông báo...)
│   └── voucher_model.dart        # Model thông tin phiếu giảm giá, mã khuyến mãi
├── providers/                    # Tầng quản lý trạng thái tập trung (State Management Layer)
│   ├── auth_provider.dart        # Quản lý trạng thái Đăng nhập/Đăng ký/Thay đổi mật khẩu tài khoản
│   ├── cart_provider.dart        # Quản lý logic thêm, bớt, áp mã voucher, tính tổng giỏ hàng tạm tính
│   ├── favorites_provider.dart   # Quản lý danh sách các món ăn được yêu thích của người dùng
│   ├── order_provider.dart       # Quản lý lịch sử đặt hàng, theo dõi tiến trình và hủy đơn hàng
│   ├── product_provider.dart     # Quản lý tìm kiếm, lọc danh mục món ăn hiển thị trên trang chủ
│   └── theme_provider.dart       # Quản lý chuyển đổi chế độ nền Sáng / Tối toàn ứng dụng
├── screens/                      # Phân hệ giao diện các màn hình (Presentation Layer)
│   ├── admin/                    # Phân hệ dành riêng cho quản lý của chủ quán (Admin portal)
│   │   ├── admin_dashboard_screen.dart # Bảng điều khiển quản lý món ăn, đơn hàng và xem doanh thu
│   │   └── admin_login_screen.dart    # Giao diện đăng nhập dành riêng cho tài khoản admin
│   ├── auth/                     # Phân hệ Xác thực tài khoản khách hàng
│   │   ├── forgot_password_screen.dart # Màn hình khôi phục mật khẩu thông qua Số điện thoại
│   │   ├── login_screen.dart     # Màn hình đăng nhập tài khoản khách hàng bằng SĐT & Mật khẩu
│   │   ├── register_screen.dart  # Màn hình đăng ký tài khoản mới với các trường thông tin đầy đủ
│   │   └── widgets/
│   │       └── auth_layout.dart  # Layout nền dùng chung cho các màn hình xác thực (Auth layout)
│   ├── chat/                     # Phân hệ trò chuyện, tương tác
│   │   ├── delivery_call_screen.dart   # Giao diện giả lập cuộc gọi điện thoại cho shipper
│   │   └── delivery_chat_screen.dart   # Giao diện chat thời gian thực gửi tin nhắn qua lại với shipper
│   ├── checkout/                 # Phân hệ chốt đơn và thanh toán
│   │   ├── checkout_screen.dart  # Trang thanh toán (nhập địa chỉ, chọn phương thức, áp voucher)
│   │   └── qr_payment_screen.dart# Màn hình tạo mã QR chuyển khoản giả lập để thanh toán hóa đơn
│   ├── home/                     # Phân hệ điều hướng chính của Khách hàng
│   │   ├── home_screen.dart      # Màn hình khung chứa BottomNavigationBar điều khiển 4 Tabs chính
│   │   ├── tabs/                 # 4 Tab cốt lõi trong ứng dụng
│   │   │   ├── cart_tab.dart     # Tab giỏ hàng (Xem danh sách, sửa số lượng, áp mã giảm giá)
│   │   │   ├── explore_tab.dart  # Tab khám phá (Xem banner, tìm kiếm, lọc danh mục, xem món ngon)
│   │   │   ├── favorites_tab.dart# Tab yêu thích (Hiển thị các món ăn đã được thả tim)
│   │   │   └── orders_tab.dart   # Tab lịch sử đơn hàng (Phân loại đơn đang giao, đã giao, đã hủy)
│   │   └── widgets/
│   │       └── discovery_product_card.dart # Thẻ hiển thị món ăn đẹp mắt ngoài trang chủ
│   ├── onboarding/               # Phân hệ chào mừng
│   │   └── onboarding_screen.dart # Giới thiệu ứng dụng khi người dùng mở app lần đầu tiên
│   ├── order/                    # Phân hệ hóa đơn đặt mua
│   │   ├── invoice_screen.dart   # Giao diện hóa đơn chi tiết sau khi đơn hàng được giao thành công
│   │   ├── order_history_screen.dart # Lịch sử đơn hàng cũ của tài khoản
│   │   └── widgets/
│   │       └── order_summary_card.dart # Thẻ tóm tắt thông tin nhanh của một đơn hàng
│   ├── product/                  # Phân hệ chi tiết món ăn
│   │   └── product_detail_screen.dart # Chi tiết món ăn (Xem mô tả, điểm đánh giá, bình luận và thêm vào giỏ)
│   ├── profile/                  # Phân hệ thông tin cá nhân
│   │   ├── change_password_screen.dart # Màn hình đổi mật khẩu tài khoản khách hàng
│   │   ├── edit_profile_screen.dart   # Màn hình chỉnh sửa thông tin cá nhân (Họ tên, Email, Ảnh đại diện)
│   │   ├── help_center_screen.dart    # Giao diện trung tâm trợ giúp giải quyết khiếu nại khách hàng
│   │   ├── notification_settings_screen.dart # Cài đặt bật tắt thông báo đẩy
│   │   ├── profile_screen.dart   # Màn hình hồ sơ chính, quản lý các liên kết cài đặt cá nhân
│   │   └── widgets/              # Các widget nhỏ dùng riêng trong trang Profile
│   ├── splash/                   # Phân hệ khởi động
│   │   └── splash_screen.dart    # Màn hình Splash tải dữ liệu, kiểm tra trạng thái đăng nhập
│   └── tracking/                 # Phân hệ theo dõi lộ trình đơn hàng
│       ├── tracking_order_screen.dart # Màn hình bản đồ giả lập và timeline trạng thái đơn hàng
│       └── widgets/              # Các widget phụ cho trang tracking
├── services/                     # Tầng giao tiếp cơ sở dữ liệu và hệ thống (Service Layer)
│   ├── admin_auth_service.dart   # Xử lý đăng nhập, quản lý quyền hạn của Admin
│   ├── admin_order_read_service.dart # Truy xuất thông tin đơn đặt hàng cho trang quản lý Admin
│   ├── admin_product_service.dart # Thêm, sửa, xóa món ăn dành riêng cho trang quản trị Admin
│   ├── auth_service.dart         # Xử lý đăng nhập, đăng ký, băm mật khẩu khách hàng
│   ├── cart_service.dart         # Lưu trữ, đồng bộ giỏ hàng cá nhân trực tiếp vào Hive
│   ├── database_service.dart     # Khởi tạo các kết nối Database (đăng ký Hive Adapters, mở Box NoSQL)
│   ├── notification_service.dart # Quản lý, giả lập đẩy thông báo cục bộ của hệ thống
│   ├── order_service.dart        # Xử lý lưu đơn, đổi trạng thái, reorder trong Hive database
│   ├── prefs_service.dart        # Lưu trữ các cài đặt cá nhân (Dark mode, danh sách món yêu thích)
│   ├── product_service.dart      # Truy xuất danh sách món ăn từ cơ sở dữ liệu Hive
│   ├── seeding_service.dart      # Tự động nạp dữ liệu mẫu chất lượng cao từ file JSON trong lần chạy đầu
│   └── voucher_service.dart      # Quản lý kiểm tra tính hợp lệ và áp dụng mã giảm giá voucher
├── widgets/                      # Các thành phần giao diện dùng chung (Common UI Components)
│   ├── app_image.dart            # Trình hiển thị hình ảnh thông minh (có fallback lỗi và shimmer tải trang)
│   ├── app_text_field.dart       # Ô nhập dữ liệu chuẩn hóa Material 3 hỗ trợ ẩn/hiện mật khẩu
│   ├── app_widgets.dart          # Tập hợp các widget bổ trợ kích thước nhỏ
│   ├── empty_state.dart          # Giao diện thông báo khi danh sách dữ liệu trống (giỏ hàng trống, đơn hàng trống...)
│   ├── loading_state.dart        # Giao diện chỉ báo tải dữ liệu mượt mà
│   ├── price_text.dart           # Widget hiển thị và định dạng tiền tệ chuyên nghiệp (Ví dụ: 120.000đ)
│   ├── primary_button.dart       # Nút bấm chính Material 3 bo góc hỗ trợ loading indicator khi xử lý bất đồng bộ
│   └── section_header.dart       # Widget tiêu đề phân đoạn giao diện đẹp mắt kèm nút "Xem tất cả"
├── app.dart                      # Định nghĩa các Providers toàn cục và bảng định tuyến (Routes)
└── main.dart                     # Tệp chạy chính khởi động dịch vụ Hive DB & khởi chạy PkaFoodApp
```

---

## 🛠️ 3. Phân Tích Chức Năng Chi Tiết Từng File Code

### 3.1 Nhóm File Khởi Chạy (Bootstrapping Files)

#### 📝 [lib/main.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/main.dart)
* **Chức năng:** Điểm bắt đầu (Entry Point) của toàn bộ ứng dụng.
* **Nội dung thực hiện:** 
  * Gọi `WidgetsFlutterBinding.ensureInitialized()` để thiết lập các kênh hệ thống Flutter.
  * Khởi tạo `Firebase.initializeApp()` để kết nối hệ thống Backend đám mây (Firestore, Auth).
  * Khởi tạo cơ sở dữ liệu cục bộ `DatabaseService().init()` chuẩn bị và mở các Box Hive NoSQL phục vụ lưu trữ Local-First.
  * Khởi tạo dịch vụ thông báo cục bộ `NotificationService().init()`.
  * Chạy hàm `runApp(const PkaFoodApp())` để đưa Widget Tree lên màn hình.

#### 📝 [lib/app.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/app.dart)
* **Chức năng:** Trái tim quản lý cấu trúc ứng dụng.
* **Nội dung thực hiện:**
  * Khai báo `MultiProvider` để cung cấp toàn bộ các Repository Services và ChangeNotifiers xuống toàn bộ Widget Tree dưới dạng Singleton/Read-only hoặc State listeners.
  * Định nghĩa hệ thống Routing rõ ràng (`routes`) giúp chuyển hướng linh hoạt giữa các màn hình như `/splash`, `/login`, `/admin-login`, `/admin`, `/register`, `/home`, `/onboarding`, `/forgot-password`, `/checkout`, `/profile`.
  * Lắng nghe `ThemeProvider` để áp dụng giao diện sáng/tối tự động đồng nhất thông qua `MaterialApp`.

---

### 3.2 Nhóm Tiện Ích Dùng Chung (Core Constants & Utilities)

* 📝 [lib/core/constants/app_colors.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/core/constants/app_colors.dart): Lưu trữ hệ màu chuẩn Material 3 cao cấp. Màu chủ đạo là **Màu cam sâu (Deep Orange)** hợp với chủ đề F&B, kết hợp màu nền xám nhạt, viền sáng và màu tối cho chế độ Dark Mode.
* 📝 [lib/core/constants/app_sizes.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/core/constants/app_sizes.dart): Hằng số căn chỉnh kích thước (margins, paddings) để tránh code cứng số ngẫu nhiên, giúp UI đồng bộ tuyệt đối trên mọi độ phân giải.
* 📝 [lib/core/constants/app_strings.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/core/constants/app_strings.dart): Quản lý tập trung các chuỗi văn bản như tiêu đề app, lời chào trang chủ, nhãn cảnh báo hoặc các thông điệp phản hồi lỗi.
* 📝 [lib/core/theme/app_theme.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/core/theme/app_theme.dart): Thiết lập các định dạng font chữ cao cấp từ `google_fonts` (Outfit / Inter) cho cả 2 tệp LightTheme và DarkTheme. Cấu hình chi tiết kiểu dáng cho appBar, nút bấm và thẻ card.
* 📝 [lib/core/utils/format_utils.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/core/utils/format_utils.dart): Tiện ích định dạng tiền tệ chuyên nghiệp (Ví dụ: `45.000đ`) sử dụng thư viện `intl` và định dạng ngày tháng lập đơn thân thiện.
* 📝 [lib/core/utils/hash_utils.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/core/utils/hash_utils.dart): Mã hóa bảo mật mật khẩu người dùng thông qua thuật toán mã hóa **SHA-256** (băm mật khẩu kèm với một lượng muối bổ sung), cam kết không lưu văn bản gốc vào database.
* 📝 [lib/core/utils/validators.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/core/utils/validators.dart): Chứa các biểu thức chính quy (RegExp) để kiểm tra tính hợp lệ của Email, Số điện thoại (phải đủ 10 chữ số) và độ phức tạp của Mật khẩu khi đăng ký.

---

### 3.3 Tầng Mô Hình Dữ Liệu & Enums (Models & Hive Adapters)

Tất cả các model trong dự án được tích hợp các Annotation `@HiveType` và `@HiveField` để tự động tạo ra các bộ điều hợp dữ liệu Adapter (các file `.g.dart`) hỗ trợ chuyển đổi nhị phân lưu trữ cực nhanh.

* 📝 [lib/models/enums/category.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/models/enums/category.dart): Phân loại danh mục món ăn (`food`, `drink`, `combo`).
* 📝 [lib/models/enums/order_status.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/models/enums/order_status.dart): Trạng thái lộ trình đơn hàng (`pending`, `preparing`, `delivering`, `completed`, `cancelled`).
* 📝 [lib/models/enums/payment_method.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/models/enums/payment_method.dart): Các phương thức thanh toán trong app (`cod`, `qr`, `eWallet`).
* 📝 [lib/models/product_model.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/models/product_model.dart): Đại diện thông tin món ăn: `id`, `name`, `description`, `price`, `imageUrl`, `category`, `rating`, `reviewCount`, `isAvailable`.
* 📝 [lib/models/cart_item_model.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/models/cart_item_model.dart): Thông tin mặt hàng trong giỏ bao gồm liên kết đến `ProductModel` và số lượng `quantity`.
* 📝 [lib/models/order_model.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/models/order_model.dart): Lưu giữ thông tin hóa đơn tổng gồm danh sách món đã đặt (`OrderItemModel`), tổng tiền, tiền giảm giá, phí vận chuyển, địa chỉ nhận hàng, phương thức thanh toán, ghi chú và mốc thời gian.
* 📝 [lib/models/user_model.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/models/user_model.dart): Lưu trữ thông tin tài khoản người dùng cuối: `id`, `name`, `phone`, `email`, `dob`, `passwordHash`, `avatarPath`.
* 📝 [lib/models/voucher_model.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/models/voucher_model.dart): Quản lý thông tin chiết khấu của phiếu mua hàng (`code`, `discountAmount`, `discountPercent`, `minOrderAmount`, `expiresAt`).
* 📝 [lib/models/chat_message_model.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/models/chat_message_model.dart): Lưu trữ dòng tin nhắn trong cuộc trò chuyện: `id`, `senderId`, `text`, `timestamp`, `isRead`.

---

### 3.4 Tầng Dịch Vụ - Tương Tác Cơ Sở Dữ Liệu (Services Layer)

Đây là lớp nghiệp vụ thuần của ứng dụng, trực tiếp giao tiếp với **Firebase Firestore** (Cloud Database), **NoSQL Box** (Local Database) hoặc hệ thống phần cứng.

* 📝 [lib/services/database_service.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/services/database_service.dart): Khởi tạo kết nối cơ sở dữ liệu cục bộ, đăng ký toàn bộ Adapters nhị phân và mở sẵn các Box Hive.
* 📝 [lib/services/seeding_service.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/services/seeding_service.dart): Giải mã dữ liệu mẫu `assets/seeddata.json`. Tự động đồng bộ (seed) dữ liệu ban đầu lên **Firebase Firestore** đồng thời lưu cache xuống **Hive** trong lần khởi chạy đầu tiên.
* 📝 [lib/services/auth_service.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/services/auth_service.dart): Dịch vụ xác thực (Authentication) mạnh mẽ tương tác trực tiếp với **Firebase Firestore**. Xử lý luồng đăng nhập, đăng ký, mã hóa mật khẩu và lưu cache phiên đăng nhập cục bộ.
* 📝 [lib/services/cart_service.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/services/cart_service.dart): Đồng bộ hóa tức thì trạng thái giỏ hàng vào Hive cục bộ, mang lại tốc độ phản hồi cực nhanh.
* 📝 [lib/services/product_service.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/services/product_service.dart): Xử lý truy xuất danh sách món ăn thời gian thực từ **Firestore Cloud**, kết hợp khả năng đọc dự phòng (fallback) qua Hive cục bộ. Hỗ trợ truy vấn bộ lọc tìm kiếm nâng cao.
* 📝 [lib/services/order_service.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/services/order_service.dart): Đồng bộ đơn hàng đa nền tảng (**Firestore sync với Hive fallback**). Xử lý tạo đơn, lưu vết lịch sử giao dịch và cung cấp tính năng "Đặt lại đơn" (Reorder).
* 📝 [lib/services/voucher_service.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/services/voucher_service.dart): Kiểm tra tính hợp lệ của mã code (ngày hết hạn, giá trị đơn tối thiểu) và tính toán số tiền thực tế được khấu trừ khi chốt đơn.
* 📝 [lib/services/notification_service.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/services/notification_service.dart): Giả lập cơ chế đẩy thông báo đẩy cục bộ (Local Notifications) thông báo cho người dùng mỗi khi trạng thái đơn hàng thay đổi trên bản đồ giao nhận.
* 📝 [lib/services/admin_product_service.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/services/admin_product_service.dart): Hỗ trợ các quyền quản lý đầy đủ (CRUD) cho Admin: Thêm món mới, Sửa thông tin món, Xóa món hoặc Đánh dấu ngưng phục vụ món ăn nào đó.

---

### 3.5 Tầng Quản Lý Trạng Thái Tập Trung (Providers Layer)

* 📝 [lib/providers/auth_provider.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/providers/auth_provider.dart): Quản lý luồng đăng nhập tài khoản. Cung cấp biến trạng thái `currentUser`, `isLoading`, `error` để UI dựng vòng tròn xoay hoặc hiện thông báo lỗi Dialog trực quan khi bấm Đăng nhập/Đăng ký.
* 📝 [lib/providers/cart_provider.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/providers/cart_provider.dart): Logic giỏ hàng siêu phức tạp: thêm món (cộng dồn nếu trùng), bớt số lượng, xóa dòng, kiểm tra áp dụng mã voucher và tính toán toàn bộ chi phí (Tạm tính ➔ Áp mã giảm ➔ Phí giao hàng ➔ Tổng thanh toán).
* 📝 [lib/providers/favorites_provider.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/providers/favorites_provider.dart): Quản lý danh sách ID các món ăn yêu thích, đồng bộ trực tiếp vào Shared Preferences/Hive giúp người dùng không bị mất danh sách khi đóng ứng dụng.
* 📝 [lib/providers/product_provider.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/providers/product_provider.dart): Lắng nghe trạng thái thay đổi bộ lọc tìm kiếm trang chủ, tự động cập nhật danh sách món ăn khớp từ khóa tức thì trên giao diện mà không gây giật lag.
* 📝 [lib/providers/order_provider.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/providers/order_provider.dart): Quản lý quá trình chuyển trạng thái đơn đặt hàng, quản lý danh sách đơn hàng "Đang hoạt động" và "Lịch sử mua".
* 📝 [lib/providers/theme_provider.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/providers/theme_provider.dart): Lưu trữ và điều phối trạng thái chủ đề hiển thị (Dark Mode hay Light Mode), ghi nhớ cài đặt của người dùng.

---

### 3.6 Phân Hệ Giao Diện Các Màn Hình (Screens Layer)

#### 3.6.1 Module Quản Trị Viên (Admin)
* 📝 [lib/screens/admin/admin_dashboard_screen.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/screens/admin/admin_dashboard_screen.dart): Bảng điều khiển admin cực kỳ rộng lớn và hoành tráng:
  * Thống kê tổng quan dạng thẻ: Xem doanh thu ngày/tháng, tổng số đơn hàng đã giao thành công và số món ăn đang hoạt động.
  * Quản lý món ăn: Hiển thị danh sách, có nút thêm nhanh, bật/tắt phục vụ an toàn và cập nhật giá bán.
  * Quản lý đơn hàng: Duyệt danh sách đơn đặt hàng từ khách hàng, có nút cập nhật nhanh trạng thái đơn hàng (từ Chuẩn bị sang Đang giao...).
* 📝 [lib/screens/admin/admin_login_screen.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/screens/admin/admin_login_screen.dart): Giao diện tối giản, bảo mật dành riêng cho tài khoản quản lý hệ thống.

#### 3.6.2 Tab Điều Hướng Trang Chủ (Home & Tabs)
* 📝 [lib/screens/home/home_screen.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/screens/home/home_screen.dart): Sử dụng `BottomNavigationBar` với 4 lựa chọn có hiệu ứng chuyển tab mượt mà.
* 📝 [lib/screens/home/tabs/explore_tab.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/screens/home/tabs/explore_tab.dart): Giao diện tìm kiếm, banner khuyến mãi trượt ngang, thanh phân loại danh mục (Đồ ăn, Đồ uống...) và danh sách lưới hiển thị toàn bộ món ăn cực kỳ lôi cuốn.
* 📝 [lib/screens/home/tabs/favorites_tab.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/screens/home/tabs/favorites_tab.dart): Hiển thị danh sách các món ăn đã được người dùng nhấn yêu thích, cho phép xóa nhanh hoặc nhấn đặt món trực tiếp từ đây.
* 📝 [lib/screens/home/tabs/cart_tab.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/screens/home/tabs/cart_tab.dart): Hiển thị danh sách các món trong giỏ hàng. Hỗ trợ nhập mã Voucher và hiển thị hóa đơn tạm tính chi tiết theo thời gian thực cùng nút "Tiến hành thanh toán".
* 📝 [lib/screens/home/tabs/orders_tab.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/screens/home/tabs/orders_tab.dart): Theo dõi lịch sử mua hàng, chia làm 2 phần: "Đơn hàng đang xử lý" và "Lịch sử mua sắm".

#### 3.6.3 Thanh Toán & Theo Dõi Giao Nhận (Checkout & Tracking)
* 📝 [lib/screens/checkout/checkout_screen.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/screens/checkout/checkout_screen.dart): Nhập địa chỉ nhận, ghi chú giao hàng, tùy chọn phương thức thanh toán (COD, QR, Ví điện tử) và xác nhận áp dụng giảm giá trước khi nhấn **"Đặt hàng ngay"**.
* 📝 [lib/screens/checkout/qr_payment_screen.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/screens/checkout/qr_payment_screen.dart): Hiển thị mã QR ngân hàng giả lập đẹp mắt kèm hướng dẫn chuyển khoản đúng số tiền đơn hàng để hoàn tất thanh toán trực tuyến.
* 📝 [lib/screens/tracking/tracking_order_screen.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/screens/tracking/tracking_order_screen.dart): Giao diện theo dõi đơn hàng thời gian thực: hiển thị bản đồ giả lập vị trí shipper di chuyển cùng tiến trình trạng thái đơn hàng (Đang chuẩn bị ➔ Shipper đang giao ➔ Hoàn tất đơn).

#### 3.6.4 Chat & Liên Lạc Thời Gian Thực (Communication)
* 📝 [lib/screens/chat/delivery_chat_screen.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/screens/chat/delivery_chat_screen.dart): Giao diện gửi nhận tin nhắn văn bản với tài xế giao hàng. Tích hợp tin nhắn mẫu gửi nhanh (Ví dụ: *"Tôi đang xuống nhận món"*, *"Hãy để đồ ăn ở quầy lễ tân"*...).
* 📝 [lib/screens/chat/delivery_call_screen.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/screens/chat/delivery_call_screen.dart): Giả lập giao diện cuộc gọi thoại điện thoại bắt mắt cho tài xế giao hàng với hiệu ứng đếm giây chạy động và các nút tắt mic, loa ngoài chuyên nghiệp.

#### 3.6.5 Hồ Sơ Cá Nhân & Quản Trị Cài Đặt (Profile)
* 📝 [lib/screens/profile/profile_screen.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/screens/profile/profile_screen.dart): Menu hồ sơ chính tích hợp xem thông tin cá nhân và quản lý cài đặt.
* 📝 [lib/screens/profile/edit_profile_screen.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/screens/profile/edit_profile_screen.dart): Cập nhật thông tin tài khoản (Tên, Email) và tùy chọn thay đổi ảnh đại diện.
* 📝 [lib/screens/profile/change_password_screen.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/screens/profile/change_password_screen.dart): Đổi mật khẩu tài khoản khách hàng, kiểm tra tính hợp lý mật khẩu cũ.
* 📝 [lib/screens/profile/help_center_screen.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/screens/profile/help_center_screen.dart): Cung cấp bộ câu hỏi thường gặp FAQ và biểu mẫu gửi thắc mắc khiếu nại của khách hàng.
* 📝 [lib/screens/profile/notification_settings_screen.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/screens/profile/notification_settings_screen.dart): Bật/Tắt các loại thông báo đẩy trong hệ thống (thông báo đơn hàng, khuyến mãi mới).

---

### 3.7 Thành Phần Giao Diện Tái Sử Dụng (Common Widgets)

* 📝 [lib/widgets/app_image.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/widgets/app_image.dart): Trình load ảnh tối ưu, tự động hiển thị Shimmer khi đang tải, hỗ trợ load từ asset hoặc internet và tự động hiển thị ảnh lỗi mặc định đẹp mắt nếu bị rớt kết nối.
* 📝 [lib/widgets/app_text_field.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/widgets/app_text_field.dart): Hộp nhập liệu chuẩn Material 3: thiết lập đầy đủ icon đầu/cuối, nhãn văn bản nổi bật và tự động tích hợp nút bật/tắt hiển thị ẩn mật khẩu dạng mắt đóng/mở.
* 📝 [lib/widgets/primary_button.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/widgets/primary_button.dart): Nút bấm chính được bo góc cong thanh lịch. Hỗ trợ hiển thị vòng quay loading indicator nếu hệ thống đang xử lý bất đồng bộ, tự động khóa nút bấm để ngăn người dùng click liên tiếp gây trùng lặp request.
* 📝 [lib/widgets/price_text.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/widgets/price_text.dart): Hiển thị đơn giá món ăn đi kèm ký tự `đ` hoặc chữ `VND` được thu nhỏ tinh tế phía trên chân số.
* 📝 [lib/widgets/empty_state.dart](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/lib/widgets/empty_state.dart): Minh họa hình ảnh vector vui nhộn kèm thông điệp hướng dẫn rõ ràng khi giỏ hàng trống hoặc chưa có đơn hàng nào trong lịch sử mua sắm.

---

## 🎨 4. Ngôn Ngữ Thiết Kế & Chủ Đề (Design System & Theme Mode)

Ứng dụng **PKA Food v2.0** tuân thủ nghiêm ngặt ngôn ngữ thiết kế **Material Design 3** hiện đại:
- **Responsive Layout:** Hỗ trợ thích ứng mượt mà trên nhiều kích thước màn hình nhờ việc bọc trong `ConstrainedBox` hoặc sử dụng `LayoutBuilder` cho phép co giãn cột tự động.
- **Light & Dark Theme:**
  - **Light Mode:** Sử dụng màu nền chính là trắng tinh khôi (#FFFFFF) và xám nhạt (#F8F9FA) làm nổi bật các món ăn đầy màu sắc và thẻ Card có đổ bóng tinh tế.
  - **Dark Mode:** Màu nền chuyển hẳn sang xám đen sâu ấm áp (#121212), giảm mỏi mắt khi sử dụng vào ban đêm mà vẫn giữ nguyên màu cam sâu điểm nhấn nổi bật cho các nút bấm cốt lõi.

---

## 🚀 5. Hướng Dẫn Cài Đặt & Khởi Chạy Dự Án

### Yêu cầu môi trường chuẩn bị trước
- **Flutter SDK:** Phiên bản `>= 3.11.4`
- **Dart SDK:** Phiên bản `>= 3.11.4`
- Thiết bị giả lập (Emulator Android/iOS) hoặc Trình duyệt Chrome đã sẵn sàng kết nối.

### Các bước thực thi chi tiết

1. **Tải mã nguồn dự án từ Github:**
   ```bash
   git clone https://github.com/hdungx0795/AnNgon_Dung_Hiep_Khuong_N03_1_2026.git
   cd AnNgon_Dung_Hiep_Khuong_N03_1_2026
   ```

2. **Cài đặt toàn bộ gói thư viện phụ thuộc (Dependencies):**
   ```bash
   flutter pub get
   ```

3. **Tạo lập các Adapter nhị phân cho Hive database (chỉ chạy khi thay đổi file model):**
   Nếu bạn có thay đổi cấu trúc ở tầng Model, hãy chạy lệnh sinh mã tự động dưới đây để cập nhật tệp `.g.dart`:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Khởi chạy ứng dụng:**
   ```bash
   flutter run
   ```

*(Lưu ý: Ứng dụng đã tích hợp sẵn **Firebase** và hệ thống **Seeding Service**. Trong lần chạy đầu tiên, cơ sở dữ liệu Firebase Firestore và Hive sẽ tự động đồng bộ toàn bộ danh mục sản phẩm, tài khoản và mã giảm giá).*

---

## 🔑 6. Dữ Liệu Demo Sử Dụng Trong Hệ Thống (Seed Data)

Dữ liệu ban đầu chất lượng cao được thiết lập sẵn trong file `assets/seeddata.json` bao gồm:
- **Sản phẩm:** Tổng cộng 30 món ngon đa dạng chia làm 3 danh mục (Đồ ăn, Đồ uống, Combo).
- **Mã giảm giá Voucher có hiệu lực:**
  - `PKANEW`: Giảm trực tiếp **20.000đ** cho đơn đặt hàng đầu tiên.
  - `FREESHIP`: Miễn phí vận chuyển giao hàng tận nơi.
  - `COMBO20`: Giảm trực tiếp **20%** tổng hóa đơn khi mua sản phẩm danh mục Combo.

**Tài khoản khách hàng Test mặc định:**
- **Số điện thoại:** `0987654321`
- **Mật khẩu:** `123456`

## 📚 7. Tài liệu Đồ án (Documentation)

Chi tiết các tài liệu phân tích, thiết kế, kịch bản demo và kết quả kiểm thử (Tiêu chí 1-10) được lưu trong thư mục `docs/`:
- [User Stories](docs/user_stories.md)
- [Phân tích yêu cầu](docs/requirements_analysis.md)
- [Thiết kế hệ thống](docs/system_design.md)
- [Thiết kế giao diện](docs/ui_design.md)
- [Báo cáo kiểm thử](docs/testing_tc8.md)
- [Kịch bản Demo](docs/demo_script.md)
- [Checklist Nộp bài](docs/submission_checklist.md)

---

## 📌 PHẦN PHỤ LỤC: NHẬT KÝ CÁC BUỔI THỰC HÀNH & GIỮA KỲ

Dưới đây là phần lưu trữ thông tin thực hành và bài kiểm tra giữa kỳ của các thành viên trong nhóm N03:

### 📌 Nội dung buổi thực hành 01

#### ✅ Nhiệm vụ đã thực hiện
* Tạo repository nhóm trên GitHub.
* Thêm thành viên vào repository.
* Tạo project Flutter framework.
* Chỉnh sửa giao diện:
  * Đổi tên ứng dụng: **Ứng dụng Đồ Ăn**
  * Hiển thị thông tin thành viên nhóm
* Đưa code lên GitHub bằng Git.

---

### 📌 Nội dung buổi thực hành 02

#### ✅ Nhiệm vụ đã thực hiện (Theo yêu cầu bài tập)
* **1. Xây dựng đối tượng & Khai báo biến (OOP):**
  * Xây dựng Class `NguoiDung` với các biến mô tả cụ thể: `idUser` (int), `hoTen` (String), `soDienThoai` (String), `diaChi` (String), `email` (String).
* **2. Sử dụng Collections (List/Array):**
  * Áp dụng Collection dạng mảng `List<NguoiDung> danhSachNhom` để lưu trữ tập trung dữ liệu của 3 thành viên trong nhóm.
* **3. Hiển thị dữ liệu lên Widget:**
  * Render dữ liệu động từ List ra giao diện bằng cách sử dụng vòng lặp `.map()` kết hợp toán tử Spread (`...`).
  * Trình bày thông tin từng đối tượng người dùng thành các khối `Column` chứa các `Text` thông tin (Họ tên, SĐT, Địa chỉ) và ngăn cách bằng `Divider`.

---

### 📌 Nội dung buổi thực hành 03

#### ✅ Nhiệm vụ đã thực hiện (OOP Nâng cao & Generics)
* **1. Nghiên cứu lý thuyết (Từ khóa `static`):**
  * Hoàn thành báo cáo lý thuyết về từ khóa `static` trong Dart (Định nghĩa, cách sử dụng, đánh giá ưu/nhược điểm trong quản lý bộ nhớ và truy cập dữ liệu).
* **2. Áp dụng Generics Class:**
  * Xây dựng lớp tổng quát `CollectionWrapper<T>` (hoặc `DataContainer<T>`) có biến `obj` để quản lý kiểu dữ liệu linh hoạt. 
  * Khởi tạo và in thành công danh sách mock data sinh viên bằng Generics.
* **3. Thiết kế đối tượng nghiệp vụ (`MonAn.dart`):**
  * Tạo file `lib/models/mon_an.dart` bám sát nghiệp vụ của ứng dụng đặt đồ ăn.
  * Khai báo các thuộc tính đặc trưng: `idMonAn`, `tenMon`, `giaTien`, `moTa`, `hinhAnh`.
  * Xây dựng các phương thức hoạt động cơ bản cho đối tượng (VD: `hienThiThongTin()`, `tinhGiaKhuyenMai()`).
* **4. Triển khai CRUD cho đối tượng (`ListMonAn.dart`):**
  * Tạo file `lib/models/list_mon_an.dart` quản lý danh sách `List<MonAn>`.
  * Viết các hàm thao tác với dữ liệu (CRUD):
    * **Create:** Thêm một đối tượng món ăn mới vào danh sách.
    * **Read:** Trích xuất và đọc toàn bộ danh sách các món ăn hiện có.
    * **Edit (Update):** Tìm kiếm món ăn theo `idMonAn` cụ thể và cập nhật thông tin (đổi tên, sửa giá,...).
* **5. Quản lý mã nguồn:** Cập nhật tài liệu `README.md`, tiến hành commit code và push lên GitHub.

---

### 📌 Bài kiểm tra giữa kỳ - Phần việc cá nhân

#### ✅ Công việc của Lưu Đức Hiệp: `AboutScreen`
* Thành viên thực hiện: **Lưu Đức Hiệp - 23010437**
* File thực hiện: `lib/midterm/about_screen.dart`
* Xây dựng giao diện màn hình About theo bố cục bài yêu cầu.
* Chỉnh màu giao diện theo mẫu tham khảo với tông trắng, xám và đen.
* Thiết kế các phần chính gồm: Thanh điều hướng phía trên, Tiêu đề và mô tả giới thiệu ứng dụng, Form liên hệ / phản hồi, Footer gồm icon và các cột thông tin.
* Bổ sung hiệu ứng nhấn cho: Logo, các mục menu trên thanh điều hướng, các nút đăng nhập/đăng ký, gửi phản hồi và các icon.

#### ✅ Công việc của Hoàng Văn Dũng: `HomeScreen` & Khung Base Layout
* Thành viên thực hiện: **Hoàng Văn Dũng - 23010438**
* File thực hiện: `lib/midterm/home_screen.dart` và `lib/midterm/base_layout.dart`
* Xây dựng khung giao diện điều hướng chính (Base Layout) và giao diện màn hình Trang chủ (Home).
* Áp dụng kỹ thuật thiết kế Responsive bằng `ConstrainedBox`, giúp giao diện hiển thị gọn gàng trên cả Mobile, Tablet và Web.
* Thiết kế các phần chính trên Trang Chủ gồm: Header chào mừng, Banner quảng cáo, Khám phá thực đơn/thoin tin, và danh sách món ngon nổi bật cuộn ngang.
* Tích hợp thanh điều hướng dưới (Bottom Navigation Bar) để chuyển đổi giữa các màn hình.

#### ✅ Công việc của Nguyễn Kim Khương: `ContentScreen` (Trang Thực đơn / Khám phá)
* Thành viên thực hiện: **Nguyễn Kim Khương - 23010428**
* File thực hiện: `lib/midterm/content_screen.dart`
* Xây dựng hoàn thiện giao diện trang Content theo bố cục Figma yêu cầu.
* Thiết kế UI bám sát phong cách tối giản (Monochrome) với các widget: Hero Section, Two Large Cards Section, Horizontal List Section, Grid Section và Footer Section.
* Áp dụng `MediaQuery` và `SingleChildScrollView` để giao diện có khả năng co giãn linh hoạt và cuộn mượt mà.

---

### 📌 Nội dung bài thực hành 04 (OOP Nâng cao - Tổng quát hóa & Chuyên biệt hóa)

#### 1. Kiến trúc hệ thống & Thiết kế Phân tích:
* **Tổng quát hóa (Generalization):**
  * Định nghĩa lớp trừu tượng cơ sở `BaseModel<ID>` đại diện cho mọi thực thể có định danh.
  * Xây dựng giao diện Generic `Repository<T, ID>` quy chuẩn các thao tác CRUD cơ bản (`getAll`, `getById`, `add`, `update`, `delete`).
  * Triển khai lớp cụ thể Generic `InMemoryRepository<T, ID>` để tái sử dụng toàn bộ logic lưu trữ dữ liệu tĩnh, tuân thủ nguyên lý **DRY (Don't Repeat Yourself)**.
* **Chuyên biệt hóa (Specialization):**
  * Đối với các thực thể phụ thuộc hoặc đối tượng giá trị không có vòng đời độc lập (`ChiTietDonHang` và `CartItem`), nhóm đã **chuyên biệt hóa** chúng mà không kế thừa `BaseModel`.
  * Các Repository chuyên biệt kế thừa từ `InMemoryRepository` để mở rộng các phương thức truy vấn nghiệp vụ đặc thù (ví dụ: tìm kiếm món ăn, lọc đơn hàng của người dùng, xác thực đăng nhập, tính đánh giá sao trung bình).
  * Áp dụng **Facade Pattern** cho `AppRepository` để bọc các Repository con, bảo toàn tính tương thích ngược cho giao diện UI cũ.

#### 2. Chi tiết phần việc & Trích lược Code của từng Sinh viên:

##### 🛠️ Hoàng Văn Dũng - 23010438: Thiết kế Core Infrastructure (Generic & Abstract Core)
* **Nhiệm vụ:**
  * Thiết kế lớp trừu tượng cơ sở `BaseModel` và interface `Repository`.
  * Triển khai bộ khung Generic CRUD `InMemoryRepository` để quản lý các thao tác dữ liệu dùng chung.
* **Trích lược code chính:**
  * Lớp Generic trừu tượng cơ sở `BaseModel<ID>`:
    ```dart
    abstract class BaseModel<ID> {
      ID get id;
      Map<String, dynamic> toJson();
    }
    ```
  * Lớp triển khai Generic CRUD `InMemoryRepository<T extends BaseModel<ID>, ID>`:
    ```dart
    class InMemoryRepository<T extends BaseModel<ID>, ID> implements Repository<T, ID> {
      final List<T> _items;
      InMemoryRepository([List<T>? initialItems]) : _items = List<T>.from(initialItems ?? []);
      
      @override
      List<T> getAll() => List<T>.unmodifiable(_items);
      
      @override
      T? getById(ID id) => _items.firstWhere((item) => item.id == id);
      
      @override
      void add(T item) => _items.add(item);
      
      @override
      void update(ID id, T item) {
        final index = _items.indexWhere((x) => x.id == id);
        if (index != -1) _items[index] = item;
      }
      
      @override
      void delete(ID id) => _items.removeWhere((item) => item.id == id);
    }
    ```

##### 🍔 Lưu Đức Hiệp - 23010437: Tổng quát & Chuyên biệt hóa nghiệp vụ Món ăn & Đánh giá
* **Nhiệm vụ:**
  * Kế thừa `BaseModel<int>` cho thực thể `MonAn` và `DanhGia`.
  * Chuyên biệt hóa thực thể phụ thuộc `ChiTietDonHang` (không có id độc lập).
  * Triển khai `MonAnRepository` và `DanhGiaRepository` chứa các truy vấn đặc thù của món ăn (tìm kiếm, lọc danh mục, món nổi bật, lọc giá) và đánh giá (tính trung bình sao).
* **Trích lược code chính:**
  * Lớp `MonAn` tổng quát hóa kế thừa `BaseModel<int>` và có thuộc tính chuyên biệt hóa:
    ```dart
    class MonAn implements BaseModel<int> {
      final int id;
      final String name;
      // ... các thuộc tính khác

      // Đánh giá xem món ăn có thuộc nhóm nổi bật không (Chuyên biệt hóa)
      bool get isTopRated => rating >= 4.5;
    }
    ```
  * Chuyên biệt hóa trong `MonAnRepository` với tìm kiếm, lọc danh mục, lọc nổi bật & lọc giá:
    ```dart
    class MonAnRepository extends InMemoryRepository<MonAn, int> {
      MonAnRepository(super.initialItems);
      
      List<MonAn> getByCategory(String category) {
        return getAll().where((m) => m.category.toLowerCase() == category.toLowerCase()).toList();
      }
      
      List<MonAn> search(String query) {
        final q = query.toLowerCase();
        return getAll().where((m) => m.name.toLowerCase().contains(q) || m.description.toLowerCase().contains(q)).toList();
      }

      // Lấy danh sách món ăn nổi bật (Chuyên biệt hóa)
      List<MonAn> getTopRated(int count) {
        final list = getAll().toList();
        list.sort((a, b) => b.rating.compareTo(a.rating));
        return list.take(count).toList();
      }

      // Lọc món ăn theo khoảng giá (Chuyên biệt hóa)
      List<MonAn> getMonAnTheoGia(double minPrice, double maxPrice) {
        return getAll().where((monAn) => monAn.price >= minPrice && monAn.price <= maxPrice).toList();
      }
    }
    ```

##### 👤 Nguyễn Kim Khương - 23010428: Tổng quát & Chuyên biệt hóa nghiệp vụ Người dùng & Đơn hàng
* **Nhiệm vụ:**
  * Kế thừa `BaseModel<String>` cho thực thể `NguoiDung` và `DonHang`.
  * Chuyên biệt hóa thực thể cục bộ `CartItem` cho giỏ hàng.
  * Triển khai `NguoiDungRepository` (hàm login/authenticate) và `DonHangRepository` (lọc đơn hàng theo user, đặt hàng từ giỏ hàng).
* **Trích lược code chính:**
  * Lớp `DonHang` kế thừa `BaseModel<String>` với getter id được override:
    ```dart
    class DonHang implements BaseModel<String> {
      final String orderId;
      @override
      String get id => orderId;
      // ... các thuộc tính khác
    }
    ```
  * Nghiệp vụ đơn hàng chuyên biệt trong `DonHangRepository`:
    ```dart
    class DonHangRepository extends InMemoryRepository<DonHang, String> {
      DonHangRepository(super.initialItems);
      
      List<DonHang> getByUserId(int userId) {
        final results = getAll().where((d) => d.userId == userId).toList();
        results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return results;
      }
    }
    ```
  * Xác thực người dùng chuyên biệt trong `NguoiDungRepository`:
    ```dart
    class NguoiDungRepository extends InMemoryRepository<NguoiDung, String> {
      NguoiDungRepository(super.initialItems);
      
      NguoiDung? authenticate(String email, String passwordHash) {
        try {
          return getAll().firstWhere((u) => u.email == email && u.passwordHash == passwordHash);
        } catch (_) { return null; }
      }
    }
    ```

---
*Báo cáo đồ án được xây dựng và hoàn thiện bởi các thành viên nhóm N03 lớp Lập trình thiết bị di động năm học 2025-2026.*
