# Thiết kế Giao diện (Tiêu chí 4)

**Lưu ý quan trọng:** Wireframe chi tiết được chuẩn bị bằng bản vẽ tay và Figma, đính kèm trong báo cáo/nộp bài. File Markdown này mô tả mapping giữa bản thiết kế và màn hình trong ứng dụng.

Figma link: [Điền link khi xuất báo cáo]

## 1. Mục tiêu thiết kế giao diện
- Đảm bảo tính thẩm mỹ, hiện đại và thân thiện với người dùng (UX/UI).
- Tối ưu hóa luồng thao tác từ lúc tìm kiếm món ăn đến khi hoàn tất đặt hàng.
- Thể hiện sự tách biệt rõ ràng giữa hai vai trò: Khách hàng (User) và Quản trị viên (Admin).
- Tối đa hóa trải nghiệm offline-first bằng cách xử lý khéo léo các trạng thái gián đoạn mạng.

## 2. Danh sách màn hình chính đã thiết kế

### 2.1. Phía Người dùng (User App)
- **Onboarding:** Giới thiệu các tính năng cốt lõi của ứng dụng PKA Food cho người dùng mới.
- **Login/Register:** Giao diện xác thực bằng số điện thoại và mật khẩu.
- **Home/Explore:** Trang chủ trưng bày sản phẩm, danh mục, hỗ trợ tìm kiếm và bộ lọc món ăn.
- **Product Detail:** Hiển thị hình ảnh kích thước lớn, giá, mô tả món ăn và tuỳ chọn thêm vào giỏ hàng.
- **Cart:** Màn hình giỏ hàng được quản lý cục bộ (Local), cho phép chỉnh sửa số lượng trước khi đặt.
- **Checkout/QR bank transfer:** Giao diện xác nhận đơn hàng, áp dụng Voucher, chọn hình thức thanh toán COD hoặc quét mã QR chuyển khoản tĩnh.
- **Orders/Tracking:** Theo dõi tiến trình đơn hàng (Pending, Processing, Delivered) và xem lịch sử giao dịch.
- **Favorites:** Danh sách các món ăn được người dùng đánh dấu yêu thích (Lưu cục bộ).
- **Profile:** Quản lý thông tin tài khoản và thực hiện đăng xuất.

### 2.2. Phía Quản trị viên (Admin Portal)
- **Admin Login:** Giao diện đăng nhập bảo mật và độc lập.
- **Admin Dashboard:** Bảng điều khiển thống kê tổng quan doanh thu và tình trạng đơn hàng.
- **Admin Products:** Màn hình hiển thị danh sách sản phẩm, tuỳ chọn thêm mới, chỉnh sửa và ẩn/hiện sản phẩm.
- **Admin Orders:** Màn hình xem danh sách đơn hàng toàn hệ thống và thao tác cập nhật trạng thái đơn.

## 3. Điều hướng chính (Navigation)
- **User Bottom Navigation:** Thanh điều hướng dưới cùng giúp User chuyển đổi mượt mà giữa các trang: Home, Favorites, Cart, Orders, Profile.
- **Admin Dashboard/Tabs:** Thanh điều hướng riêng giúp Admin dễ dàng di chuyển giữa Dashboard, Products, và Orders.

## 4. Trạng thái UI (UI States)
Hệ thống giao diện được thiết kế bao phủ các trạng thái đặc biệt nhằm cải thiện trải nghiệm:
- **Loading:** Hiển thị vòng xoay (CircularProgressIndicator) hoặc Shimmer khi ứng dụng đang gọi API hoặc xử lý logic nặng.
- **Empty:** Các trang minh hoạ trạng thái trống (Empty State) sinh động khi Giỏ hàng rỗng, Lịch sử mua hàng trống, hay danh sách Yêu thích chưa có gì.
- **Error/Fallback:** Các thông báo lỗi thân thiện qua SnackBar hoặc màn hình Fallback khi thiết bị mất mạng (đọc dữ liệu từ Hive Cache).
- **Pull-to-refresh:** Giao diện kéo xuống để làm mới (RefreshIndicator) được áp dụng ở các danh sách cần đồng bộ cloud (Lịch sử đơn hàng, Admin Products, Admin Orders).
