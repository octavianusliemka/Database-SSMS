USE BlytzMegaplex
GO
--Satu kelompok yang berisi 6 orang ingin memesan tiket untuk nonton film di bioskop
--Satu orang dari mereka ditunjuk untuk datang ke bioskop dan memesankan tiket untuk kelompok mereka
--Ketika tiba di bioskop, ia disambut oleh Staff Jonathan Robert [IDStaff = SF008]
--Keterangan tiket apa saja yang dipesan adalah sebagai berikut:
--3 tiket untuk film The Lion King pada tanggal 29/12/2019 21:00:00 di Studio Blue [IDSchedule = MS001]
--2 tiket untuk film Frozen 2 pada tanggal 31/12/2019 17:30:00 di Studio Violet [IDSchedule = MS006]
--1 tiket untuk film Avengers: Infinity War pada tanggal 15/01/2020 di Studio Satintin [IDSchedule = MS009]

INSERT INTO trMovieSale (MovieSaleId, StaffId, TransactionDate) VALUES ('MTr031','SF008',GETDATE())
INSERT INTO trDetailMovieSale (MovieSaleId, ScheduleId, Seats) VALUES
('MTr031','MS001',3), ('MTr031','MS006',2), ('MTr031','MS009',1)

--Sekarang sudah tanggal 29/12/2019 20:45:00
--Film The Lion King di Studio Blue akan segera dimulai
--3 orang yang sudah memesan tiket untuk schedule film tersebut akan segera menonton.
--Akan tetapi, sebelum itu, mereka ingin memesan Refreshment untuk disantap selagi menyaksikan film
--Ketika ingin memesan, mereka disambut oleh Staff Rendy Pujipto [StaffID = SF002]
--Keteragan refreshment apa saja yang dipesan adalah sebagai berikut:
--2 Sweet Popcorn [RefreshmentID = RE021]
--1 Salted Popcorn [RefreshmentID = RE020]
--3 Sparkling Orange [RefreshmentID = RE006]
--2 Mineral Water [RefreshmentID = RE009]
--3 Chips [RefreshmentID = RE011]
--6 Grilled Sausage [RefreshmentID = RE013]

--*Asumsi : tidak ada stock yang kekurangan

INSERT INTO trRefreshmentSale (RefreshmentSaleId, StaffId, TransactionDate) VALUES ('RTr031','SF002',GETDATE())
INSERT INTO trDetailRefreshmentSale (RefreshmentSaleId, RefreshmentId, Quantity) VALUES
('RTr031','RE021',2),('RTr031','RE020',1),('RTr031','RE006',3),('RTr031','RE009',2),('RTr031','RE011',3),('RTr031','RE013',6)

UPDATE msRefreshment SET Stock = (SELECT Stock FROM msRefreshment WHERE RefreshmentId = 'RE021') - 2 WHERE RefreshmentId = 'RE021'
UPDATE msRefreshment SET Stock = (SELECT Stock FROM msRefreshment WHERE RefreshmentId = 'RE020') - 1 WHERE RefreshmentId = 'RE020'
UPDATE msRefreshment SET Stock = (SELECT Stock FROM msRefreshment WHERE RefreshmentId = 'RE006') - 3 WHERE RefreshmentId = 'RE006'
UPDATE msRefreshment SET Stock = (SELECT Stock FROM msRefreshment WHERE RefreshmentId = 'RE009') - 2 WHERE RefreshmentId = 'RE009'
UPDATE msRefreshment SET Stock = (SELECT Stock FROM msRefreshment WHERE RefreshmentId = 'RE011') - 3 WHERE RefreshmentId = 'RE011'
UPDATE msRefreshment SET Stock = (SELECT Stock FROM msRefreshment WHERE RefreshmentId = 'RE013') - 6 WHERE RefreshmentId = 'RE013'



