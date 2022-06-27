create database Shopmanager;
use shopmanager;

create table KhachHang (
MAKH INT PRIMARY KEY auto_increment,
HOTEN VARCHAR (50),
DCHI VARCHAR (50),
SODT VARCHAR (15),
NGSINH DATETIME,
DOANHSO FLOAT,
NGDK DATETIME
);

CREATE TABLE NHANVIEN (
MANV INT PRIMARY KEY auto_increment,
HOTEN VARCHAR (50),
NGVL DATETIME,
SODT VARCHAR (15)
);

CREATE table SANPHAM (
MASP INT primary KEY auto_increment,
TENSP VARCHAR (50),
DVT VARCHAR (15),
NUOCSX VARCHAR (30),
GIA FLOAT
);

CREATE TABLE HOADON (
SOHD INT primary KEY auto_increment,
NGHD DATETIME,
MAKH INT,
MANV INT,
TRIGIA FLOAT,
foreign key (MAKH) references KHACHHANG(MAKH),
foreign key (MANV) references NHANVIEN(MANV)
);

CREATE TABLE CTHD (
SOHD int,
MASP INT,
SL INT,
foreign key (SOHD) references HOADON(SOHD),
foreign key (MASP) references SANPHAM(MASP),
primary key (SOHD,MASP)
);
-- câu 1
select count(distinct cthd.masp) as 'Số sản phẩm  khác nhau được bán ra năm 2006'
from hoadon join cthd  on hoadon.sohd = cthd.sohd 
where year(hoadon.NGHD) = 2006  ;
-- câu 2
select max(trigia) as 'max', min(trigia) as 'min'
from hoadon;  
-- câu 3

-- câu 4:
select sum(trigia) as 'tổng hóa đơn năm  2006'
from hoadon
where year(hoadon.nghd) = 2006 ;

-- câu 5:
select max(trigia) as 'hóa đơn lớn nhất năm 2006'
from hoadon
where year(nghd) = 2006; 

-- câu 6:
select KH.hoten, max(HD.trigia)
from khachhang KH join hoadon HD on KH.makh = hd.makh
where year(nghd) = 2006;

-- câu 7:
select *
from khachhang kh
order by kh.doanhso desc
limit 3;

-- câu 8:
select masp, tensp, gia
from sanpham
where gia >= (
select distinct gia from sanpham
order by gia desc
limit 2,1
);



-- câu 9:
select masp, tensp, gia
from sanpham
where nuocsx like 'Thái Lan' and gia >= (
select distinct gia from sanpham
order by gia desc
limit 2,1
);

-- câu 10:
select masp, tensp, gia
from sanpham
where nuocsx like 'trung quốc' and gia >= (
select distinct gia from sanpham
order by gia desc
limit 2,1
);

-- câu 11:
Select *, rank() over(order by doanhso DESC) as ranking from khachhang;

-- câu 12:
select count(masp) 'số sp do ttrung quốc sx' 
from sanpham
where nuocsx like 'trung quốc';

-- câu 13:
select nuocsx, count(masp) "số sp sx" 
from sanpham
group by nuocsx;

-- câu 14:
select nuocsx , min(gia) as 'gia sp min', max(gia) as 'gia sp max', avg(gia) as 'gia sp avg' 
from sanpham
group by nuocsx;

-- câu 15:
select nghd as 'Ngày', sum(trigia) as 'Doanh thu'
from hoadon
group by nghd
order by nghd;

-- câu 16:
select count(cthd.sl) ' Số lượng bán ra'
from cthd join hoadon on hoadon.sohd = cthd.sohd
where month(nghd) = 10 and year(nghd) = 2006;

-- câu 17:
select month(nghd) as 'tháng', sum(trigia) as 'doanh thu'
from hoadon
where year(nghd) = 2006
group by month(nghd)
order by month(nghd);

-- câu 18:
select hoadon.sohd , count(cthd.masp) as 'so sp'
from hoadon join cthd on cthd.sohd = hoadon.sohd
group by hoadon.sohd
having count(cthd.masp) = 3 ;

-- câu 19:
select hoadon.sohd , count(cthd.masp) as 'so sp'
from hoadon join cthd on cthd.sohd = hoadon.sohd join sanpham on sanpham.masp = cthd.masp
where sanpham.nuocsx = 'việt nam'
group by hoadon.sohd
having count(cthd.masp) = 3 ;

-- câu 20:
select khachhang.makh, khachhang.hoten,count(hoadon.sohd)
from khachhang join hoadon on hoadon.makh = khachhang.makh
group by khachhang.makh
having count(hoadon.sohd) = (
select count(sohd)
from hoadon
group by makh
order by count(sohd) desc
limit 1
);

-- câu 21:
select month(nghd) as 'tháng', sum(trigia) as 'doanh thu'
from hoadon
where year(nghd) = 2006
group by month(nghd)
having sum(trigia) = (
select sum(trigia)
from hoadon
where year(nghd) = 2006
group by month(nghd)
order by sum(trigia) desc
limit 1);

-- câu 22: 
select sanpham.masp, sanpham.tensp, count(cthd.sl) as 'số lượng bán ra'
from sanpham join cthd on cthd.masp = sanpham.masp join hoadon on hoadon.sohd = cthd.sohd 
where year(hoadon.nghd) = 2006
group by sanpham.masp
having count(cthd.sl) = (
select count(cthd.sl)
from cthd
group by masp
order by count(cthd.sl)
limit 1
);
                          