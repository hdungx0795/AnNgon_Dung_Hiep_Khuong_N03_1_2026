# Phân tích Yêu cầu Hệ thống (Tiêu chí 2)

## 1. Tổng quan bài toán
PKA Food là một ứng dụng đặt đồ ăn trực tuyến dành cho thiết bị di động. Hệ thống cho phép người dùng (User) duyệt danh sách món ăn, quản lý giỏ hàng offline, áp dụng mã giảm giá và đặt hàng thông qua đồng bộ cơ sở dữ liệu trên cloud. Đồng thời, hệ thống cung cấp cổng đăng nhập riêng cho Quản trị viên (Admin) để quản lý danh sách sản phẩm, theo dõi đơn hàng và theo dõi hiệu suất kinh doanh qua Dashboard. Dự án chú trọng vào tính ổn định, tốc độ phản hồi nhanh qua local caching và thiết kế testable architecture.

## 2. Actors (Tác nhân)
Hệ thống PKA Food có 3 tác nhân chính:
- **Guest (Khách vãng lai):** Người dùng tải app nhưng chưa đăng nhập. Chỉ có thể xem Onboarding và màn hình Đăng nhập/Đăng ký.
- **User (Khách hàng):** Người dùng đã có tài khoản (đăng nhập bằng Số điện thoại & Mật khẩu), có quyền xem danh sách sản phẩm, đặt hàng, áp mã giảm giá, quản lý giỏ hàng (local Hive), và theo dõi lịch sử mua hàng.
- **Admin (Quản trị viên):** Người quản lý hệ thống (truy cập qua cổng AdminAuthService), có quyền thêm/sửa/ẩn sản phẩm, xem thống kê kinh doanh và cập nhật trạng thái các đơn hàng.

## 3. Yêu cầu Chức năng (Functional Requirements)
**Đối với Guest:**
- Xem màn hình Onboarding giới thiệu app.
- Đăng ký tài khoản mới bằng SĐT/Password qua Custom Auth.
- Đăng nhập vào hệ thống (không dùng Firebase Auth native).

**Đối với User:**
- Xem sản phẩm trên trang chủ (Home).
- Tìm kiếm sản phẩm theo tên.
- Lọc sản phẩm theo danh mục.
- Xem chi tiết sản phẩm.
- Quản lý giỏ hàng và danh sách Yêu thích (Offline Local bằng Hive).
- Áp dụng Voucher giảm giá vào đơn hàng.
- Đặt hàng (Thanh toán COD hoặc QR Transfer).
- Xem lịch sử đơn hàng bằng thao tác kéo xuống để làm mới (Pull-to-refresh).
- Theo dõi trạng thái đơn hàng hiện tại.
- Quản lý tài khoản (Đổi thông tin, Đăng xuất).

**Đối với Admin:**
- Đăng nhập Admin (Qua màn hình đăng nhập riêng `AdminAuthService`).
- Xem Dashboard (thống kê tổng quan đơn hàng, doanh thu).
- Quản lý kho sản phẩm (CRUD: Thêm, Xem, Sửa sản phẩm, Ẩn/Hiện sản phẩm qua field isActive).
- Quản lý danh sách đơn hàng của toàn hệ thống (Xem chi tiết, thay đổi trạng thái, pull-to-refresh để sync Firestore).

## 4. Yêu cầu Phi chức năng (Non-functional Requirements)
- **Hiệu năng & Demo Stability:** Tốc độ phản hồi các thao tác UI nhanh, mượt mà (60fps), đảm bảo tính ổn định cao khi chạy demo trực tiếp.
- **Lưu trữ Offline Fallback:** Giỏ hàng, session đăng nhập, danh sách yêu thích và cài đặt (Dark/Light mode) cần được cache ở Local bằng Hive để tối ưu tốc độ và hoạt động mượt mà ngay cả khi kết nối mạng kém.
- **Kiến trúc dữ liệu:** Sử dụng Firebase Firestore NoSQL cho lưu trữ đám mây. Đồng bộ dữ liệu qua cơ chế pull-to-refresh (manual sync) thay vì realtime stream liên tục để tối ưu hiệu suất và tiết kiệm quota.
- **Bảo mật:** Hệ thống xác thực Custom Auth không dùng Firebase Auth. Quản trị viên truy cập portal tách biệt hoàn toàn với user bình thường.
- **Testability:** Hệ thống được thiết kế theo cấu trúc tách biệt logic và UI, tạo điều kiện thuận lợi cho việc viết Unit Test và Integration Test dễ dàng.

## 5. Các Đối tượng Dữ liệu (Data Objects)
- **UserModel:** `id`, `name`, `phone`, `email`, `dob`, `passwordHash`, `avatarPath`, `createdAt` (Không có field role).
- **ProductModel:** `id`, `name`, `description`, `price`, `imageUrl`, `category`, `rating` (Dành cho App).
- **AdminProductModel:** `id`, `name`, `price`, `category`, `isActive`, `imagePreset` (Dành cho Admin Dashboard quản lý).
- **CartItemModel:** `productId`, `quantity`, `price` (Lưu Local bằng Hive).
- **OrderModel:** `id`, `userId`, `items`, `totalAmount`, `status`, `paymentMethod`, `shippingAddress`, `createdAt`
- **VoucherModel:** `id`, `code`, `discountPercentage`, `isActive`

## 6. Use Case Diagram (Sơ đồ Use Case)
```mermaid
usecaseDiagram
    actor Guest
    actor User
    actor Admin

    Guest --> (View Onboarding)
    Guest --> (Register via Phone)
    Guest --> (Login via Phone)
    
    User --> (Browse & View Products)
    User --> (Manage Cart & Favorites locally)
    User --> (Apply Voucher)
    User --> (Checkout Order)
    User --> (Pull-to-Refresh Order Tracking)
    
    Admin --> (Admin Login Portal)
    Admin --> (View Dashboard)
    Admin --> (CRUD Products & Toggle isActive)
    Admin --> (View & Update Order Status)
    
    User -|> Guest : extends
```
