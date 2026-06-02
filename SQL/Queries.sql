-- Queries.sql - 5 truy van phan tan mo phong tren 3 site MySQL

-- 1. Thong ke so sinh vien dang ky hoc phan theo tung co so
SELECT MaCoSo, TenCoSo, SUM(TongDangKy) AS TongDangKy
FROM (
    SELECT cs.MaCoSo, cs.TenCoSo, COUNT(dk.MaSV) AS TongDangKy
    FROM site1_hanoi.CoSo cs
    LEFT JOIN site1_hanoi.SinhVien sv ON cs.MaCoSo = sv.MaCoSo
    LEFT JOIN site1_hanoi.DangKy dk ON sv.MaSV = dk.MaSV
    WHERE cs.MaCoSo = 'CS01'
    GROUP BY cs.MaCoSo, cs.TenCoSo
    UNION ALL
    SELECT cs.MaCoSo, cs.TenCoSo, COUNT(dk.MaSV) AS TongDangKy
    FROM site2_danang.CoSo cs
    LEFT JOIN site2_danang.SinhVien sv ON cs.MaCoSo = sv.MaCoSo
    LEFT JOIN site2_danang.DangKy dk ON sv.MaSV = dk.MaSV
    WHERE cs.MaCoSo = 'CS02'
    GROUP BY cs.MaCoSo, cs.TenCoSo
    UNION ALL
    SELECT cs.MaCoSo, cs.TenCoSo, COUNT(dk.MaSV) AS TongDangKy
    FROM site3_hcm.CoSo cs
    LEFT JOIN site3_hcm.SinhVien sv ON cs.MaCoSo = sv.MaCoSo
    LEFT JOIN site3_hcm.DangKy dk ON sv.MaSV = dk.MaSV
    WHERE cs.MaCoSo = 'CS03'
    GROUP BY cs.MaCoSo, cs.TenCoSo
) AS T
GROUP BY MaCoSo, TenCoSo;

-- 2. Tim hoc phan co nhieu sinh vien dang ky nhat toan truong
SELECT MaHP, TenHP, SUM(TongDangKy) AS TongDangKy
FROM (
    SELECT hp.MaHP, hp.TenHP, COUNT(dk.MaSV) AS TongDangKy
    FROM site1_hanoi.HocPhan hp
    JOIN site1_hanoi.LopHocPhan lhp ON hp.MaHP = lhp.MaHP
    JOIN site1_hanoi.DangKy dk ON lhp.MaLHP = dk.MaLHP
    GROUP BY hp.MaHP, hp.TenHP
    UNION ALL
    SELECT hp.MaHP, hp.TenHP, COUNT(dk.MaSV) AS TongDangKy
    FROM site2_danang.HocPhan hp
    JOIN site2_danang.LopHocPhan lhp ON hp.MaHP = lhp.MaHP
    JOIN site2_danang.DangKy dk ON lhp.MaLHP = dk.MaLHP
    GROUP BY hp.MaHP, hp.TenHP
    UNION ALL
    SELECT hp.MaHP, hp.TenHP, COUNT(dk.MaSV) AS TongDangKy
    FROM site3_hcm.HocPhan hp
    JOIN site3_hcm.LopHocPhan lhp ON hp.MaHP = lhp.MaHP
    JOIN site3_hcm.DangKy dk ON lhp.MaLHP = dk.MaLHP
    GROUP BY hp.MaHP, hp.TenHP
) AS T
GROUP BY MaHP, TenHP
ORDER BY TongDangKy DESC
LIMIT 1;

-- 3. Thong ke so luong dang ky hoc phan tai co so TP HCM
SELECT hp.MaHP, hp.TenHP, lhp.MaLHP, COUNT(dk.MaSV) AS SoLuongDangKy
FROM site3_hcm.LopHocPhan lhp
JOIN site3_hcm.HocPhan hp ON hp.MaHP = lhp.MaHP
LEFT JOIN site3_hcm.DangKy dk ON dk.MaLHP = lhp.MaLHP
WHERE lhp.MaCoSo = 'CS03'
GROUP BY hp.MaHP, hp.TenHP, lhp.MaLHP;

-- 4. Ty le lap day cua cac lop hoc phan tren toan he thong
SELECT MaLHP, TenHP, MaCoSo, SiSoToiDa, SoLuongDangKy,
       ROUND(SoLuongDangKy * 100 / SiSoToiDa, 2) AS TyLeLapDay
FROM (
    SELECT lhp.MaLHP, hp.TenHP, lhp.MaCoSo, lhp.SiSoToiDa, lhp.SoLuongDangKy
    FROM site1_hanoi.LopHocPhan lhp JOIN site1_hanoi.HocPhan hp ON lhp.MaHP = hp.MaHP
    UNION ALL
    SELECT lhp.MaLHP, hp.TenHP, lhp.MaCoSo, lhp.SiSoToiDa, lhp.SoLuongDangKy
    FROM site2_danang.LopHocPhan lhp JOIN site2_danang.HocPhan hp ON lhp.MaHP = hp.MaHP
    UNION ALL
    SELECT lhp.MaLHP, hp.TenHP, lhp.MaCoSo, lhp.SiSoToiDa, lhp.SoLuongDangKy
    FROM site3_hcm.LopHocPhan lhp JOIN site3_hcm.HocPhan hp ON lhp.MaHP = hp.MaHP
) AS T
ORDER BY TyLeLapDay DESC;

-- 5. Thong ke so lop mo theo co so dao tao
SELECT MaCoSo, TenCoSo, SUM(SoLuongLopHocPhan) AS SoLuongLopHocPhan
FROM (
    SELECT cs.MaCoSo, cs.TenCoSo, COUNT(lhp.MaLHP) AS SoLuongLopHocPhan
    FROM site1_hanoi.CoSo cs
    LEFT JOIN site1_hanoi.LopHocPhan lhp ON cs.MaCoSo = lhp.MaCoSo
    WHERE cs.MaCoSo = 'CS01'
    GROUP BY cs.MaCoSo, cs.TenCoSo
    UNION ALL
    SELECT cs.MaCoSo, cs.TenCoSo, COUNT(lhp.MaLHP) AS SoLuongLopHocPhan
    FROM site2_danang.CoSo cs
    LEFT JOIN site2_danang.LopHocPhan lhp ON cs.MaCoSo = lhp.MaCoSo
    WHERE cs.MaCoSo = 'CS02'
    GROUP BY cs.MaCoSo, cs.TenCoSo
    UNION ALL
    SELECT cs.MaCoSo, cs.TenCoSo, COUNT(lhp.MaLHP) AS SoLuongLopHocPhan
    FROM site3_hcm.CoSo cs
    LEFT JOIN site3_hcm.LopHocPhan lhp ON cs.MaCoSo = lhp.MaCoSo
    WHERE cs.MaCoSo = 'CS03'
    GROUP BY cs.MaCoSo, cs.TenCoSo
) AS T
GROUP BY MaCoSo, TenCoSo;
