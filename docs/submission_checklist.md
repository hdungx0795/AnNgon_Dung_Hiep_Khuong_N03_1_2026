# Submission Checklist (Tiêu chí 9, 10 & Layout mẫu)

## Danh sách Nộp bài (Tiêu chí 9)

Để đạt điểm tối đa ở Tiêu chí 9, nhóm cần đảm bảo nộp đủ các file/link sau lên hệ thống của trường:

- [ ] **Báo cáo PDF:** Trích xuất các file trong thư mục `docs/` thành một file Word/PDF hoàn chỉnh có trang bìa, mục lục.
- [ ] **Video Demo:** Quay video theo kịch bản `docs/demo_script.md` (độ dài 3-5 phút), upload lên YouTube hoặc Google Drive (nhớ mở quyền truy cập Public/Anyone with link). (Nhớ thực hiện thao tác Pull-to-refresh trong demo).
- [ ] **Source Code:** Nén thư mục project (sau khi chạy `flutter clean` để giảm dung lượng) HOẶC nộp link GitHub (nếu giảng viên cho phép).
- [ ] **File APK:** Build file APK bằng lệnh `flutter build apk --release` và đính kèm vào hồ sơ (đã có ở `build/app/outputs/flutter-apk/app-release.apk`).
- [ ] **Tài liệu README:** File `README.md` đã được update và nằm ở thư mục gốc.

## Lưu ý về Git Contribution (Tiêu chí 10)

Theo yêu cầu tiêu chí 10, lịch sử commit phải thể hiện sự đóng góp của **nhiều thành viên**.
**Hiện trạng repo Git:**
- Commits chủ yếu được thực hiện bởi `pachip` (hhkk77441@gmail.com).
- Có sự đóng góp của `hdungx0795`, `bachiep`, `NguyenKimKhuong` nhưng số lượng ít hơn (chủ yếu từ các tuần đầu).

**Giải pháp cho nhóm:**
1. Hãy đảm bảo các thành viên khác có pull code về máy, tự build thử.
2. Nếu cần, các thành viên khác có thể thực hiện một số commit nhỏ (ví dụ: comment code, sửa lỗi chính tả trong báo cáo) trước khi tạo file nén nộp bài, để lịch sử Git đa dạng hơn.

## Layout Mẫu (Tiêu chí 5)
- **Yêu cầu:** "Code đúng layout mẫu giảng viên cung cấp. Không liên quan đến project chính."
- **Tình trạng:** Trong repo chưa có thông tin rõ ràng về "Layout mẫu của giảng viên".
- **Hành động:** Nếu giảng viên có một bài tập Layout tĩnh riêng biệt, người dùng cần tự bổ sung folder code giao diện này vào project (có thể tách riêng thư mục `layout_mau/`) để chấm điểm, tránh bị mất điểm Tiêu chí 5. Nếu PKA Food là project chính, hãy xác nhận lại với giảng viên xem Tiêu chí 5 có áp dụng vào project chính hay không.
