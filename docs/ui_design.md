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

## 5. Thiết kế Giao diện mẫu theo yêu cầu của Giáo viên (Tiêu chí 5)

Để thực hiện **Tiêu chí 5 (Layout mẫu do giáo viên yêu cầu)**, nhóm đã phát triển và tích hợp trực tiếp bố cục trang chủ Grab Clone vào phân hệ **Khám phá (Trang chủ chính - ExploreTab)** của ứng dụng. Giao diện này được tinh chỉnh để phù hợp với ngôn ngữ thiết kế tổng thể của dự án và đảm bảo đầy đủ các tính năng tương tác thực tế:

### 5.1. Bố cục Giao diện mẫu (ExploreTab)
* **Header tích hợp (Màu đỏ chủ đạo):** Bỏ thanh appBar tách rời cũ, sử dụng header màu đỏ đặc trưng làm chìm vào phần cuộn trang.
  * *Logo User (Hồ sơ):* Nằm ở góc bên trái ngoài cùng, cho phép di chuyển nhanh sang tab Profile.
  * *Thanh tìm kiếm ("Tìm món ăn"):* Ô tìm kiếm bo góc ở giữa, độ cao được tinh chỉnh tối ưu còn 46px để không bị tràn trên màn hình hẹp.
  * *Badge điểm thưởng ("G"):* Màu vàng nổi bật nằm kế bên thanh tìm kiếm.
  * *Nút quét mã QR:* Ở góc ngoài cùng bên phải, kích thước icon được thu nhỏ thành 44px để tối ưu không gian hiển thị.
* **Grid 8 phím tắt dịch vụ:** 2 hàng x 4 cột với nền màu nhạt bo góc. Các nút gồm: **Xe máy**, **Combo**, **Đồ ăn**, **Giao nhanh**, **Đồ uống**, **Đặt bàn**, **Ví**, và **Tất cả**. Các nút như *Combo, Đồ ăn, Đồ uống, Tất cả* được liên kết trực tiếp với logic lọc của `ProductProvider` để lọc các món ăn thật trong cơ sở dữ liệu.
* **Ví MoMo liên kết (Thẻ Ví 9554):** Thay vì thẻ ngân hàng, giao diện hiển thị thẻ liên kết **Ví MoMo** với mã số ví `9554`. 
  * *Tính năng tương tác (Popup bottom sheet):* Khi người dùng chạm vào thẻ ví MoMo, một Bottom Sheet (Popup nổi lên) sẽ hiển thị thông tin chi tiết ví.
  * *Tùy chọn bật/tắt:* Nút Switch gạt bật/tắt dòng chữ **"Đặt làm phương thức chính"** (không lưu trạng thái logic phức tạp nhưng có phản hồi bật/tắt tức thời trên giao diện).
  * *Nút gỡ liên kết:* Dòng chữ **"Gỡ liên kết"** màu đỏ nổi bật ở dưới cùng, khi click sẽ đóng popup.
* **Banner Quảng cáo "Mua ngay" trượt ngang:**
  * Các banner khuyến mãi (như Combo Burger Coca, Combo Gia Đình, Gà rán nóng giòn) hiển thị hình ảnh kích thước lớn bo góc.
  * *Nút mũi tên điều hướng (chevron_right):* Mỗi banner có một nút mũi tên tròn gắn liền ở góc trên bên phải. Khi người dùng chạm vào nút này, hệ thống sẽ mở trực tiếp trang **Chi tiết món ăn (`ProductDetailScreen`)** tương ứng.
* **Bong bóng chat hỗ trợ (FAB - Floating Action Button):**
  * Nút tròn nổi cố định ở góc dưới cùng bên phải màn hình (biểu tượng tai nghe hỗ trợ `support_agent`). Nút này luôn giữ nguyên vị trí khi cuộn danh sách món ăn.
  * *Tính năng tương tác:* Khi bấm vào, một Bottom Sheet chat giả lập với nhân viên hỗ trợ An Ngon sẽ xuất hiện. Người dùng có thể xem tin nhắn chào mừng mặc định và gõ/gửi tin nhắn mô phỏng.

### 5.2. Các ảnh chụp màn hình minh họa nộp kèm
* `explore_tab_grab_clone.png`: Ảnh chụp toàn bộ trang chủ ExploreTab theo bố cục Grab Clone màu đỏ thương hiệu.
* `momo_bottom_sheet.png`: Ảnh chụp popup thông tin Ví MoMo liên kết kèm switch bật/tắt và nút gỡ liên kết màu đỏ.
* `support_chat_sheet.png`: Giao diện chat hỗ trợ giả lập nổi lên khi bấm bong bóng chat.
