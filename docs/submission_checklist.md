# Submission Checklist (Tiêu chí 9)

Để đạt điểm tối đa ở Tiêu chí 9, nhóm cần đảm bảo nộp đủ các file/link sau lên hệ thống của trường. Các thành viên sử dụng checklist này để kiểm tra lần cuối trước khi nộp:

## 1. Source Code (GitHub & File Nén)
- [ ] Code nằm ở branch `feature-hiep`.
- [ ] Đã đẩy (push) commit mới nhất lên GitHub sau khi cập nhật Docs và Test.
- [ ] Link GitHub dự án: `[Điền link GitHub tại đây]`
- [ ] (Nếu nộp file nén) Đã chạy `flutter clean`. KHÔNG đưa các file/thư mục nhạy cảm hoặc thừa vào file nén: `_excluded_from_git/`, `.idea/`, `android/app/google-services.json`.

## 2. File APK (Bản Build Release)
- [ ] Đã chạy lệnh `flutter build apk --release`.
- [ ] Lấy file APK để nộp tại đường dẫn: `build\app\outputs\flutter-apk\app-release.apk`.

## 3. Báo cáo PDF (Trích xuất từ thư mục docs/)
Báo cáo PDF cần tổng hợp đầy đủ các phần sau (đã có sẵn file Markdown trong `docs/`):
- [ ] **TC1:** User Stories (`user_stories.md`).
- [ ] **TC2:** Phân tích yêu cầu / Requirements analysis (`requirements_analysis.md`).
- [ ] **TC3:** Thiết kế hệ thống / System design gồm Class Diagram, Activity, Flowchart, Database Schema (`system_design.md`).
- [ ] **TC4:** Thiết kế UI (`ui_design.md`) đính kèm ảnh Figma/bản vẽ tay.
- [ ] **TC7:** Bằng chứng NoSQL. Ảnh chụp màn hình Firebase Console chứng minh có 4 collections: `users`, `products`, `orders`, `admin_products`.
- [ ] **TC8:** Báo cáo Testing (`testing_tc8.md`). Kèm theo screenshot terminal chạy `flutter test` và `flutter analyze` báo Pass/No issues.
- [ ] **TC10:** Lịch sử Git (Screenshot) thể hiện sự đóng góp của nhiều thành viên.

## 4. Video Demo (Bắt buộc)
Video demo độ dài 3-5 phút, bám sát kịch bản `docs/demo_script.md`:
- [ ] Link Video (YouTube/Drive mở quyền Public): `[Điền link Video tại đây]`
- [ ] Nội dung video bao gồm **User flow** (Login, Mua hàng, Checkout).
- [ ] Nội dung video bao gồm **Admin flow** (Login admin, Dashboard, Cập nhật trạng thái đơn).
- [ ] Có thao tác thể hiện **Firestore Sync** và **Pull-to-refresh**.
- [ ] (Tuỳ chọn) Trình diễn lướt qua kết quả Test hoặc quá trình build APK.

## 5. Thiết kế (Figma / Bản vẽ tay) & Layout Mẫu (TC4, TC5)
- [ ] **Thiết kế TC4:** Bản vẽ tay và Figma đã có ngoài repo. Cần đính kèm hình ảnh và Link Figma khi nộp bài. Link Figma: `[Điền link Figma tại đây]`
- [x] **Layout mẫu TC5:** Đã hoàn thiện thiết kế theo mẫu Grab Home Screen (2 hàng x 4 cột shortcuts, ví liên kết MoMo popup bật/tắt, banner trượt ngang mở món, và bong bóng chat hỗ trợ nổi cố định). Toàn bộ được tích hợp làm màn hình chính (ExploreTab) của Customer Flow với màu đỏ thương hiệu. Xem chi tiết phân tích tại [ui_design.md](file:///d:/Project1/ki%203%20nam%203/resources/LearnFlutter/AnNgon_Dung_Hiep_Khuong_N03_1_2026/docs/ui_design.md#5-thi%E1%BA%BFt-k%E1%BA%BF-giao-di%E1%BB%87n-m%E1%BA%ABu-theo-y%C3%AAu-c%E1%BA%A7u-c%E1%BB%A7a-gi%C3%A1o-vi%C3%AAn-ti%C3%AAu-ch%C3%AD-5).

## 6. Lịch sử Git & Contribution (Tiêu chí 10)
- [ ] Branch `feature-hiep` đã push commit mới nhất.
- [ ] Local và origin đồng bộ (trạng thái `0 0` khi diff).
- [ ] KHÔNG track (commit nhầm) các file nhạy cảm: `_excluded_from_git/`, `.idea/`, `android/app/google-services.json`.
- [ ] Commit history thể hiện rõ quá trình làm theo các Phase.
