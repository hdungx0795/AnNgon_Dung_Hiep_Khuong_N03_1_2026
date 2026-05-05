# 📱 Project: Ứng dụng Đồ Ăn

## 👥 Thành viên nhóm

* Lưu Đức Hiệp - 23010437
* Hoàng Văn Dũng - 23010438
* Nguyễn Kim Khương - 23010428

---

## 📌 Nội dung buổi thực hành 01

### ✅ Nhiệm vụ đã thực hiện

* Tạo repository nhóm trên GitHub.
* Thêm thành viên vào repository.
* Tạo project Flutter framework.
* Chỉnh sửa giao diện:
  * Đổi tên ứng dụng: **Ứng dụng Đồ Ăn**
  * Hiển thị thông tin thành viên nhóm
* Đưa code lên GitHub bằng Git.

---

## 📌 Nội dung buổi thực hành 02

### ✅ Nhiệm vụ đã thực hiện (Theo yêu cầu bài tập)

* **1. Xây dựng đối tượng & Khai báo biến (OOP):**
  * Xây dựng Class `NguoiDung` với các biến mô tả cụ thể: `idUser` (int), `hoTen` (String), `soDienThoai` (String), `diaChi` (String), `email` (String).
* **2. Sử dụng Collections (List/Array):**
  * Áp dụng Collection dạng mảng `List<NguoiDung> danhSachNhom` để lưu trữ tập trung dữ liệu của 3 thành viên trong nhóm (thay vì dùng các biến rời rạc).
* **3. Hiển thị dữ liệu lên Widget:**
  * Render dữ liệu động từ List ra giao diện bằng cách sử dụng vòng lặp `.map()` kết hợp toán tử Spread (`...`).
  * Trình bày thông tin từng đối tượng người dùng thành các khối `Column` chứa các `Text` thông tin (Họ tên, SĐT, Địa chỉ) và ngăn cách bằng `Divider`.

---

## 📌 Nội dung buổi thực hành 03

### ✅ Nhiệm vụ đã thực hiện (OOP Nâng cao & Generics)

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

## 📌 Bài kiểm tra giữa kỳ - Phần việc cá nhân

### ✅ Công việc của tôi: `AboutScreen`

* Thành viên thực hiện: **Lưu Đức Hiệp - 23010437**
* File thực hiện: `lib/midterm/about_screen.dart`
* Xây dựng giao diện màn hình About theo bố cục bài yêu cầu.
* Chỉnh màu giao diện theo mẫu tham khảo với tông trắng, xám và đen.
* Thiết kế các phần chính gồm:
  * Thanh điều hướng phía trên
  * Tiêu đề và mô tả giới thiệu ứng dụng
  * Form liên hệ / phản hồi
  * Footer gồm icon và các cột thông tin
* Bổ sung hiệu ứng nhấn cho:
  * Logo
  * Các mục menu trên thanh điều hướng
  * Các nút `Đăng nhập`, `Đăng ký`, `Gửi phản hồi`
  * Các icon và các mục nội dung trong footer
* Các thành phần hiện tại chỉ tạo tương tác nhấn, chưa xử lý điều hướng sang trang khác.
#### Phần được phân công: `ContentScreen` (Trang Thực đơn)
**Sinh viên thực hiện:** Nguyễn Kim Khương - 23010428

* **File thực hiện:** `lib/midterm/content_screen.dart`
* **Mô tả công việc:** 
  * Xây dựng hoàn thiện giao diện trang Content theo bố cục Figma yêu cầu, áp dụng chủ đề ứng dụng đặt đồ ăn "Ăn Ngon".
  * Thiết kế UI bám sát phong cách tối giản (Monochrome) với tông màu chủ đạo là Trắng, Xám và Đen.
* **Các thành phần (Widget) chính đã thiết kế:**
  * `_NavBar`: Thanh điều hướng chứa Logo, Menu Links và các nút Đăng nhập/Đăng ký.
  * `_HeroSection`: Khối banner giới thiệu thông điệp chính của ứng dụng.
  * `_TwoLargeCardsSection`: Khối thẻ hiển thị các chương trình khuyến mãi lớn (Siêu Sale, Freeship).
  * `_HorizontalListSection`: Danh sách nhà hàng nổi bật theo chiều ngang.
  * `_GridSection`: Lưới danh sách gợi ý món ăn hôm nay.
  * `_FooterSection`: Chân trang chứa thông tin liên hệ và các liên kết hỗ trợ.
* **Kỹ thuật nổi bật áp dụng:**
  * **Responsive Design:** Tích hợp `MediaQuery` để tự động tính toán kích thước màn hình. Giao diện có khả năng co giãn linh hoạt, tự động chuyển đổi bố cục từ ngang (`Row`) sang dọc (`Column`) để hiển thị hoàn hảo, không bị ép chữ (overflow) trên các thiết bị di động (Mobile).
  * Bóc tách thành phần (Component-based) giúp code rõ ràng, dễ bảo trì và tái sử dụng.
  * Tích hợp hiệu ứng cuộn (`SingleChildScrollView`) mượt mà cho toàn bộ trang
---

## ⚙️ Công nghệ sử dụng

* **Nền tảng:** Flutter & Dart
* **Kiến trúc & Kỹ thuật:** * Quản lý trạng thái cơ bản (`StatefulWidget`, `setState`)
  * Lập trình hướng đối tượng (OOP: Classes, Objects, Methods)
  * Collections (List, Array, Maps)
  * Generics (Kiểu dữ liệu tổng quát) & Static
* **Quản lý phiên bản:** Git & GitHub

---

## 🚀 Hướng dẫn chạy project

Cloning dự án và cài đặt các thư viện cần thiết:

```bash
git clone <link-repo-github-cua-nhom>
cd an_ngon_app
flutter pub get
flutter run
