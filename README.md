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


### ✅ Công việc của Dũng: `HomeScreen` & Khung Base Layout

* File thực hiện: `lib/midterm/home_screen.dart` và `lib/midterm/base_layout.dart`
* Xây dựng khung giao diện điều hướng chính (Base Layout) và giao diện màn hình Trang chủ (Home).
* Áp dụng kỹ thuật thiết kế Responsive (thích ứng đa màn hình): Giới hạn chiều rộng tối đa bằng `ConstrainedBox`, giúp giao diện hiển thị gọn gàng, chuẩn UI/UX trên cả Mobile, Tablet và Web.
* Thiết kế các phần chính trên Trang Chủ gồm:
  * Header: Lời chào cá nhân hóa và Avatar người dùng.
  * Banner Quảng Cáo: Không gian hiển thị các chương trình khuyến mãi.
  * Khám Phá (Điều hướng nhanh): Các khối nút bấm lớn dẫn sang trang `Thực Đơn` và `Về Chúng Tôi` (đáp ứng đúng yêu cầu linh hoạt template của đề bài).
  * Danh sách Gợi ý: Khung chứa danh sách cuộn ngang dành cho `Món Ngon Nổi Bật`.
* Xử lý kiến trúc và logic:
  * Tích hợp `SingleChildScrollView` đảm bảo nội dung trang Home có thể cuộn linh hoạt không bị lỗi tràn viền (overflow).
  * Xây dựng thanh điều hướng dưới (Bottom Navigation Bar) để chuyển đổi giữa 3 màn hình (Home, Content, About).
  * Ứng dụng cấu trúc phân tách file (Component-based) giúp các thành viên trong nhóm có thể code song song, độc lập mà không bị xung đột (conflict) dữ liệu.

  
  #### Phần được phân công: `ContentScreen` (Trang Thực đơn / Khám phá)
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
  * Tích hợp hiệu ứng cuộn (`SingleChildScrollView`) mượt mà cho toàn bộ trang.

---

## 📌 Nội dung buổi thực hành 04

### ✅ Nhiệm vụ đã thực hiện (Tổng quát hóa & Chuyên biệt hóa OOP)

Trong buổi học hôm nay, nhóm đã tiến hành tối ưu hóa cấu trúc mã nguồn của ứng dụng **Ăn Ngon** bằng cách áp dụng tối đa các kỹ thuật lập trình hướng đối tượng (OOP) nâng cao, đặc biệt là **Generics (Tham số hóa kiểu dữ liệu)** và **Abstract Classes / Interface** để **Tổng quát hóa (Generalization)** các lớp, đồng thời giữ **Chuyên biệt hóa (Specialization)** đối với các nghiệp vụ/thực thể đặc thù.

#### 1. Kiến trúc hệ thống & Thiết kế Phân tích:
* **Tổng quát hóa (Generalization):**
  * Định nghĩa lớp trừu tượng cơ sở `BaseModel<ID>` đại diện cho mọi thực thể có định danh.
  * Xây dựng giao diện Generic `Repository<T, ID>` quy chuẩn các thao tác CRUD cơ bản (`getAll`, `getById`, `add`, `update`, `delete`).
  * Triển khai lớp cụ thể Generic `InMemoryRepository<T, ID>` để tái sử dụng toàn bộ logic lưu trữ dữ liệu tĩnh, tuân thủ nguyên lý **DRY (Don't Repeat Yourself)**.
* **Chuyên biệt hóa (Specialization):**
  * Đối với các thực thể phụ thuộc hoặc đối tượng giá trị không có vòng đời độc lập (`ChiTietDonHang` và `CartItem`), nhóm đã **chuyên biệt hóa** chúng mà không kế thừa `BaseModel`.
  * Các Repository chuyên biệt kế thừa từ `InMemoryRepository` để mở rộng các phương thức truy vấn nghiệp vụ đặc thù (ví dụ: tìm kiếm món ăn, lọc đơn hàng của người dùng, xác thực đăng nhập, tính đánh giá sao trung bình).
  * Áp dụng **Facade Pattern** cho `AppRepository` để bọc các Repository con, bảo toàn tính tương thích ngược cho giao diện UI cũ.

---

### 👥 Chi tiết phần việc & Trích lược Code của từng Sinh viên

#### 🛠️ 1. Hoàng Văn Dũng - 23010438: Thiết kế Core Infrastructure (Generic & Abstract Core)
* **Nhiệm vụ:**
  * Thiết kế lớp trừu tượng cơ sở `BaseModel` và interface `Repository`.
  * Triển khai bộ khung Generic CRUD `InMemoryRepository` để quản lý các thao tác dữ liệu dùng chung.
* **Trích lược code chính:**
  * Lớp Generic trừu tượng cơ sở `BaseModel<ID>`:
    ```dart
    abstract class BaseModel<ID> {
      ID get id;
      Map<String, dynamic> toJson();
    }
    ```
  * Lớp triển khai Generic CRUD `InMemoryRepository<T extends BaseModel<ID>, ID>`:
    ```dart
    class InMemoryRepository<T extends BaseModel<ID>, ID> implements Repository<T, ID> {
      final List<T> _items;
      InMemoryRepository([List<T>? initialItems]) : _items = List<T>.from(initialItems ?? []);
      
      @override
      List<T> getAll() => List<T>.unmodifiable(_items);
      
      @override
      T? getById(ID id) => _items.firstWhere((item) => item.id == id);
      
      @override
      void add(T item) => _items.add(item);
      
      @override
      void update(ID id, T item) {
        final index = _items.indexWhere((x) => x.id == id);
        if (index != -1) _items[index] = item;
      }
      
      @override
      void delete(ID id) => _items.removeWhere((item) => item.id == id);
    }
    ```

#### 🍔 2. Lưu Đức Hiệp - 23010437: Tổng quát & Chuyên biệt hóa nghiệp vụ Món ăn & Đánh giá
* **Nhiệm vụ:**
  * Kế thừa `BaseModel<int>` cho thực thể `MonAn` và `DanhGia`.
  * Chuyên biệt hóa thực thể phụ thuộc `ChiTietDonHang` (không có id độc lập).
  * Triển khai `MonAnRepository` và `DanhGiaRepository` chứa các truy vấn đặc thù của món ăn (tìm kiếm, lọc danh mục) và đánh giá (tính trung bình sao).
* **Trích lược code chính:**
  * Lớp `MonAn` tổng quát hóa kế thừa `BaseModel<int>`:
    ```dart
    class MonAn implements BaseModel<int> {
      final int id;
      final String name;
      // ... các thuộc tính khác
    }
    ```
  * Chuyên biệt hóa trong `MonAnRepository` với tìm kiếm & lọc:
    ```dart
    class MonAnRepository extends InMemoryRepository<MonAn, int> {
      MonAnRepository(super.initialItems);
      
      List<MonAn> getByCategory(String category) {
        return getAll().where((m) => m.category.toLowerCase() == category.toLowerCase()).toList();
      }
      
      List<MonAn> search(String query) {
        final q = query.toLowerCase();
        return getAll().where((m) => m.name.toLowerCase().contains(q) || m.description.toLowerCase().contains(q)).toList();
      }
    }
    ```
  * Chuyên biệt hóa thực thể phụ thuộc `ChiTietDonHang` (không kế thừa `BaseModel`):
    ```dart
    class ChiTietDonHang {
      final int orderId;
      final int productId;
      final int quantity;
      final double unitPrice;
      // ... giữ nguyên tính chuyên biệt hóa
    }
    ```

#### 👤 3. Nguyễn Kim Khương - 23010428: Tổng quát & Chuyên biệt hóa nghiệp vụ Người dùng & Đơn hàng
* **Nhiệm vụ:**
  * Kế thừa `BaseModel<String>` cho thực thể `NguoiDung` và `DonHang`.
  * Chuyên biệt hóa thực thể cục bộ `CartItem` cho giỏ hàng.
  * Triển khai `NguoiDungRepository` (hàm login/authenticate) và `DonHangRepository` (lọc đơn hàng theo user, đặt hàng từ giỏ hàng).
* **Trích lược code chính:**
  * Lớp `DonHang` kế thừa `BaseModel<String>` với getter id được override:
    ```dart
    class DonHang implements BaseModel<String> {
      final String orderId;
      @override
      String get id => orderId;
      // ... các thuộc tính khác
    }
    ```
  * Nghiệp vụ đơn hàng chuyên biệt trong `DonHangRepository`:
    ```dart
    class DonHangRepository extends InMemoryRepository<DonHang, String> {
      DonHangRepository(super.initialItems);
      
      List<DonHang> getByUserId(int userId) {
        final results = getAll().where((d) => d.userId == userId).toList();
        results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return results;
      }
    }
    ```
  * Xác thực người dùng chuyên biệt trong `NguoiDungRepository`:
    ```dart
    class NguoiDungRepository extends InMemoryRepository<NguoiDung, String> {
      NguoiDungRepository(super.initialItems);
      
      NguoiDung? authenticate(String email, String passwordHash) {
        try {
          return getAll().firstWhere((u) => u.email == email && u.passwordHash == passwordHash);
        } catch (_) { return null; }
      }
    }
    ```

---

### 🔗 Link Repository Nhóm GitHub
* Repo URL: [AnNgon_Dung_Hiep_Khuong_N03_1_2026](https://github.com/hdungx0795/AnNgon_Dung_Hiep_Khuong_N03_1_2026)

---

## ⚙️ Công nghệ sử dụng

* **Nền tảng:** Flutter & Dart
* **Kiến trúc & Kỹ thuật:** 
  * Quản lý trạng thái cơ bản (`StatefulWidget`, `setState`)
  * Lập trình hướng đối tượng nâng cao (OOP: Abstract Classes, Interface, Inheritance)
  * Lập trình Generic (Tham số hóa kiểu dữ liệu cho Model & Repository CRUD)
  * Áp dụng Design Pattern: Facade Pattern & Repository Pattern
  * Collections (List, Array, Maps, Spread Operator)
* **Quản lý phiên bản:** Git & GitHub

---

## 🚀 Hướng dẫn chạy project

Cloning dự án và cài đặt các thư viện cần thiết:

```bash
git clone <link-repo-github-cua-nhom>
cd an_ngon_app
flutter pub get
flutter run
