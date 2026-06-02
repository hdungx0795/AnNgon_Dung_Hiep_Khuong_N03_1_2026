# Kế Hoạch Chi Tiết: Tổng Quát Hóa & Chuyên Biệt Hóa Lớp (OOP & Generics)

Chào các bạn nhóm **Ăn Ngon**! Dưới đây là kế hoạch chi tiết để giải quyết bài toán hôm nay: **Tổng quát hóa tối đa cấu trúc hệ thống (Generic & Abstract Classes)** và **Chuyên biệt hóa các thực thể đặc thù (Specialized Classes/Repositories)**, đồng thời chuẩn bị tài liệu báo cáo trong file `README.md` theo phân công cụ thể của từng thành viên.

---

## 📌 Phân Tích Hiện Trạng & Ý Tưởng Thiết Kế

Hiện tại, ứng dụng có nhiều lớp dữ liệu (Models) và một repository lớn quản lý dữ liệu tĩnh (`AppRepository`). Để đáp ứng yêu cầu nâng cao về lập trình hướng đối tượng (OOP) và khả năng mở rộng:

1. **Tổng Quát Hóa (Generalization):**
   * Định nghĩa lớp trừu tượng cơ sở `BaseModel<ID>` bằng lập trình Generic để mọi thực thể có mã định danh (ID) kế thừa.
   * Xây dựng giao diện Generic Repository `Repository<T, ID>` định nghĩa các phương thức CRUD (`getAll`, `getById`, `add`, `update`, `delete`).
   * Viết lớp triển khai Generic `InMemoryRepository<T, ID>` để tái sử dụng toàn bộ logic CRUD cơ bản cho mọi loại thực thể mà không cần viết lại mã nguồn.

2. **Chuyên Biệt Hóa (Specialization):**
   * Đối với các lớp không thể tổng quát hóa hoặc có nghiệp vụ phụ thuộc:
     * `ChiTietDonHang` và `CartItem`: Là các đối tượng giá trị (Value Objects) hoặc thực thể phụ thuộc (Dependent Entities). Chúng không có mã định danh độc lập đại diện cho vòng đời độc lập nên không kế thừa `BaseModel`. Chúng sẽ được giữ chuyên biệt.
     * Các Repository con như `MonAnRepository`, `NguoiDungRepository`, `DonHangRepository`, `DanhGiaRepository` sẽ kế thừa từ `InMemoryRepository` và bổ sung các hàm nghiệp vụ **chuyên biệt hóa** (ví dụ: tìm kiếm món ăn theo danh mục, lọc đơn hàng theo user ID, chứng thực người dùng, v.v.).
   * Áp dụng **Facade Pattern** cho `AppRepository` để gom các Repository chuyên biệt này lại, giúp giữ nguyên tính tương thích của các trang giao diện (UI) hiện tại mà không làm gãy ứng dụng (không sinh lỗi biên dịch).

---

## 👥 Phân Chia Nhiệm Vụ Thành Viên

Để báo cáo khớp với yêu cầu của từng sinh viên trong nhóm, chúng ta phân chia công việc như sau:

### 1. 🛠️ Hoàng Văn Dũng - 23010438: Thiết Kế Core Infrastructure (Generic & Abstract Core)
* **Nhiệm vụ:**
  * Thiết kế và xây dựng lớp cơ sở `BaseModel<ID>` (`lib/models/base_model.dart`).
  * Thiết kế giao diện generic `Repository<T, ID>` và lớp triển khai `InMemoryRepository<T, ID>` (`lib/repositories/base_repository.dart` và `lib/repositories/in_memory_repository.dart`).
  * Điều phối tích hợp hệ thống trong `AppRepository` và cấu hình Provider trong `main.dart`.
* **Trích lược code chính:** Lớp Generic trừu tượng và CRUD tổng quát.

### 2. 🍔 Lưu Đức Hiệp - 23010437: Tổng Quát & Chuyên Biệt Hóa Nghiệp Vụ Món Ăn & Đánh Giá
* **Nhiệm vụ:**
  * Chuyển đổi mô hình `MonAn` và `DanhGia` kế thừa từ `BaseModel<int>`.
  * Thiết kế thực thể chuyên biệt `ChiTietDonHang` (không kế thừa `BaseModel` vì là thực thể phụ thuộc có composite keys tự nhiên).
  * Xây dựng `MonAnRepository` và `DanhGiaRepository` kế thừa `InMemoryRepository` và bổ sung các phương thức chuyên biệt như lọc món ăn, lấy đánh giá sản phẩm.
* **Trích lược code chính:** Cách chuyên biệt hóa `ChiTietDonHang` và thiết lập quan hệ kế thừa model.

### 3. 👤 Nguyễn Kim Khương - 23010428: Tổng Quát & Chuyên Biệt Hóa Nghiệp Vụ Người Dùng & Đơn Hàng
* **Nhiệm vụ:**
  * Chuyển đổi mô hình `NguoiDung` và `DonHang` kế thừa từ `BaseModel<String>`.
  * Giữ chuyên biệt hóa đối với `CartItem` (đối tượng lưu trữ giỏ hàng tạm thời, không lưu DB độc lập).
  * Xây dựng `NguoiDungRepository` và `DonHangRepository` kế thừa `InMemoryRepository` và bổ sung các nghiệp vụ đặc thù (tìm kiếm đơn hàng theo user, tạo đơn hàng mới từ giỏ hàng).
* **Trích lược code chính:** Thiết lập `NguoiDung` và `DonHang` cùng các phương thức xử lý đơn hàng chuyên biệt.

---

## 📂 Danh Sách Các File Sẽ Thay Đổi & Tạo Mới

### 1. Lớp Cơ Bản & Cơ Chế Generic (Core Infrastructure)
* #### [NEW] [base_model.dart](file:///e:/2026%20Year/K%C3%AC%203%20N%C4%83m%203/L%E1%BA%ADp%20tr%C3%ACnh%20cho%20thi%E1%BA%BFt%20b%E1%BB%8B%20di%20%C4%91%E1%BB%99ng/ltrttdd_Project/an_ngon_app/lib/models/base_model.dart)
  * Khai báo lớp trừu tượng `BaseModel<ID>` với getter `ID get id` và phương thức `Map<String, dynamic> toJson()`.
* #### [NEW] [base_repository.dart](file:///e:/2026%20Year/K%C3%AC%203%20N%C4%83m%203/L%E1%BA%ADp%20tr%C3%ACnh%20cho%20thi%E1%BA%BFt%20b%E1%BB%8B%20di%20%C4%91%E1%BB%99ng/ltrttdd_Project/an_ngon_app/lib/repositories/base_repository.dart)
  * Định nghĩa giao diện `Repository<T, ID>` với các hàm CRUD cơ bản.
* #### [NEW] [in_memory_repository.dart](file:///e:/2026%20Year/K%C3%AC%203%20N%C4%83m%203/L%E1%BA%ADp%20tr%C3%ACnh%20cho%20thi%E1%BA%BFt%20b%E1%BB%8B%20di%20%C4%91%E1%BB%99ng/ltrttdd_Project/an_ngon_app/lib/repositories/in_memory_repository.dart)
  * Cung cấp bộ khung lưu trữ dữ liệu tĩnh kiểu Generics `InMemoryRepository<T extends BaseModel<ID>, ID>` triển khai các hàm CRUD.

### 2. Mô Hình Dữ Liệu & Repositories Chuyên Biệt (Models & Specialized Repositories)
* #### [MODIFY] [mon_an.dart](file:///e:/2026%20Year/K%C3%AC%203%20N%C4%83m%203/L%E1%BA%ADp%20tr%C3%ACnh%20cho%20thi%E1%BA%BFt%20b%E1%BB%8B%20di%20%C4%91%E1%BB%99ng/ltrttdd_Project/an_ngon_app/lib/models/mon_an.dart)
  * Thừa kế `BaseModel<int>`.
* #### [MODIFY] [nguoi_dung.dart](file:///e:/2026%20Year/K%C3%AC%203%20N%C4%83m%203/L%E1%BA%ADp%20tr%C3%ACnh%20cho%20thi%E1%BA%BFt%20b%E1%BB%8B%20di%20%C4%91%E1%BB%99ng/ltrttdd_Project/an_ngon_app/lib/models/nguoi_dung.dart)
  * Thừa kế `BaseModel<String>`.
* #### [MODIFY] [don_hang.dart](file:///e:/2026%20Year/K%C3%AC%203%20N%C4%83m%203/L%E1%BA%ADp%20tr%C3%ACnh%20cho%20thi%E1%BA%BFt%20b%E1%BB%8B%20di%20%C4%91%E1%BB%99ng/ltrttdd_Project/an_ngon_app/lib/models/don_hang.dart)
  * Thừa kế `BaseModel<String>`, override getter `String get id => orderId;`.
* #### [MODIFY] [danh_gia.dart](file:///e:/2026%20Year/K%C3%AC%203%20N%C4%83m%203/L%E1%BA%ADp%20tr%C3%ACnh%20cho%20thi%E1%BA%BFt%20b%E1%BB%8B%20di%20%C4%91%E1%BB%99ng/ltrttdd_Project/an_ngon_app/lib/models/danh_gia.dart)
  * Thừa kế `BaseModel<int>`.
* #### [NEW] Các repository nghiệp vụ cụ thể:
  * `lib/repositories/mon_an_repository.dart`
  * `lib/repositories/nguoi_dung_repository.dart`
  * `lib/repositories/don_hang_repository.dart`
  * `lib/repositories/danh_gia_repository.dart`

### 3. Đồng Bộ Hệ Thống & Tương Thích Ngược
* #### [MODIFY] [app_repository.dart](file:///e:/2026%20Year/K%C3%AC%203%20N%C4%83m%203/L%E1%BA%ADp%20tr%C3%ACnh%20cho%20thi%E1%BA%BFt%20b%E1%BB%8B%20di%20%C4%91%E1%BB%99ng/ltrttdd_Project/an_ngon_app/lib/repositories/app_repository.dart)
  * Refactor cấu trúc bên trong sử dụng các repository con (Facade Pattern). Đảm bảo giữ nguyên các phương thức để UI không bị ảnh hưởng.

### 4. Báo Cáo Kết Quả Nộp Bài
* #### [MODIFY] [README.md](file:///e:/2026%20Year/K%C3%AC%203%20N%C4%83m%203/L%E1%BA%ADp%20tr%C3%ACnh%20cho%20thi%E1%BA%BFt%20b%E1%BB%8B%20di%20%C4%91%E1%BB%99ng/ltrttdd_Project/an_ngon_app/README.md)
  * Cập nhật chi tiết nội dung phân tích tổng quát hóa & chuyên biệt hóa, phân công công việc cụ thể cho từng sinh viên kèm theo trích lược các đoạn mã nguồn then chốt.

---

## 📈 Kế Hoạch Kiểm Thử & Xác Nhận (Verification Plan)

### 1. Đảm Bảo Biên Dịch Không Lỗi
* Chạy lệnh `flutter pub get` để kiểm tra các phụ thuộc.
* Chạy `flutter analyze` hoặc chạy trực tiếp ứng dụng để đảm bảo cấu trúc mới tương thích hoàn hảo với UI cũ, không gây crash hoặc đỏ màn hình.

### 2. Kiểm Tra Chức Năng CRUD & Nghiệp Vụ
* Thêm món ăn mới hoặc tạo đơn hàng từ giỏ hàng, xác nhận thông qua màn hình "Đơn hàng của tôi" xem dữ liệu mới đã được thêm thành công vào `DonHangRepository` và hiển thị mượt mà.

---

## 💬 Yêu Cầu Phản Hồi Từ Người Dùng (User Approval)

> [!IMPORTANT]
> Bạn có đồng ý với **Phân chia nhiệm vụ** này cho 3 thành viên trong nhóm không? 
> Nếu đã sẵn sàng, hãy chấp thuận kế hoạch này để tôi bắt đầu triển khai các file code hạ tầng và cập nhật chi tiết file báo cáo `README.md` cho nhóm!
