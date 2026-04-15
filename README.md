# BÀI TẬP THỰC HÀNH SỐ 2 - LẬP TRÌNH FLUTTER

**Sinh viên:** [Tên của bạn]
**Lớp:** [Tên lớp]
**Dự án:** PKA Food (Ứng dụng đặt đồ ăn trực tuyến)

---

## 📚 Nội dung thực hiện

### 1. Khai báo biến (Câu 1)
Trong bài tập này, em xây dựng 3 đối tượng cốt lõi cho ứng dụng đặt đồ ăn:

*   **Món Ăn (MonAn):** `idMon` (int), `tenMon` (String), `gia` (int), `danhMuc` (String), `danhGia` (double).
*   **Khách Hàng (KhachHang):** `idKH` (int), `tenKH` (String), `soDienThoai` (String), `email` (String), `diaChi` (String).
*   **Đơn Hàng (DonHang):** Kết nối giữa Món ăn và Khách hàng với các biến: `idDon`, `maKhachHang`, `maMon`, `soLuong`, `tongTien`, `trangThai`, `ngayDat`.

### 2. Sử dụng Collections (Câu 2)
Em sử dụng `List<Map<String, dynamic>>` để quản lý danh sách dữ liệu giả định:
*   `listMonAn`: Chứa 5 món ăn tiêu biểu (Hamburger, Mỳ Ý, Matcha...).
*   `listKhachHang`: Chứa danh sách người dùng mẫu.
*   `listDonHang`: Chứa các bản ghi giao dịch thực tế.

### 3. Hiển thị dữ liệu (Câu 3)
Dữ liệu được hiển thị trên giao diện Flutter ứng dụng các Widget:
*   `SingleChildScrollView`: Để cuộn trang.
*   `Card` & `Padding`: Để tạo khung hiển thị chuyên nghiệp.
*   **Row & Column**: Hiển thị dữ liệu dạng hàng (giống bảng) để giảng viên dễ theo dõi.
*   `Container` với `BoxDecoration`: Để tạo các nhãn (badge) trạng thái có màu sắc (Đang giao - Xanh, Hoàn thành - Xanh lá...).

---

## 📸 Hình ảnh minh họa

*(Ghi chú: Bạn hãy chụp ảnh màn hình code và ứng dụng hiện tại rồi chèn vào đây hoặc nộp kèm file)*

1.  **Code Câu 1, 2, 3:** [Link ảnh code]
2.  **Ứng dụng đang chạy:** [Link ảnh app]

---

## 🔗 Liên kết nộp bài
*   **Github Repo:** [Dán link github của bạn vào đây]
*   **Video demo (nếu có):** [Link video]
