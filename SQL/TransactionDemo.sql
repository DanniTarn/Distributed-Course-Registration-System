-- TransactionDemo.sql - demo transaction dang ky hoc phan tren MySQL

USE site3_hcm;

-- Khoa dong lop hoc phan de tranh vuot si so
START TRANSACTION;

SELECT SiSoToiDa, SoLuongDangKy
FROM LopHocPhan
WHERE MaLHP = 'LHP201'
FOR UPDATE;

INSERT INTO DangKy(MaSV, MaLHP, NgayDangKy)
SELECT 'SV201', 'LHP201', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM DangKy WHERE MaSV = 'SV201' AND MaLHP = 'LHP201'
)
AND (
    SELECT SoLuongDangKy FROM LopHocPhan WHERE MaLHP = 'LHP201'
) < (
    SELECT SiSoToiDa FROM LopHocPhan WHERE MaLHP = 'LHP201'
);

UPDATE LopHocPhan
SET SoLuongDangKy = (
    SELECT COUNT(*)
    FROM DangKy
    WHERE DangKy.MaLHP = LopHocPhan.MaLHP
)
WHERE MaLHP = 'LHP201';

INSERT INTO NhatKyDangKy(MaSV, MaLHP, ThaoTac, KetQua, GhiChu)
VALUES ('SV201', 'LHP201', 'Dang ky', 'Thanh cong', 'Demo transaction co khoa dong');

COMMIT;

SELECT * FROM LopHocPhan WHERE MaLHP = 'LHP201';
SELECT * FROM DangKy WHERE MaLHP = 'LHP201';
SELECT * FROM NhatKyDangKy ORDER BY MaLog DESC;
