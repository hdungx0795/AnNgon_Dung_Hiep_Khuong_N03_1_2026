# Thiết kế Giao diện (Tiêu chí 4)

Tài liệu này cung cấp mô phỏng (Wireframe/Mockup dạng text) cho các màn hình chính của ứng dụng PKA Food, đáp ứng các yêu cầu thiết kế UI/UX theo tiêu chí 4.

## 1. Màn hình Onboarding / Splash
```text
+-----------------------------------+
|                                   |
|           [ Logo PKA Food ]       |
|                                   |
|   "Giao đồ ăn nhanh chóng,        |
|    Tiện lợi mọi lúc mọi nơi"      |
|                                   |
|    ( ) (o) ( )                    |
|                                   |
|    [ Bắt đầu ngay ]               |
|                                   |
+-----------------------------------+
```

## 2. Màn hình Login (Dành cho User)
```text
+-----------------------------------+
| Đăng nhập                         |
|                                   |
| Số điện thoại:                    |
| [ ___________________________ ]   |
|                                   |
| Mật khẩu:                         |
| [ ___________________________ ]   |
|                                   |
|       [ ĐĂNG NHẬP ]               |
|                                   |
| Chưa có tài khoản? [Đăng ký]      |
|                                   |
|   (Admin access ở góc dưới)       |
+-----------------------------------+
```

## 3. Màn hình Home (User)
```text
+-----------------------------------+
| Xin chào, [Tên User]      (Icon)  |
|                                   |
| [ Tìm kiếm món ăn...      (🔍) ]  |
|                                   |
| -- Danh mục --                    |
| [Gà Rán] [Đồ Uống] [Tráng miệng]  |
|                                   |
| -- Món Bán Chạy --                |
| +---------+      +---------+      |
| | (Image) |      | (Image) |      |
| | Gà sốt  |      | Trà sữa |      |
| | 50.000đ |      | 25.000đ |      |
| | [+]     |      | [+]     |      |
| +---------+      +---------+      |
|                                   |
| [Home]   [Explore]   [Cart(2)]    |
+-----------------------------------+
```

## 4. Màn hình Product Detail
```text
+-----------------------------------+
| [< Back]               [Heart]    |
|                                   |
|      [   Hình ảnh Sản phẩm   ]    |
|                                   |
| Gà rán sốt Hàn Quốc               |
| ⭐️ 4.8  |  🕒 15 mins            |
|                                   |
| Mô tả:                            |
| Gà chiên giòn phủ sốt cay ngọt... |
|                                   |
| Số lượng:  [-] 1 [+]              |
|                                   |
| [ Thêm vào giỏ - 50.000đ ]        |
+-----------------------------------+
```

## 5. Màn hình Cart & Checkout
```text
+-----------------------------------+
| Giỏ hàng của bạn (Lưu offline)    |
|                                   |
| (Hình) Gà rán   x1  50.000đ [x]   |
| (Hình) Trà sữa  x2  50.000đ [x]   |
| --------------------------------- |
| Tổng phụ:              100.000đ   |
| Phí giao hàng:         20.000đ    |
| Tổng cộng:             120.000đ   |
|                                   |
| Phương thức: [ COD / QR Pay ]     |
|                                   |
| [ THANH TOÁN (Sync Cloud) ]       |
+-----------------------------------+
```

## 6. Màn hình Admin Dashboard
```text
+-----------------------------------+
| Admin Dashboard                   |
|                                   |
| Tổng Doanh thu:     1.250.000đ    |
| Đơn hàng chờ xử lý: 5             |
|                                   |
| -- Quản lý nhanh --               |
| [ Quản lý Sản phẩm ]              |
| [ Quản lý Đơn hàng ]              |
|                                   |
| [ Thêm sản phẩm mới ]             |
|                                   |
| [Home]    [Products]   [Orders]   |
+-----------------------------------+
```

## 7. Màn hình Admin Orders
```text
+-----------------------------------+
| Quản lý Đơn hàng                  |
|  (Vuốt xuống để làm mới...)       |
|                                   |
| Đơn #1234 - User: Hiep            |
| Trạng thái: [Pending v]           |
| Tổng: 120.000đ                    |
| [ Cập nhật ]                      |
| --------------------------------- |
| Đơn #1235 - User: Dung            |
| Trạng thái: [Delivered v]         |
| Tổng: 55.000đ                     |
| [ Cập nhật ]                      |
+-----------------------------------+
```
