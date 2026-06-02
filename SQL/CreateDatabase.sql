CREATE DATABASE DangKyHocPhan_PhanTan;
USE DangKyHocPhan_PhanTan;

USE dangkyhocphan_phantan;

CREATE TABLE CoSo (
    MaCoSo VARCHAR(10) PRIMARY KEY,
    TenCoSo VARCHAR(100) NOT NULL,
    DiaChi VARCHAR(200)
);

CREATE TABLE SinhVien (
    MaSV VARCHAR(20) PRIMARY KEY,
    HoTen VARCHAR(100) NOT NULL,
    NgaySinh DATE,
    Email VARCHAR(100),
    MaCoSo VARCHAR(10) NOT NULL,
    FOREIGN KEY (MaCoSo) REFERENCES CoSo(MaCoSo)
);

CREATE TABLE GiangVien (
    MaGV VARCHAR(20) PRIMARY KEY,
    HoTen VARCHAR(100) NOT NULL,
    HocVi VARCHAR(50),
    MaCoSo VARCHAR(10) NOT NULL,
    FOREIGN KEY (MaCoSo) REFERENCES CoSo(MaCoSo)
);

CREATE TABLE HocPhan (
    MaHP VARCHAR(20) PRIMARY KEY,
    TenHP VARCHAR(100) NOT NULL,
    SoTinChi INT NOT NULL
);

CREATE TABLE PhongHoc (
    MaPhong VARCHAR(20) PRIMARY KEY,
    TenPhong VARCHAR(100) NOT NULL,
    SucChua INT NOT NULL,
    MaCoSo VARCHAR(10) NOT NULL,
    FOREIGN KEY (MaCoSo) REFERENCES CoSo(MaCoSo)
);

CREATE TABLE LopHocPhan (
    MaLHP VARCHAR(20) PRIMARY KEY,
    MaHP VARCHAR(20) NOT NULL,
    MaGV VARCHAR(20) NOT NULL,
    MaPhong VARCHAR(20) NOT NULL,
    MaCoSo VARCHAR(10) NOT NULL,
    HocKy VARCHAR(10),
    NamHoc VARCHAR(20),
    SiSoToiDa INT NOT NULL,
    SoLuongDangKy INT DEFAULT 0,

    FOREIGN KEY (MaHP) REFERENCES HocPhan(MaHP),
    FOREIGN KEY (MaGV) REFERENCES GiangVien(MaGV),
    FOREIGN KEY (MaPhong) REFERENCES PhongHoc(MaPhong),
    FOREIGN KEY (MaCoSo) REFERENCES CoSo(MaCoSo)
);

CREATE TABLE DangKy (
    MaSV VARCHAR(20),
    MaLHP VARCHAR(20),
    NgayDangKy DATETIME DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (MaSV, MaLHP),

    FOREIGN KEY (MaSV) REFERENCES SinhVien(MaSV),
    FOREIGN KEY (MaLHP) REFERENCES LopHocPhan(MaLHP)
);

CREATE TABLE NhatKyDangKy (
    MaLog INT AUTO_INCREMENT PRIMARY KEY,
    MaSV VARCHAR(20),
    MaLHP VARCHAR(20),
    ThaoTac VARCHAR(50),
    ThoiGian DATETIME DEFAULT CURRENT_TIMESTAMP,
    KetQua VARCHAR(50),
    GhiChu VARCHAR(255)
);

CREATE DATABASE site1_hanoi;
CREATE DATABASE site2_danang;
CREATE DATABASE site3_hcm;

-- SITE 1: HÀ NỘI / TRUNG TÂM
-- =========================
USE site1_hanoi;

CREATE TABLE CoSo (
    MaCoSo VARCHAR(10) PRIMARY KEY,
    TenCoSo VARCHAR(100) NOT NULL,
    DiaChi VARCHAR(200)
);

CREATE TABLE HocPhan (
    MaHP VARCHAR(20) PRIMARY KEY,
    TenHP VARCHAR(100) NOT NULL,
    SoTinChi INT NOT NULL
);

CREATE TABLE SinhVien (
    MaSV VARCHAR(20) PRIMARY KEY,
    HoTen VARCHAR(100) NOT NULL,
    NgaySinh DATE,
    Email VARCHAR(100),
    MaCoSo VARCHAR(10) NOT NULL,
    FOREIGN KEY (MaCoSo) REFERENCES CoSo(MaCoSo)
);

CREATE TABLE GiangVien (
    MaGV VARCHAR(20) PRIMARY KEY,
    HoTen VARCHAR(100) NOT NULL,
    HocVi VARCHAR(50),
    MaCoSo VARCHAR(10) NOT NULL,
    FOREIGN KEY (MaCoSo) REFERENCES CoSo(MaCoSo)
);

CREATE TABLE PhongHoc (
    MaPhong VARCHAR(20) PRIMARY KEY,
    TenPhong VARCHAR(100) NOT NULL,
    SucChua INT NOT NULL,
    MaCoSo VARCHAR(10) NOT NULL,
    FOREIGN KEY (MaCoSo) REFERENCES CoSo(MaCoSo)
);

CREATE TABLE LopHocPhan (
    MaLHP VARCHAR(20) PRIMARY KEY,
    MaHP VARCHAR(20) NOT NULL,
    MaGV VARCHAR(20) NOT NULL,
    MaPhong VARCHAR(20) NOT NULL,
    MaCoSo VARCHAR(10) NOT NULL,
    HocKy VARCHAR(10),
    NamHoc VARCHAR(20),
    SiSoToiDa INT NOT NULL,
    SoLuongDangKy INT DEFAULT 0,
    FOREIGN KEY (MaHP) REFERENCES HocPhan(MaHP),
    FOREIGN KEY (MaGV) REFERENCES GiangVien(MaGV),
    FOREIGN KEY (MaPhong) REFERENCES PhongHoc(MaPhong),
    FOREIGN KEY (MaCoSo) REFERENCES CoSo(MaCoSo)
);

CREATE TABLE DangKy (
    MaSV VARCHAR(20),
    MaLHP VARCHAR(20),
    NgayDangKy DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (MaSV, MaLHP),
    FOREIGN KEY (MaSV) REFERENCES SinhVien(MaSV),
    FOREIGN KEY (MaLHP) REFERENCES LopHocPhan(MaLHP)
);

CREATE TABLE NhatKyDangKy (
    MaLog INT AUTO_INCREMENT PRIMARY KEY,
    MaSV VARCHAR(20),
    MaLHP VARCHAR(20),
    ThaoTac VARCHAR(50),
    ThoiGian DATETIME DEFAULT CURRENT_TIMESTAMP,
    KetQua VARCHAR(50),
    GhiChu VARCHAR(255)
);

-- =========================
-- SITE 2: ĐÀ NẴNG
-- =========================
USE site2_danang;

CREATE TABLE CoSo LIKE site1_hanoi.CoSo;
CREATE TABLE HocPhan LIKE site1_hanoi.HocPhan;
CREATE TABLE SinhVien LIKE site1_hanoi.SinhVien;
CREATE TABLE GiangVien LIKE site1_hanoi.GiangVien;
CREATE TABLE PhongHoc LIKE site1_hanoi.PhongHoc;
CREATE TABLE LopHocPhan LIKE site1_hanoi.LopHocPhan;
CREATE TABLE DangKy LIKE site1_hanoi.DangKy;
CREATE TABLE NhatKyDangKy LIKE site1_hanoi.NhatKyDangKy;

-- =========================
-- SITE 3: TP.HCM
-- =========================
USE site3_hcm;

CREATE TABLE CoSo LIKE site1_hanoi.CoSo;
CREATE TABLE HocPhan LIKE site1_hanoi.HocPhan;
CREATE TABLE SinhVien LIKE site1_hanoi.SinhVien;
CREATE TABLE GiangVien LIKE site1_hanoi.GiangVien;
CREATE TABLE PhongHoc LIKE site1_hanoi.PhongHoc;
CREATE TABLE LopHocPhan LIKE site1_hanoi.LopHocPhan;
CREATE TABLE DangKy LIKE site1_hanoi.DangKy;
CREATE TABLE NhatKyDangKy LIKE site1_hanoi.NhatKyDangKy;
USE site1_hanoi;
SHOW TABLES;

USE site2_danang;
SHOW TABLES;

USE site3_hcm;
SHOW TABLES;

USE site1_hanoi;
SELECT * FROM SinhVien LIMIT 5;

USE site2_danang;
SELECT * FROM SinhVien LIMIT 5;

USE site3_hcm;
SELECT * FROM SinhVien LIMIT 5;
SELECT COUNT(*) FROM DangKy;
USE site1_hanoi;
SELECT COUNT(*) AS TongDangKy FROM DangKy;

USE site2_danang;
SELECT COUNT(*) AS TongDangKy FROM DangKy;

USE site3_hcm;
SELECT COUNT(*) AS TongDangKy FROM DangKy;
USE site1_hanoi;
USE site1_hanoi;
UPDATE LopHocPhan l
SET SoLuongDangKy = (
    SELECT COUNT(*)
    FROM DangKy d
    WHERE d.MaLHP = l.MaLHP
);

USE site2_danang;
UPDATE LopHocPhan l
SET SoLuongDangKy = (
    SELECT COUNT(*)
    FROM DangKy d
    WHERE d.MaLHP = l.MaLHP
);

USE site3_hcm;
UPDATE LopHocPhan l
SET SoLuongDangKy = (
    SELECT COUNT(*)
    FROM DangKy d
    WHERE d.MaLHP = l.MaLHP
);
SHOW VARIABLES LIKE 'datadir';