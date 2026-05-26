# Báo cáo Kiểm thử (Tiêu chí 8)

Dự án PKA Food được thiết kế với sự chú trọng cao về kiểm thử (Testing). Bộ test bao phủ các khía cạnh từ Unit, UI đến Workflow/Integration nhằm đảm bảo ứng dụng hoạt động ổn định và đáp ứng Tiêu chí 8.

## 1. Kết quả chung
- **Tổng số bài test:** 146/146 Pass.
- **Tình trạng phân tích tĩnh (Analyze):** Clean (Không có cảnh báo / lỗi).
- **Mức độ bao phủ (Coverage):** Bao phủ các nhóm chính bao gồm Models, Providers, Services, Màn hình chính (UI) và Workflows.

## 2. Các mức độ Test
### a. Unit Tests (Logic/Models/Providers/Services)
Kiểm thử các class thuần Dart, không phụ thuộc UI. Các test case bao phủ cả trường hợp thành công (success), thất bại (failure), trường hợp biên (edge cases) và dữ liệu dự phòng (fallback).
- `test/models/`: Kiểm thử parse JSON và tuần tự hóa của Model.
- `test/providers/`: Kiểm thử logic tính toán (tính tổng tiền, quản lý danh sách, thay đổi trạng thái). VD: `test/providers/cart_provider_test.dart`, `test/providers/order_provider_test.dart`.
- `test/services/`: Kiểm thử các dịch vụ kết nối. VD: `test/services/auth_service_registration_test.dart`, `test/services/product_service_test.dart`, `test/services/order_service_test.dart`.

### b. UI / Screen Tests (Widget Tests)
Kiểm thử các màn hình Flutter để đảm bảo nút bấm, text hiển thị đúng. Chú trọng kiểm tra đầy đủ các trạng thái loading, empty, error, và ngăn chặn crash ở mức widget.
- Sử dụng `pumpWidget` kết hợp với mock providers.
- Các file test nằm trong `test/screens/`:
  - `test/screens/auth_screens_test.dart`
  - `test/screens/explore_tab_test.dart`
  - `test/screens/checkout_screen_test.dart`
  - `test/screens/orders_b06a_test.dart`

### c. Workflow / Integration Tests
Kiểm thử các luồng chức năng hoàn chỉnh của người dùng và Admin, mô phỏng tương tác từ màn hình này sang màn hình khác.
Sử dụng `FakeFirebaseFirestore` và Hive Local Test.
- `test/workflows/tc8_workflows_test.dart`: Gồm 6 workflow chính, mỗi workflow là logic/workflow test tập trung vào 3-4 action (hành động) cốt lõi phục vụ Tiêu chí 8:
  1) **Auth workflow**: Đăng nhập, xác thực và lưu session.
  2) **Explore/catalog workflow**: Duyệt sản phẩm và tìm kiếm/lọc.
  3) **Checkout workflow**: Quá trình chọn thanh toán và tạo đơn.
  4) **Order tracking workflow**: Kiểm tra lịch sử đơn hàng và cập nhật.
  5) **Admin product sync workflow**: Quản lý, đồng bộ và ẩn/hiện sản phẩm.
  6) **Admin order sync workflow**: Đồng bộ, xem chi tiết và duyệt đơn hàng.

### d. QA Smoke Integration Test
File `test/qa_smoke_integration_test.dart` kiểm tra toàn bộ luồng khởi động app với `MultiProvider`, Firebase Mock, Hive Init để đảm bảo App Boot an toàn và không bị crash cho cả luồng User và Admin.

### e. Kiểm thử thủ công và Hiệu năng (Manual Demo & Performance)
- **APK Release Build:** Đã build thành công bản APK Release, giảm thiểu dung lượng và tối ưu hóa code.
- **Tính mượt mà:** Ứng dụng chạy mượt mà trên máy ảo (Emulator) và thiết bị thật (Physical device).
- **Hiệu năng:** 60fps được kiểm tra thủ công trong quá trình demo/runtime, không phải automated benchmark. Đảm bảo UI phản hồi tức thì với các thao tác chuyển màn hình và scroll danh sách.

## 3. Bảng Mapping Test -> Tiêu chí (TC8)

| Tiêu chí | File Test Cover |
|----------|-----------------|
| Đăng nhập / Đăng ký | `test/screens/auth_screens_test.dart`, `test/services/auth_service_registration_test.dart` |
| Navigation đúng | `test/workflows/tc8_workflows_test.dart` |
| Các thao tác CRUD | `test/services/product_service_test.dart`, `test/services/order_service_test.dart`, `test/providers/cart_provider_test.dart` |
| UI hiển thị đúng | `test/screens/explore_tab_test.dart`, `test/screens/checkout_screen_test.dart`, `test/screens/orders_b06a_test.dart` |
| App không crash | `test/qa_smoke_integration_test.dart` |

*Ghi chú: Để tự mình chạy và kiểm tra kết quả, chạy lệnh `flutter test` ở thư mục gốc của dự án.*
