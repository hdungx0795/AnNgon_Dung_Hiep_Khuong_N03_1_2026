// ============================================================
// BÀI TẬP THỰC HÀNH SỐ 2
// Dự án: Ứng dụng Đặt Đồ Ăn - PKA Food
// Đối tượng: Món Ăn, Khách Hàng, Đơn Hàng (Món Ăn - Khách Hàng)
// ============================================================

import 'package:flutter/material.dart';

void main() {
  runApp(const BaiTapThucHanh2());
}

class BaiTapThucHanh2 extends StatelessWidget {
  const BaiTapThucHanh2({super.key});

  @override
  Widget build(BuildContext context) {

    // ============================================================
    // CÂU 1: Sử dụng các biến vào trong file main.dart
    // Khai báo biến mô tả cho 3 đối tượng
    // ============================================================

    // ─── Đối tượng 1: Món Ăn ───
    int idMon = 1;
    String tenMon = 'Hamburger Phô Mai';
    int gia = 45000;
    String danhMuc = 'Đồ ăn';
    double danhGia = 4.9;

    // ─── Đối tượng 2: Khách Hàng ───
    int idKH = 1;
    String tenKH = 'Nguyễn Văn Khách';
    String soDienThoai = '0987654321';
    String email = 'khach@phenikaa.edu.vn';
    String diaChi = 'Đại học Phenikaa, Hà Đông, Hà Nội';

    // ─── Đối tượng 3: Đơn Hàng (Món Ăn – Khách Hàng) ───
    int idDon = 1;
    int maKhachHang = 1;
    int maMon = 1;
    int soLuong = 2;
    int tongTien = 90000;
    String trangThai = 'Đang giao';
    String ngayDat = '15/04/2026';

    // ============================================================
    // CÂU 2: Sử dụng Collections (Array, List, Map)
    // ============================================================

    // ─── List<Map> danh sách Món Ăn ───
    var listMonAn = [
      {'idMon': 1, 'tenMon': 'Hamburger Phô Mai', 'gia': 45000, 'danhMuc': 'Đồ ăn', 'danhGia': 4.9},
      {'idMon': 2, 'tenMon': 'Mỳ Ý Sốt Bò Băm', 'gia': 55000, 'danhMuc': 'Đồ ăn', 'danhGia': 4.6},
      {'idMon': 3, 'tenMon': 'Matcha Latte', 'gia': 35000, 'danhMuc': 'Đồ uống', 'danhGia': 4.5},
      {'idMon': 4, 'tenMon': 'Combo 2 Pizza + Nước', 'gia': 150000, 'danhMuc': 'Combo', 'danhGia': 4.9},
      {'idMon': 5, 'tenMon': 'Trà Sữa Trân Châu', 'gia': 30000, 'danhMuc': 'Đồ uống', 'danhGia': 4.9},
    ];

    // ─── List<Map> danh sách Khách Hàng ───
    var listKhachHang = [
      {'idKH': 1, 'tenKH': 'Nguyễn Văn Khách', 'soDienThoai': '0987654321', 'diaChi': 'Đại học Phenikaa'},
      {'idKH': 2, 'tenKH': 'Trần Thị Mai', 'soDienThoai': '0912345678', 'diaChi': 'KTX Phenikaa'},
      {'idKH': 3, 'tenKH': 'Lê Hoàng Nam', 'soDienThoai': '0901234567', 'diaChi': 'Yên Nghĩa, Hà Đông'},
    ];

    // ─── List<Map> danh sách Đơn Hàng (Món Ăn – Khách Hàng) ───
    var listDonHang = [
      {'idDon': 1, 'tenKH': 'Nguyễn Văn Khách', 'monDat': '2x Hamburger Phô Mai', 'tongTien': 90000, 'trangThai': 'Đang giao', 'ngayDat': '15/04/2026'},
      {'idDon': 2, 'tenKH': 'Trần Thị Mai', 'monDat': '1x Matcha Latte, 1x Trà Sữa', 'tongTien': 65000, 'trangThai': 'Hoàn thành', 'ngayDat': '14/04/2026'},
      {'idDon': 3, 'tenKH': 'Lê Hoàng Nam', 'monDat': '1x Combo 2 Pizza + Nước', 'tongTien': 150000, 'trangThai': 'Đang chuẩn bị', 'ngayDat': '15/04/2026'},
    ];

    // ============================================================
    // CÂU 3: Hiển thị dữ liệu trong Widget (dạng Row)
    // ============================================================
    return MaterialApp(
      title: 'Bài Tập TH2 - PKA Food',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red, fontFamily: 'Roboto'),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'PKA Food - Bài Tập Thực Hành 2',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.red,
          centerTitle: true,
        ),
        backgroundColor: const Color(0xFFF5F5F5),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ══════════════════════════════════════════
              // PHẦN 1: Hiển thị khai báo biến (Câu 1)
              // ══════════════════════════════════════════
              _buildSectionTitle('📌 CÂU 1: Khai báo biến mô tả đối tượng'),
              const SizedBox(height: 10),

              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Món Ăn
                      _buildSubTitle('🍔 Đối tượng: Món Ăn'),
                      const SizedBox(height: 8),
                      _buildVariableRow('int', 'idMon', '$idMon'),
                      _buildVariableRow('String', 'tenMon', tenMon),
                      _buildVariableRow('int', 'gia', '$gia'),
                      _buildVariableRow('String', 'danhMuc', danhMuc),
                      _buildVariableRow('double', 'danhGia', '$danhGia'),

                      const Divider(height: 24),

                      // Khách Hàng
                      _buildSubTitle('👤 Đối tượng: Khách Hàng'),
                      const SizedBox(height: 8),
                      _buildVariableRow('int', 'idKH', '$idKH'),
                      _buildVariableRow('String', 'tenKH', tenKH),
                      _buildVariableRow('String', 'soDienThoai', soDienThoai),
                      _buildVariableRow('String', 'email', email),
                      _buildVariableRow('String', 'diaChi', diaChi),

                      const Divider(height: 24),

                      // Đơn Hàng
                      _buildSubTitle('📦 Đối tượng: Đơn Hàng (Món Ăn – Khách Hàng)'),
                      const SizedBox(height: 8),
                      _buildVariableRow('int', 'idDon', '$idDon'),
                      _buildVariableRow('int', 'maKhachHang', '$maKhachHang'),
                      _buildVariableRow('int', 'maMon', '$maMon'),
                      _buildVariableRow('int', 'soLuong', '$soLuong'),
                      _buildVariableRow('int', 'tongTien', '$tongTien'),
                      _buildVariableRow('String', 'trangThai', trangThai),
                      _buildVariableRow('String', 'ngayDat', ngayDat),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ══════════════════════════════════════════
              // PHẦN 2+3: Collections + Hiển thị (Câu 2 & 3)
              // ══════════════════════════════════════════
              _buildSectionTitle('📌 CÂU 2 & 3: Collections + Hiển thị dạng Row'),
              const SizedBox(height: 15),

              // ─── BẢNG 1: Danh sách Món Ăn ───
              _buildSubTitle('🍽️ listMonAn — Danh sách Món Ăn'),
              const SizedBox(height: 8),
              _buildTable(
                headerColor: Colors.red.shade50,
                headers: ['ID', 'Tên Món Ăn', 'Giá', 'Loại', '⭐'],
                headerWidths: [30.0, 0.0, 70.0, 55.0, 30.0], // 0 = Expanded
                rows: listMonAn.map((mon) => [
                  '${mon['idMon']}',
                  '${mon['tenMon']}',
                  '${mon['gia']}đ',
                  '${mon['danhMuc']}',
                  '${mon['danhGia']}',
                ]).toList(),
              ),

              const SizedBox(height: 20),

              // ─── BẢNG 2: Danh sách Khách Hàng ───
              _buildSubTitle('👥 listKhachHang — Danh sách Khách Hàng'),
              const SizedBox(height: 8),
              _buildTable(
                headerColor: Colors.blue.shade50,
                headers: ['ID', 'Họ Tên', 'SĐT', 'Địa chỉ'],
                headerWidths: [30.0, 0.0, 0.0, 0.0],
                rows: listKhachHang.map((kh) => [
                  '${kh['idKH']}',
                  '${kh['tenKH']}',
                  '${kh['soDienThoai']}',
                  '${kh['diaChi']}',
                ]).toList(),
              ),

              const SizedBox(height: 20),

              // ─── BẢNG 3: Danh sách Đơn Hàng ───
              _buildSubTitle('📋 listDonHang — Danh sách Đơn Hàng'),
              const SizedBox(height: 8),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            SizedBox(width: 25, child: Text('#', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                            Expanded(flex: 2, child: Text('Khách Hàng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                            Expanded(flex: 3, child: Text('Món Đặt', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                            SizedBox(width: 70, child: Text('Tổng Tiền', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                          ],
                        ),
                      ),
                      const Divider(),

                      // Data rows
                      ...listDonHang.map((don) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(width: 25, child: Text('${don['idDon']}', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))),
                                Expanded(flex: 2, child: Text('${don['tenKH']}', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13))),
                                Expanded(flex: 3, child: Text('${don['monDat']}', style: const TextStyle(fontSize: 12))),
                                SizedBox(
                                  width: 70,
                                  child: Text(
                                    '${don['tongTien']}đ',
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const SizedBox(width: 25),
                                Text('📅 ${don['ngayDat']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(don['trangThai'].toString()).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${don['trangThai']}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: _getStatusColor(don['trangThai'].toString()),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Footer
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '🎓 PKA Food — Bài Tập Thực Hành 2',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ứng dụng Đặt Đồ Ăn — Đại học Phenikaa',
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HELPER WIDGETS
  // ============================================================

  static Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
    );
  }

  static Widget _buildSubTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2C2F3E)),
    );
  }

  /// Hiển thị 1 dòng biến: kiểuDữLiệu tênBiến = giáTrị
  static Widget _buildVariableRow(String type, String name, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(type, style: TextStyle(fontSize: 11, color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
          Text('$name = ', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.red, fontSize: 13), overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  /// Widget bảng tái sử dụng
  static Widget _buildTable({
    required Color headerColor,
    required List<String> headers,
    required List<double> headerWidths, // 0.0 = Expanded
    required List<List<String>> rows,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: BoxDecoration(color: headerColor, borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: List.generate(headers.length, (i) {
                  Widget text = Text(headers[i], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    textAlign: headerWidths[i] > 0 ? TextAlign.center : TextAlign.start,
                  );
                  return headerWidths[i] > 0
                      ? SizedBox(width: headerWidths[i], child: text)
                      : Expanded(child: text);
                }),
              ),
            ),
            const Divider(),
            // Data rows
            ...rows.map((row) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: List.generate(row.length, (i) {
                  bool isPrice = row[i].endsWith('đ');
                  Widget text = Text(
                    row[i],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isPrice ? FontWeight.bold : (i == 1 ? FontWeight.w500 : FontWeight.normal),
                      color: isPrice ? Colors.red : const Color(0xFF2C2F3E),
                    ),
                    textAlign: headerWidths[i] > 0 ? TextAlign.center : TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                  );
                  return headerWidths[i] > 0
                      ? SizedBox(width: headerWidths[i], child: text)
                      : Expanded(child: text);
                }),
              ),
            )),
          ],
        ),
      ),
    );
  }

  static Color _getStatusColor(String status) {
    switch (status) {
      case 'Hoàn thành': return Colors.green;
      case 'Đang giao': return Colors.blue;
      case 'Đang chuẩn bị': return Colors.orange;
      default: return Colors.grey;
    }
  }
}
