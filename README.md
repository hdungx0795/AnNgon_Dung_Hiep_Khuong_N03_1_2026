# 📱 Project: Ứng dụng Đồ Ăn

## 👥 Thành viên nhóm

* Lưu Đức Hiệp - 23010437
* Hoàng Văn Dũng - 23010438
* Nguyễn Kim Khương - 23010428

---

## 📌 Nội dung buổi thực hành 01

### ✅ Nhiệm vụ đã thực hiện

* Tạo repository nhóm trên GitHub
* Thêm thành viên vào repository
* Tạo project Flutter framework
* Chỉnh sửa giao diện:
  * Đổi tên ứng dụng: **Ứng dụng Đồ Ăn**
  * Hiển thị thông tin thành viên nhóm
* Đưa code lên GitHub bằng Git

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

## ⚙️ Công nghệ sử dụng

* Flutter & Dart
* Quản lý trạng thái cơ bản (`StatefulWidget`, `setState`)
* Lập trình hướng đối tượng (OOP) & Collections (List, Array)
* Git & GitHub

---

## 🚀 Hướng dẫn chạy project

```bash
flutter pub get
flutter run