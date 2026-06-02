HƯỚNG DẪN CHẠY DEMO HỆ THỐNG

1. Chuẩn bị môi trường
Phần mềm sử dụng:
MySQL Server 8.0
MySQL Workbench 8.0
Windows 10/11

Hệ thống được mô phỏng bằng 3 database độc lập:
site1_hanoi
site2_danang
site3_hcm

Tương ứng với:
Site      Cơ sở
Site 1    Hà Nội
Site 2    Đà Nắng
Site 3    Hồ Chí Minh

2. Khởi tạo hệ thống

Bước 1: Tạo database
Mở MySQL Workbench và chạy:
CreateDatabase.sql
Kết quả:
site1_hanoi
site2_danang
site3_hcm
được tạo thành công.

Bước 2: Nạp dữ liệu mẫu
Chạy lần lượt:
Site1_HaNoi_Data.sql
Site2_DaNang_Data.sql
Site3_HCM_Data.sql

Kết quả:
Sinh viên
Giảng viên
Học phần
Lớp học phần
Đăng ký học phần
được nạp vào hệ thống.

Bước 3: Kiểm tra dữ liệu
Ví dụ:
SELECT * FROM site1_hanoi.SinhVien;
SELECT * FROM site2_danang.SinhVien;
SELECT * FROM site3_hcm.SinhVien;

3. Demo truy vấn phân tán
Chạy file:
Queries.sql
Hệ thống thực hiện:
Truy vấn 1: Thống kê số sinh viên đăng ký theo cơ sở.
Truy vấn 2: Tìm học phần có nhiều sinh viên đăng ký nhất toàn trường.
Truy vấn 3: Danh sách sinh viên đăng ký chéo cơ sở.
Truy vấn 4: Tỷ lệ lấp đầy lớp học phần.
Truy vấn 5: Thống kê số lớp mở theo cơ sở.

4. Demo xử lý đăng ký học phần đồng thời
Chạy file:
TransactionDemo.sql

Mô phỏng:
SV001 đăng ký LHP001
SV002 đăng ký LHP001
trong cùng thời điểm.

Kiểm tra:
SELECT *
FROM DangKy;
và
SELECT *
FROM LopHocPhan;

Kết quả:
Không vượt quá sĩ số.
Không phát sinh đăng ký trùng.
Dữ liệu nhất quán.

5. Demo hủy đăng ký học phần
Trong file:
TransactionDemo.sql
chạy phần:
HuyDangKy Transaction

Kiểm tra:
SELECT *
FROM DangKy;
và
SELECT *
FROM LopHocPhan;

Kết quả:
Bản ghi đăng ký bị xóa.
SoLuongDangKy giảm tương ứng.
Transaction đảm bảo tính nguyên tử.

6. Demo sao chép dữ liệu (Replication)
Chạy file:
ReplicationDemo.sql

Bước 1
Thêm học phần mới tại Site 1:
HP021 - Dien toan dam may

Bước 2
Đồng bộ dữ liệu:
Site1 → Site2
Site1 → Site3

Bước 3
Kiểm tra:
SELECT *
FROM site2_danang.HocPhan
WHERE MaHP='HP021';
SELECT *
FROM site3_hcm.HocPhan
WHERE MaHP='HP021';

Kết quả:
HP021 xuất hiện tại cả 3 site

7. Demo xử lý site mất kết nối
Chạy file:
SiteFailureDemo.sql

Giai đoạn 1
Site 3 bị mất kết nối với Site 1.
Site 3 vẫn xử lý:
SV203 đăng ký LHP202
SV204 đăng ký LHP203
SV205 hủy đăng ký LHP204

Kiểm tra:
SELECT *
FROM site3_hcm.TransactionLog;

Kết quả:
TrangThaiDongBo = ChuaDongBo

Giai đoạn 2
Khôi phục kết nối.
Site 1 nhận dữ liệu từ Site 3.

Kiểm tra:
SELECT *
FROM site1_hanoi.TransactionLog_TongHop;

Kết quả:
TrangThaiXuLy = ACCEPT

Giai đoạn 3
Site 3 cập nhật:
ChuaDongBo → DaDongBo

Kiểm tra:
SELECT *
FROM site3_hcm.TransactionLog;

Kết quả:
DaDongBo

Giai đoạn 4
Mô phỏng xung đột.

Kiểm tra:
SELECT *
FROM site1_hanoi.TransactionLog_TongHop
WHERE TrangThaiXuLy='REJECT';

Kết quả:
Lớp học phần đầy.
Giao dịch bị từ chối.
