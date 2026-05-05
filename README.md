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

---

## 📌 Nội dung buổi thi giữa kì - MidtermMidterm

### ✅ Nhiệm vụ cần thực thực hiện

* Nhóm sinh viên cập nhật công việc yêu cầu trong bài kiểm tra giữa kỳ lên ReadMe.md (Done)
* Sinh viên commit công việc của mình lên Github.
* Mỗi sinh viên làm 1 trang tùy chọn: Home, About, ContentContent
* Đưa code lên GitHub bằng Git.

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