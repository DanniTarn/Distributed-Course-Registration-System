-- =====================================================
-- ReplicationDemo.sql
-- DEMO SAO CHÉP DỮ LIỆU (REPLICATION)
-- HỆ THỐNG ĐĂNG KÝ HỌC PHẦN NHIỀU CƠ SỞ
-- =====================================================

-- =====================================================
-- BƯỚC 1: KIỂM TRA DỮ LIỆU BAN ĐẦU
-- =====================================================

SELECT * FROM site1_hanoi.HocPhan;
SELECT * FROM site2_danang.HocPhan;
SELECT * FROM site3_hcm.HocPhan;

-- =====================================================
-- BƯỚC 2: THÊM HỌC PHẦN MỚI TẠI SITE 1 (PRIMARY)
-- =====================================================

USE site1_hanoi;

INSERT INTO HocPhan (
    MaHP,
    TenHP,
    SoTinChi
)
VALUES (
    'HP021',
    'Dien toan dam may',
    3
);

-- Kiểm tra học phần vừa thêm

SELECT *
FROM HocPhan
WHERE MaHP = 'HP021';

-- =====================================================
-- BƯỚC 3: ĐỒNG BỘ HỌC PHẦN TỪ SITE 1 → SITE 2
-- =====================================================

INSERT INTO site2_danang.HocPhan
SELECT *
FROM site1_hanoi.HocPhan
WHERE MaHP NOT IN (
    SELECT MaHP
    FROM site2_danang.HocPhan
);

-- =====================================================
-- BƯỚC 4: ĐỒNG BỘ HỌC PHẦN TỪ SITE 1 → SITE 3
-- =====================================================

INSERT INTO site3_hcm.HocPhan
SELECT *
FROM site1_hanoi.HocPhan
WHERE MaHP NOT IN (
    SELECT MaHP
    FROM site3_hcm.HocPhan
);

-- =====================================================
-- BƯỚC 5: KIỂM TRA KẾT QUẢ SAO CHÉP
-- =====================================================

SELECT *
FROM site1_hanoi.HocPhan
WHERE MaHP = 'HP021';

SELECT *
FROM site2_danang.HocPhan
WHERE MaHP = 'HP021';

SELECT *
FROM site3_hcm.HocPhan
WHERE MaHP = 'HP021';

-- =====================================================
-- BƯỚC 6: DEMO SAO CHÉP BẢNG COSO
-- =====================================================

INSERT INTO site2_danang.CoSo
SELECT *
FROM site1_hanoi.CoSo
WHERE MaCoSo NOT IN (
    SELECT MaCoSo
    FROM site2_danang.CoSo
);

INSERT INTO site3_hcm.CoSo
SELECT *
FROM site1_hanoi.CoSo
WHERE MaCoSo NOT IN (
    SELECT MaCoSo
    FROM site3_hcm.CoSo
);

-- =====================================================
-- BƯỚC 7: KIỂM TRA KẾT QUẢ SAO CHÉP COSO
-- =====================================================

SELECT * FROM site1_hanoi.CoSo;
SELECT * FROM site2_danang.CoSo;
SELECT * FROM site3_hcm.CoSo;

-- =====================================================
-- BƯỚC 8: THỐNG KÊ DỮ LIỆU SAU KHI SAO CHÉP
-- =====================================================

SELECT
'Site1_HaNoi' AS SiteName,
COUNT(*) AS SoHocPhan
FROM site1_hanoi.HocPhan

UNION ALL

SELECT
'Site2_DaNang',
COUNT(*)
FROM site2_danang.HocPhan

UNION ALL

SELECT
'Site3_HCM',
COUNT(*)
FROM site3_hcm.HocPhan;

-- =====================================================
-- BƯỚC 9: MÔ PHỎNG CẬP NHẬT DỮ LIỆU TẠI PRIMARY
-- =====================================================

UPDATE site1_hanoi.HocPhan
SET TenHP = 'Dien toan dam may va AI'
WHERE MaHP = 'HP021';

-- =====================================================
-- BƯỚC 10: ĐỒNG BỘ CẬP NHẬT SANG CÁC REPLICA
-- =====================================================

UPDATE site2_danang.HocPhan h2
JOIN site1_hanoi.HocPhan h1
ON h1.MaHP = h2.MaHP
SET h2.TenHP = h1.TenHP
WHERE h1.MaHP = 'HP021';

UPDATE site3_hcm.HocPhan h3
JOIN site1_hanoi.HocPhan h1
ON h1.MaHP = h3.MaHP
SET h3.TenHP = h1.TenHP
WHERE h1.MaHP = 'HP021';

-- =====================================================
-- BƯỚC 11: KIỂM TRA ĐỒNG BỘ SAU UPDATE
-- =====================================================

SELECT *
FROM site1_hanoi.HocPhan
WHERE MaHP = 'HP021';

SELECT *
FROM site2_danang.HocPhan
WHERE MaHP = 'HP021';

SELECT *
FROM site3_hcm.HocPhan
WHERE MaHP = 'HP021';

-- =====================================================
-- KẾT LUẬN
-- Site 1 giữ bản chính (Primary Copy)
-- Site 2 và Site 3 giữ bản sao (Replica)
-- Dữ liệu được đồng bộ từ Site 1 tới các Site còn lại
-- =====================================================