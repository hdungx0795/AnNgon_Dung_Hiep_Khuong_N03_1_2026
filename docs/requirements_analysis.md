# Phân tích Yêu cầu Hệ thống (Tiêu chí 2)

## 1. Actors (Tác nhân)
Hệ thống PKA Food có 3 tác nhân chính:
- **Guest (Khách vãng lai):** Người dùng tải app nhưng chưa đăng nhập. Chỉ có thể xem Onboarding và màn hình Đăng nhập/Đăng ký.
- **User (Khách hàng):** Người dùng đã có tài khoản (đăng nhập bằng Số điện thoại & Mật khẩu), có quyền xem danh sách sản phẩm, đặt hàng, quản lý giỏ hàng (local Hive), và theo dõi lịch sử mua hàng.
- **Admin (Quản trị viên):** Người quản lý hệ thống (truy cập qua cổng AdminAuthService), có quyền thêm/chỉnh sửa sản phẩm, xem thống kê kinh doanh và cập nhật trạng thái các đơn hàng.

## 2. Yêu cầu Chức năng (Functional Requirements)
**Đối với Guest:**
- Đăng ký tài khoản mới bằng SĐT/Password qua Custom Auth.
- Đăng nhập vào hệ thống (không dùng Firebase Auth native).

**Đối với User:**
- Xem sản phẩm trên trang chủ (Home).
- Tìm kiếm sản phẩm theo tên.
- Lọc sản phẩm theo danh mục.
- Xem chi tiết sản phẩm.
- Quản lý giỏ hàng và danh sách Yêu thích (Offline Local bằng Hive).
- Đặt hàng (Thanh toán COD hoặc QR Transfer).
- Xem lịch sử đơn hàng bằng thao tác kéo xuống để làm mới (Pull-to-refresh).
- Theo dõi trạng thái đơn hàng hiện tại.
- Quản lý tài khoản (Đổi thông tin, Đăng xuất).

**Đối với Admin:**
- Đăng nhập Admin (Qua màn hình đăng nhập riêng).
- Xem Dashboard (thống kê tổng quan đơn hàng, doanh thu).
- Quản lý kho sản phẩm (Thêm sản phẩm, Ẩn/Hiện sản phẩm qua field isActive).
- Quản lý danh sách đơn hàng của toàn hệ thống (Xem chi tiết, thay đổi trạng thái, pull-to-refresh để sync).

## 3. Yêu cầu Phi chức năng (Non-functional Requirements)
- **Hiệu năng:** Tốc độ phản hồi các thao tác UI nhanh, mượt mà (60fps).
- **Lưu trữ Offline:** Giỏ hàng, session đăng nhập, danh sách yêu thích và cài đặt (Dark/Light mode) cần được lưu ở Local bằng Hive để tối ưu tốc độ và không phụ thuộc mạng.
- **Kiến trúc dữ liệu:** Sử dụng NoSQL (Firestore) cho lưu trữ đám mây. Đồng bộ dữ liệu qua cơ chế pull-to-refresh thay vì Stream liên tục để tiết kiệm quota. Không dùng SQL/SQLite/MySQL.
- **Bảo mật:** Hệ thống xác thực bằng Auth Service tùy chỉnh với mật khẩu được hash, admin truy cập tách biệt hoàn toàn với user bình thường.

## 4. Các Đối tượng Dữ liệu (Data Objects)
- **UserModel:** `id`, `name`, `phone`, `email`, `dob`, `passwordHash`, `avatarPath`, `createdAt` (Không có field role).
- **ProductModel:** `id`, `name`, `description`, `price`, `imageUrl`, `category`, `rating` (Dành cho App).
- **AdminProductModel:** `id`, `name`, `price`, `category`, `isActive`, `imagePreset` (Dành cho Admin Dashboard quản lý).
- **CartItemModel:** `productId`, `quantity`, `price` (Lưu Local).
- **OrderModel:** `id`, `userId`, `items`, `totalAmount`, `status`, `paymentMethod`, `shippingAddress`, `createdAt`
- **OrderItemModel:** Thông tin chi tiết món ăn trong một Order cụ thể.

## 5. Use Case Diagram (Sơ đồ Use Case)
```mermaid
usecaseDiagram
    actor Guest
    actor User
    actor Admin

    Guest --> (Register via Phone)
    Guest --> (Login via Phone)
    
    User --> (Browse Products)
    User --> (Manage Cart & Favorites locally)
    User --> (Checkout Order)
    User --> (Pull-to-Refresh Order Tracking)
    
    Admin --> (Admin Login Portal)
    Admin --> (View Dashboard)
    Admin --> (Manage Products - Toggle isActive)
    Admin --> (Update Order Status)
    
    User -|> Guest : extends
```
