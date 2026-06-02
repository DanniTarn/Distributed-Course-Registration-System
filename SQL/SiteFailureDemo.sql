-- =====================================================
-- SiteFailureDemo.sql
-- DEMO XỬ LÝ KHI SITE 3 MẤT KẾT NỐI VỚI SITE 1
-- =====================================================

-- =====================================================
-- BƯỚC 0: RESET DỮ LIỆU DEMO
-- =====================================================

USE site3_hcm;

DROP TABLE IF EXISTS TransactionLog;

CREATE TABLE TransactionLog (
    MaLog INT AUTO_INCREMENT PRIMARY KEY,
    LoaiGiaoDich VARCHAR(50),
    MaSV VARCHAR(20),
    MaLHP VARCHAR(20),
    ThoiGian DATETIME DEFAULT CURRENT_TIMESTAMP,
    TrangThaiDongBo VARCHAR(20),
    GhiChu VARCHAR(255)
);

USE site1_hanoi;

DROP TABLE IF EXISTS TransactionLog_TongHop;

CREATE TABLE TransactionLog_TongHop (
    MaLogTrungTam INT AUTO_INCREMENT PRIMARY KEY,
    SiteNguon VARCHAR(50),
    LoaiGiaoDich VARCHAR(50),
    MaSV VARCHAR(20),
    MaLHP VARCHAR(20),
    ThoiGian DATETIME,
    TrangThaiXuLy VARCHAR(20),
    GhiChu VARCHAR(255)
);

-- =====================================================
-- BƯỚC 1: KIỂM TRA DỮ LIỆU CỤC BỘ TẠI SITE 3
-- =====================================================

USE site3_hcm;

SELECT MaSV, HoTen, MaCoSo
FROM SinhVien
WHERE MaSV IN ('SV203', 'SV204', 'SV205');

SELECT MaLHP, MaHP, MaCoSo, SiSoToiDa, SoLuongDangKy
FROM LopHocPhan
WHERE MaLHP IN ('LHP202', 'LHP203', 'LHP204');

-- =====================================================
-- BƯỚC 2: GIẢ LẬP SITE 3 MẤT KẾT NỐI
-- SITE 3 VẪN XỬ LÝ GIAO DỊCH CỤC BỘ
-- =====================================================

START TRANSACTION;

-- SV203 đăng ký LHP202 tại Site 3
INSERT IGNORE INTO DangKy(MaSV, MaLHP, NgayDangKy)
VALUES ('SV203', 'LHP202', NOW());

-- Cập nhật lại số lượng đăng ký của LHP202 theo dữ liệu thực tế
UPDATE LopHocPhan l
SET SoLuongDangKy = (
    SELECT COUNT(*)
    FROM DangKy d
    WHERE d.MaLHP = l.MaLHP
)
WHERE l.MaLHP = 'LHP202';

-- Ghi log chưa đồng bộ
INSERT INTO TransactionLog(
    LoaiGiaoDich,
    MaSV,
    MaLHP,
    ThoiGian,
    TrangThaiDongBo,
    GhiChu
)
VALUES (
    'DangKy',
    'SV203',
    'LHP202',
    NOW(),
    'ChuaDongBo',
    'Site 3 xu ly cuc bo khi mat ket noi Site 1'
);

COMMIT;

-- =====================================================
-- BƯỚC 3: THÊM MỘT SỐ LOG CHƯA ĐỒNG BỘ ĐỂ MINH HỌA
-- =====================================================

INSERT INTO TransactionLog(
    LoaiGiaoDich,
    MaSV,
    MaLHP,
    ThoiGian,
    TrangThaiDongBo,
    GhiChu
)
VALUES
(
    'DangKy',
    'SV204',
    'LHP203',
    NOW(),
    'ChuaDongBo',
    'Giao dich dang ky phat sinh khi Site 1 mat ket noi'
),
(
    'HuyDangKy',
    'SV205',
    'LHP204',
    NOW(),
    'ChuaDongBo',
    'Giao dich huy dang ky phat sinh khi Site 1 mat ket noi'
);

-- =====================================================
-- BƯỚC 4: KIỂM TRA LOG CHƯA ĐỒNG BỘ TẠI SITE 3
-- =====================================================

SELECT
    MaLog,
    LoaiGiaoDich,
    MaSV,
    MaLHP,
    TrangThaiDongBo
FROM TransactionLog
WHERE TrangThaiDongBo = 'ChuaDongBo';

-- =====================================================
-- BƯỚC 5: GIẢ LẬP KẾT NỐI ĐƯỢC KHÔI PHỤC
-- SITE 1 NHẬN LOG TỪ SITE 3
-- =====================================================

USE site1_hanoi;

INSERT INTO TransactionLog_TongHop(
    SiteNguon,
    LoaiGiaoDich,
    MaSV,
    MaLHP,
    ThoiGian,
    TrangThaiXuLy,
    GhiChu
)
SELECT
    'Site3_HCM',
    LoaiGiaoDich,
    MaSV,
    MaLHP,
    ThoiGian,
    'ACCEPT',
    'Dong bo thanh cong tu Site 3 ve Site 1'
FROM site3_hcm.TransactionLog
WHERE TrangThaiDongBo = 'ChuaDongBo';

-- =====================================================
-- BƯỚC 6: CẬP NHẬT TRẠNG THÁI ĐÃ ĐỒNG BỘ TẠI SITE 3
-- =====================================================

USE site3_hcm;

UPDATE TransactionLog
SET TrangThaiDongBo = 'DaDongBo'
WHERE TrangThaiDongBo = 'ChuaDongBo';

-- =====================================================
-- BƯỚC 7: KIỂM TRA TRẠNG THÁI SAU ĐỒNG BỘ TẠI SITE 3
-- =====================================================

SELECT
    MaLog,
    LoaiGiaoDich,
    MaSV,
    MaLHP,
    TrangThaiDongBo
FROM TransactionLog;

-- =====================================================
-- BƯỚC 8: KIỂM TRA DỮ LIỆU ĐÃ ĐỒNG BỘ TẠI SITE 1
-- =====================================================

USE site1_hanoi;

SELECT
    MaLogTrungTam,
    SiteNguon,
    LoaiGiaoDich,
    MaSV,
    MaLHP,
    TrangThaiXuLy,
    GhiChu
FROM TransactionLog_TongHop
ORDER BY MaLogTrungTam;

-- =====================================================
-- BƯỚC 9: THỐNG KÊ SỐ GIAO DỊCH ĐƯỢC ĐỒNG BỘ
-- =====================================================

SELECT
    SiteNguon,
    COUNT(*) AS SoGiaoDichDongBo
FROM TransactionLog_TongHop
GROUP BY SiteNguon;

-- =====================================================
-- BƯỚC 10: MÔ PHỎNG XUNG ĐỘT KHI ĐỒNG BỘ
-- Ví dụ: Site 1 từ chối vì lớp đã đủ sĩ số
-- =====================================================

INSERT INTO TransactionLog_TongHop(
    SiteNguon,
    LoaiGiaoDich,
    MaSV,
    MaLHP,
    ThoiGian,
    TrangThaiXuLy,
    GhiChu
)
VALUES(
    'Site3_HCM',
    'DangKy',
    'SV206',
    'LHP202',
    NOW(),
    'REJECT',
    'Lop hoc phan da du si so khi dong bo'
);

-- =====================================================
-- BƯỚC 11: KIỂM TRA ACCEPT / REJECT TẠI SITE 1
-- =====================================================

SELECT
    MaLogTrungTam,
    SiteNguon,
    LoaiGiaoDich,
    MaSV,
    MaLHP,
    TrangThaiXuLy,
    GhiChu
FROM TransactionLog_TongHop
ORDER BY MaLogTrungTam DESC
LIMIT 10;

-- =====================================================
-- KẾT THÚC DEMO
-- =====================================================