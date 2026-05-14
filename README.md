# 🍔 PKA Food v2.0 — Báo cáo Đồ án Ứng dụng Đặt Đồ Ăn Trực Tuyến

**Tên dự án:** AnNgon (PKA Food)  
**Nhóm thực hiện:** Dũng, Hiệp, Khương  
**Lớp:** N03  
**Năm học:** 2025–2026  
**Nền tảng:** Flutter (Android/iOS)

---

## 📑 Tóm tắt dự án (Abstract)

**PKA Food v2.0** là phiên bản nâng cấp toàn diện (modernized) của ứng dụng đặt đồ ăn trực tuyến được xây dựng bằng framework **Flutter**. Đồ án này tập trung vào việc mô phỏng một quy trình thương mại điện tử F&B (Food & Beverage) hoàn chỉnh từ góc độ người dùng cuối (End-User App). 

Ứng dụng được thiết kế theo triết lý **Local-First**, sử dụng hệ thống cơ sở dữ liệu NoSQL (Hive) để lưu trữ cục bộ toàn bộ dữ liệu (từ sản phẩm, tài khoản, giỏ hàng đến lịch sử đơn hàng). Giao diện UI/UX được chuẩn hóa theo hệ thống Design System đồng nhất, kế thừa ngôn ngữ thiết kế Material Design 3, mang lại trải nghiệm mượt mà, hiện đại và nhất quán trên cả chế độ Sáng và Tối (Light/Dark Mode).

---

## ✨ 1. Tính năng cốt lõi (Core Features)

Dự án mô phỏng toàn vẹn vòng đời của một ứng dụng đặt đồ ăn thực tế thông qua các tính năng sau:

### 1.1 Xác thực & Quản lý Tài khoản (Authentication & Profile)
- **Đăng ký / Đăng nhập:** Hệ thống xác thực bằng Số điện thoại và Mật khẩu. Mật khẩu được băm (hashing) bảo mật chuẩn **SHA-256** trước khi lưu trữ vào Hive.
- **Quản lý phiên (Session):** Duy trì trạng thái đăng nhập xuyên suốt các lần mở app.
- **Quản lý Hồ sơ:** Cập nhật thông tin cá nhân, thay đổi mật khẩu an toàn với các quy tắc xác thực (validation) chặt chẽ. Cung cấp các công cụ giả lập Trung tâm trợ giúp và Cài đặt thông báo.

### 1.2 Duyệt Menu & Tìm kiếm (Discovery)
- **Trang chủ (Explore):** Phân loại sản phẩm thông minh theo danh mục (Đồ ăn, Đồ uống, Combo).
- **Trải nghiệm tìm kiếm:** Cung cấp công cụ tìm kiếm và lọc sản phẩm mượt mà, kết hợp với các hiệu ứng UI (Shimmer, FadeInImage) khi tải dữ liệu.
- **Yêu thích (Favorites):** Lưu lại danh sách các món ăn yêu thích của cá nhân.

### 1.3 Giỏ hàng & Thanh toán (Cart & Checkout)
- **Quản lý Giỏ hàng:** Tính toán tổng tiền theo thời gian thực, quản lý số lượng và tùy chọn món ăn. Xử lý triệt để các rủi ro về bất đồng bộ (async races) khi thao tác giỏ hàng.
- **Thanh toán (Checkout):** 
  - Quản lý địa chỉ giao hàng và phương thức thanh toán.
  - Hỗ trợ áp dụng Mã giảm giá (Vouchers) tự động khấu trừ.
  - Mô phỏng quá trình đặt hàng và chuyển trạng thái dữ liệu.

### 1.4 Theo dõi Đơn hàng & Liên lạc (Tracking & Communication)
- **Timeline Đơn hàng:** Cung cấp giao diện trạng thái đơn hàng (Chuẩn bị -> Lấy hàng -> Đang giao -> Hoàn tất).
- **Tương tác Shipper:** Giao diện gọi điện (Dialer) và Nhắn tin (Chat) mô phỏng tương tác thời gian thực với tài xế giao hàng.
- **Lịch sử Đơn hàng:** Phân loại đơn hàng Đang giao, Đã giao và Đã hủy. Hỗ trợ tính năng "Đặt lại đơn" (Reorder) cực kỳ tiện lợi.

---

## 🏗️ 2. Kiến trúc & Thiết kế hệ thống (Architecture)

Dự án áp dụng mô hình kiến trúc phân lớp (Layered Architecture) kết hợp với **Provider Pattern** để đảm bảo khả năng bảo trì và mở rộng code.

### 2.1 Cấu trúc phân lớp
1. **Presentation Layer (UI/UX):** Bao gồm các `Screen` và `Widget` tách biệt, hoàn toàn không chứa logic nghiệp vụ.
2. **State Management Layer (Providers):** Sử dụng `ChangeNotifier` để quản lý trạng thái của Cart, Order, Auth, Theme, Product. Đóng vai trò là cầu nối giữa UI và Data.
3. **Service / Data Layer (Services):** Chứa các class chịu trách nhiệm tương tác trực tiếp với cơ sở dữ liệu Hive, xử lý nghiệp vụ, hashing, v.v.

### 2.2 Sơ đồ thư mục (Directory Structure)
```
lib/
├── core/
│   ├── constants/       # Design System (Colors, Sizes, TextStyles)
│   ├── theme/           # Cấu hình MaterialTheme Data (Light/Dark)
│   └── utils/           # Utilities (HashUtils, Formatters, Validators)
├── models/              # Các Data Entity và Hive Adapters
├── providers/           # Các lớp State Management
├── screens/             # Phân nhóm theo feature (auth, cart, home, order...)
├── services/            # Tương tác Database, Notification
├── widgets/             # Các thành phần giao diện dùng chung (AppButtons, AppInputs)
└── main.dart            # Entry point & Khởi tạo Database
```

---

## 🛠️ 3. Công nghệ & Thư viện (Tech Stack)

Dự án hạn chế sử dụng các thư viện bên ngoài không cần thiết để tối ưu dung lượng và tốc độ, chỉ tập trung vào các công nghệ cốt lõi:

| Thành phần | Công nghệ / Thư viện | Mục đích sử dụng |
|---|---|---|
| **Framework** | `Flutter` / `Dart` | Xây dựng UI đa nền tảng |
| **State** | `provider` | Quản lý trạng thái ứng dụng |
| **Database** | `hive`, `hive_flutter` | Cơ sở dữ liệu NoSQL cục bộ, tốc độ siêu cao |
| **Security** | `crypto` | Băm mật khẩu (SHA-256) đảm bảo an toàn dữ liệu giả lập |
| **UI/UX** | `google_fonts` | Cung cấp Typography hiện đại, đồng nhất |
| **Format** | `intl` | Định dạng tiền tệ VND và thời gian (DateTime) |

---

## 🧪 4. Kiểm thử & Đảm bảo Chất lượng (QA)

Ứng dụng được bảo vệ bởi một hệ thống Unit Tests & Widget Tests chặt chẽ, đạt **98/98 Tests Passed**, đảm bảo tính ổn định của các luồng dữ liệu quan trọng:
- **Auth Tests:** Xác thực form đăng nhập/đăng ký, kiểm thử hashing password.
- **Provider Tests:** Đảm bảo giỏ hàng tính toán đúng tổng tiền, các chức năng lọc sản phẩm hoạt động chính xác.
- **UI Tests:** Đảm bảo các component giao diện render đúng với cả Light Mode và Dark Mode.
- **Code Quality:** Không tồn tại warning hay error khi chạy lệnh phân tích tĩnh (`flutter analyze`).

---

## 🚀 5. Hướng dẫn cài đặt & Triển khai

### Yêu cầu môi trường
- **Flutter SDK:** >= 3.11.4
- **Dart SDK:** >= 3.11.4
- Môi trường IDE (VS Code, Android Studio) đã cài đặt Flutter plugin.

### Các bước khởi chạy

1. **Clone repository về máy:**
   ```bash
   git clone https://github.com/hdungx0795/AnNgon_Dung_Hiep_Khuong_N03_1_2026.git
   cd AnNgon_Dung_Hiep_Khuong_N03_1_2026
   ```

2. **Cài đặt các gói phụ thuộc (Dependencies):**
   ```bash
   flutter pub get
   ```

3. **Chạy ứng dụng (trên máy ảo hoặc thiết bị thật):**
   ```bash
   flutter run
   ```

*(Lưu ý: Ứng dụng đã được tích hợp sẵn hệ thống **Seeding Service**. Trong lần chạy đầu tiên, cơ sở dữ liệu Hive sẽ tự động được khởi tạo với toàn bộ danh mục sản phẩm, mã giảm giá và tài khoản mẫu).*

---

## 🔑 6. Dữ liệu Demo (Seed Data)

Ứng dụng sử dụng dữ liệu giả lập chất lượng cao từ `assets/seeddata.json`:
- **Danh mục:** Đồ ăn (13 món), Đồ uống (10 món), Combo (7 món).
- **Vouchers:** `PKANEW` (Giảm 20k), `FREESHIP` (Miễn phí vận chuyển), `COMBO20` (Giảm 20% cho combo).

**Tài khoản Test mặc định:**
- **Số điện thoại:** `0987654321`
- **Mật khẩu:** `123456`

---

## 📄 License
Đồ án này được phát triển nội bộ bởi nhóm sinh viên Dũng, Hiệp, Khương nhằm mục đích nghiên cứu và học tập môn học tại trường đại học. Không phục vụ mục đích thương mại.
