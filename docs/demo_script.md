# Kịch bản Demo (Demo Script)

Tài liệu này cung cấp kịch bản chi tiết để quay Video Demo nộp bài tập lớn. Kịch bản bao phủ từ bước mở app, luồng của người dùng đến luồng của admin.

## Chuẩn bị
1. Mở máy ảo (Emulator) hoặc điện thoại thật.
2. Build và cài đặt app (hoặc dùng `flutter run`).
3. Chuẩn bị 2 tài khoản (1 user thường với Số điện thoại/Mật khẩu, 1 admin). Nếu chưa có tài khoản User, sử dụng tính năng Đăng ký.

## Kịch bản (3-5 phút)

### Phần 1: Giới thiệu & Đăng ký / Đăng nhập (45 giây)
1. **Khởi động app:** Hiển thị màn hình Splash và Onboarding. Vuốt qua các trang Onboarding và nhấn "Bắt đầu".
2. **Đăng nhập User:** Nhập Số điện thoại (VD: 0987654321) và password.
   *(Lưu ý: Không dùng Firebase Auth mặc định mà dùng Custom Auth qua Phone).*

### Phần 2: Luồng Người dùng (Customer Flow) (1 phút 30 giây)
1. **Duyệt & Tìm kiếm:**
   - Tại màn hình Home, cuộn xem danh sách sản phẩm (đồng bộ từ Firestore).
   - Chuyển sang Tab "Khám phá" (Explore) -> Tìm kiếm món ăn bất kỳ, thử bấm Lọc theo danh mục.
2. **Xem chi tiết & Thêm vào giỏ (Local Hive):**
   - Chọn một món ăn để xem chi tiết (hình ảnh, giá, mô tả).
   - Tăng/giảm số lượng -> Bấm "Thêm vào giỏ" (Tất cả được lưu Offline vào Hive để đảm bảo tốc độ mượt mà).
3. **Giỏ hàng (Cart):**
   - Chuyển sang Tab Giỏ hàng.
   - Thay đổi số lượng món ăn, thử vuốt/xóa món.
4. **Checkout (Đặt hàng):**
   - Nhấn "Thanh toán".
   - Chọn phương thức Thanh toán (COD hoặc QR).
   - Xác nhận đặt hàng -> Hệ thống gửi hóa đơn lên Firestore. Màn hình báo thành công.
5. **Theo dõi đơn hàng (Order Tracking):**
   - Chuyển sang Tab Hồ sơ (Profile) -> Đơn hàng của tôi.
   - Thấy đơn hàng vừa đặt đang ở trạng thái "Pending".
   - **Quan trọng:** Kéo xuống để Refresh (Pull-to-refresh) nhằm xác nhận dữ liệu được đồng bộ mới nhất từ Cloud.

### Phần 3: Luồng Quản trị viên (Admin Flow) (1 phút)
1. **Chuyển tài khoản:** Tại tab Hồ sơ, chọn Đăng xuất.
2. **Đăng nhập Admin:** Tại màn hình Login, chọn cổng AdminAuthService (thường có nút bí mật hoặc cổng login riêng) bằng tài khoản Admin (VD: `admin@pka.com`).
3. **Dashboard:** Màn hình Home của Admin hiển thị tổng đơn hàng, doanh thu.
4. **Quản lý Đơn hàng:**
   - Vào mục Quản lý Đơn hàng (Orders).
   - **Quan trọng:** Kéo xuống để Refresh (Pull-to-refresh) để lấy đơn hàng mới nhất của User ở phần 2.
   - Tìm đơn hàng vừa tạo, đổi trạng thái từ "Pending" sang "Processing" rồi "Delivered".
5. **Quản lý Sản phẩm:**
   - Vào mục Quản lý Sản phẩm (Products).
   - Thử tính năng "Ngừng/Bật phục vụ" (Toggle `isActive`) của một món ăn.
   - Nếu có thời gian, thêm nhanh 1 sản phẩm mới.

### Phần 4: Kết thúc (15 giây)
1. Đăng xuất Admin, đăng nhập lại User bằng SĐT.
2. Vào Hồ sơ -> Đơn hàng của tôi. **Kéo xuống để Refresh**.
3. Trạng thái đơn hàng của User đã được cập nhật thành "Delivered".
4. Đóng app, kết thúc video.
