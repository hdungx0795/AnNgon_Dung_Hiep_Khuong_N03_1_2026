# 🍔 PKA Food — Ứng dụng đặt đồ ăn trực tuyến

**Dự án:** AnNgon — Ứng dụng đặt đồ ăn trực tuyến  
**Nhóm:** Dũng, Hiệp, Khương  
**Lớp:** N03  
**Năm học:** 2025–2026

---

## 📝 Giới thiệu

PKA Food là ứng dụng đặt đồ ăn trực tuyến được xây dựng bằng **Flutter**, sử dụng kiến trúc **Provider + Hive** để quản lý trạng thái và lưu trữ dữ liệu local. Ứng dụng hỗ trợ đầy đủ các chức năng từ đăng ký/đăng nhập, duyệt menu, đặt hàng, theo dõi đơn hàng, đến quản lý tài khoản cá nhân.

---

## 🏗️ Kiến trúc dự án

```
lib/
├── main.dart                  # Entry point
├── app.dart                   # App configuration & routing
├── core/
│   ├── constants/             # Màu sắc, kích thước, chuỗi
│   ├── theme/                 # Theme & styling
│   └── utils/                 # Format, hash, validators
├── models/                    # Data models (Hive adapters)
│   └── enums/                 # Category, OrderStatus, PaymentMethod
├── providers/                 # State management (Provider)
├── screens/                   # Các màn hình UI
│   ├── auth/                  # Đăng nhập, Đăng ký, Quên mật khẩu
│   ├── chat/                  # Chat & gọi shipper
│   ├── checkout/              # Thanh toán
│   ├── home/                  # Trang chính + tabs
│   ├── onboarding/            # Màn hình giới thiệu
│   ├── order/                 # Lịch sử đơn hàng
│   ├── product/               # Chi tiết sản phẩm
│   ├── profile/               # Hồ sơ & đổi mật khẩu
│   ├── splash/                # Splash screen
│   └── tracking/              # Theo dõi đơn hàng
└── services/                  # Business logic & data access
```

---

## ✨ Tính năng chính

| Tính năng | Mô tả |
|---|---|
| 🔐 Đăng ký / Đăng nhập | Xác thực bằng SĐT + mật khẩu (SHA-256 hash) |
| 🏠 Trang chủ | Duyệt menu theo danh mục: Đồ ăn, Đồ uống, Combo |
| 🛒 Giỏ hàng | Thêm/xóa/cập nhật số lượng món ăn |
| 💳 Thanh toán | Hỗ trợ nhiều phương thức thanh toán & mã giảm giá |
| 📦 Theo dõi đơn hàng | Timeline trạng thái đơn hàng |
| ❤️ Yêu thích | Lưu danh sách món ăn yêu thích |
| 👤 Hồ sơ cá nhân | Chỉnh sửa thông tin, đổi mật khẩu |
| 💬 Chat / Gọi shipper | Giao tiếp với người giao hàng |
| 🔔 Thông báo | Thông báo local cho đơn hàng |
| 🌙 Dark mode | Hỗ trợ giao diện sáng/tối |
| 📱 Onboarding | Màn hình giới thiệu khi lần đầu mở app |

---

## 🛠️ Công nghệ sử dụng

| Công nghệ | Mục đích |
|---|---|
| **Flutter** | Framework UI đa nền tảng |
| **Dart** | Ngôn ngữ lập trình |
| **Provider** | Quản lý trạng thái |
| **Hive** | Cơ sở dữ liệu NoSQL local |
| **crypto** | Mã hóa mật khẩu (SHA-256) |
| **Google Fonts** | Typography |
| **flutter_local_notifications** | Thông báo local |
| **intl** | Định dạng tiền tệ, ngày tháng |

---

## 🚀 Hướng dẫn cài đặt & chạy

### Yêu cầu hệ thống
- Flutter SDK >= 3.11.4
- Dart SDK >= 3.11.4
- Android Studio / VS Code
- Android Emulator hoặc thiết bị thật

### Các bước chạy

```bash
# 1. Clone repository
git clone https://github.com/hdungx0795/AnNgon_Dung_Hiep_Khuong_N03_1_2026.git

# 2. Di chuyển vào thư mục dự án
cd AnNgon_Dung_Hiep_Khuong_N03_1_2026

# 3. Cài đặt dependencies
flutter pub get

# 4. Chạy ứng dụng
flutter run
```

### Tài khoản test

| SĐT | Mật khẩu |
|---|---|
| 0987654321 | 123456 |

---

## 📂 Dữ liệu mẫu

Ứng dụng sử dụng file `assets/seeddata.json` chứa:
- **30 sản phẩm** (13 đồ ăn, 10 đồ uống, 7 combo)
- **3 mã giảm giá**: `PKANEW`, `FREESHIP`, `COMBO20`
- **1 tài khoản mẫu** để test

---

## 👥 Thành viên nhóm

| Thành viên | Vai trò |
|---|---|
| Dũng | Developer |
| Hiệp | Developer |
| Khương | Developer |

---

## 📄 License

Dự án này được phát triển phục vụ mục đích học tập tại trường Đại học Phenikaa.
