USE BlytzMegaplex
--1
SELECT
	MovieId,
	[Total Revenue] = 'IDR ' + CAST((SUM(mss.Price * trd.Seats)) AS VARCHAR)
FROM
	trMovieSale trm JOIN
	trDetailMovieSale trd
	ON trm.MovieSaleId = trd.MovieSaleId
	JOIN trSchedule trs 
	ON trs.ScheduleId = trd.ScheduleId 
	JOIN msStudio mss
	ON mss.StudioId = trs.StudioId
WHERE
	mss.Price > 50000 AND (DATEPART(DAY,trm.TransactionDate) < 20)
GROUP BY
	MovieId

--2
SELECT
	mst.Name,
	[Total Sold Seats] = SUM(trd.Seats)
FROM
	msStaff mst 
	JOIN trMovieSale trm
	ON mst.StaffId = trm.StaffId
	JOIN trDetailMovieSale trd
	ON trm.MovieSaleId = trd.MovieSaleId
WHERE
	mst.Gender IN ('Male') AND (DATEPART(DAY,trm.TransactionDate) < 28)
GROUP BY
	mst.Name
ORDER BY
	SUM(trd.Seats) DESC

--3
SELECT
	[Average Refreshment Revenue per Day] = 'IDR ' + CAST(AVG(trd.Quantity * msr.Price)AS VARCHAR),
	[Transaction Days] = CAST(COUNT(DISTINCT trr.TransactionDate)AS VARCHAR) + ' days',
	[Female Staff Count] = CAST(COUNT(DISTINCT mss.StaffId)AS VARCHAR) + ' people'
FROM
	msRefreshment msr JOIN
	trDetailRefreshmentSale trd
	ON msr.RefreshmentId = trd.RefreshmentId
	JOIN trRefreshmentSale trr
	ON trr.RefreshmentSaleId = trd.RefreshmentSaleId
	JOIN msStaff mss
	ON mss.StaffId = trr.StaffId
WHERE
	mss.Gender = 'Female' AND
	trr.TransactionDate < CONVERT(DATETIME, '2020-02-10')

--4
(SELECT [Staff First Name] = 'Mr. ' + LEFT(S.Name,CHARINDEX(' ', s.Name)),
		[Total of Refreshment] = COUNT(tdr.RefreshmentId),
		[Total of Quantity Sold] = SUM(tdr.Quantity)
FROM MsStaff s JOIN trRefreshmentSale trs ON s.StaffId = trs.StaffId
				JOIN trDetailRefreshmentSale tdr ON trs.RefreshmentSaleId = tdr.RefreshmentSaleId
				JOIN msRefreshment r ON tdr.RefreshmentId = r.RefreshmentId
WHERE s.Gender = 'Male'
GROUP BY s.Name)

UNION

(SELECT [Staff First Name] = 'Ms. ' + LEFT(S.Name,CHARINDEX(' ', s.Name)),
		[Total of Refreshment] = COUNT(tdr.RefreshmentId),
		[Total of Quantity Sold] = SUM(tdr.Quantity)
FROM MsStaff s JOIN trRefreshmentSale trs ON s.StaffId = trs.StaffId
				JOIN trDetailRefreshmentSale tdr ON trs.RefreshmentSaleId = tdr.RefreshmentSaleId
				JOIN msRefreshment r ON tdr.RefreshmentId = r.RefreshmentId
WHERE s.Gender = 'Female'
GROUP BY s.Name)

--5
SELECT 
	[Refreshment Transaction ID] = RIGHT(trs.RefreshmentSaleId,3), [Refreshment Transaction Date] = 
	CONVERT(VARCHAR, TransactionDate, 107)
		
FROM trRefreshmentSale trs JOIN trDetailRefreshmentSale tdr ON trs.RefreshmentSaleId = tdr.RefreshmentSaleId
						   JOIN	msRefreshment r ON tdr.RefreshmentId = r.RefreshmentId
						   JOIN msRefreshmentType rt ON r.RefreshmentTypeId = rt.RefreshmentTypeId,
	(  SELECT 
		[id] = trs.RefreshmentSaleId,
		[avg] = SUM(Quantity * Price)
	FROM trRefreshmentSale trs JOIN trDetailRefreshmentSale tdr ON trs.RefreshmentSaleId = tdr.RefreshmentSaleId
						   JOIN	msRefreshment r ON tdr.RefreshmentId = r.RefreshmentId,
	(SELECT 
		[Avga] = AVG(Quantity * Price)
	FROM trRefreshmentSale trs JOIN trDetailRefreshmentSale tdr ON trs.RefreshmentSaleId = tdr.RefreshmentSaleId
						   JOIN	msRefreshment r ON tdr.RefreshmentId = r.RefreshmentId	
	WHERE r.RefreshmentTypeId IN ('RT006', 'RT007', 'RT008', 'RT009', 'RT010')
	)   AS avgcek

	WHERE r.RefreshmentTypeId IN ('RT006', 'RT007', 'RT008', 'RT009', 'RT010')
	GROUP BY trs.RefreshmentSaleId, avgcek.Avga
	HAVING SUM(quantity * price) > avgcek.Avga) AS cekk
WHERE trs.RefreshmentSaleId = cekk.id

--6
SELECT
	[Transaction Date] = FORMAT(trm.TransactionDate, 'dddd') + ', ' + CONVERT(VARCHAR, trm.TransactionDate, 106),
	[Total Movie Revenue] = SUM(trd.Seats * mss.Price)
FROM
	trMovieSale trm JOIN trDetailMovieSale trd ON trm.MovieSaleId = trd.MovieSaleId
	JOIN trSchedule trs ON trd.ScheduleId = trs.ScheduleId
	JOIN msStudio mss ON mss.StudioId = trs.StudioId,
	(
		SELECT [TotalMovieRevenue] = SUM(trd.Seats * mss.Price)
		FROM trDetailMovieSale trd JOIN trSchedule trs ON trd.ScheduleId = trs.ScheduleId
		JOIN msStudio mss ON mss.StudioId = trs.StudioId
		JOIN trMovieSale trm ON trm.MovieSaleId = trd.MovieSaleId
		WHERE trm.TransactionDate < (CONVERT(DATETIME, '2020-02-28') - 30)
		GROUP BY trm.TransactionDate
	) AS TotalTable,
	(
		SELECT [AvgMovieRevenue] = AVG(trd.Seats * mss.Price)
		FROM trDetailMovieSale trd JOIN trSchedule trs ON trd.ScheduleId = trs.ScheduleId
		JOIN msStudio mss ON mss.StudioId = trs.StudioId
	) AS AverageTable
WHERE
	trm.TransactionDate < (CONVERT(DATETIME, '2020-02-28') - 30) AND TotalTable.TotalMovieRevenue > AverageTable.AvgMovieRevenue
GROUP BY trm.TransactionDate

--7
SELECT
	[Staff Last Name] = REVERSE(SUBSTRING(REVERSE(mss.Name), 1, CHARINDEX(' ', REVERSE(mss.Name)) - 1)),
	[Refreshment Transaction ID] = trr.RefreshmentSaleId,
	[Refreshment Name] = msr.Name,
	[Price] = 'IDR ' + CAST(msr.Price AS VARCHAR)
FROM
	msStaff mss JOIN trRefreshmentSale trr ON mss.StaffId = trr.StaffId
	JOIN trDetailRefreshmentSale trd ON trd.RefreshmentSaleId = trr.RefreshmentSaleId
	JOIN msRefreshment msr ON msr.RefreshmentId = trd.RefreshmentId,
	(
		SELECT [MinPrice] = MIN(msr.Price)
		FROM msRefreshment msr
		WHERE msr.Stock > 0
	) AS MinTable,
	(
		SELECT [MaxPrice] = MAX(msr.Price)
		FROM msRefreshment msr
		WHERE msr.Stock > 0
	) AS MaxTable
WHERE
	msr.Price > MinTable.MinPrice AND msr.Price < MaxTable.MaxPrice

--8
SELECT
	[Movie Transaction ID] = SUBSTRING(trm.MovieSaleId, 2, 2) + ' ' + RIGHT(trm.MovieSaleId, 3),
	[Studio Name] = mss.Name,
	[Studio Price] = 'IDR ' + CAST(mss.Price AS VARCHAR)
FROM
	trMovieSale trm JOIN trDetailMovieSale trd ON trm.MovieSaleId = trd.MovieSaleId
	JOIN trSchedule trs ON trd.ScheduleId = trs.ScheduleId
	JOIN msStudio mss ON mss.StudioId = trs.StudioId,
	(
		SELECT
			[MaxSeat] = MAX(trd.Seats)
		FROM
			trDetailMovieSale trd
	) AS MaxSeatTable,
	(
		SELECT
			[AvgSeat] = AVG(trd.Seats)
		FROM
			trDetailMovieSale trd
	) AS AvgSeatTable,
	(
		SELECT
			[MaxStud] = MAX(mss.Price)
		FROM
			msStudio mss
	) AS MaxStudTable,
	(
		SELECT
			[AvgStud] = AVG(mss.Price)
		FROM
			msStudio mss
	) AS AvgStudTable
WHERE
	trd.Seats > AvgSeatTable.AvgSeat AND trd.Seats < MaxSeatTable.MaxSeat
	AND mss.Price > AvgStudTable.AvgStud AND mss.Price < MaxStudTable.MaxStud

--9
CREATE VIEW	[Movie Schedule Viewer]
AS
(
SELECT
	[StudioId] = 'Studio ' + RIGHT(st.StudioID ,3),
	st.Name,
	[Total Play Schedule] = COUNT(s.MovieId),
	[Movie Duration Total] = SUM(m.Duration)
FROM trSchedule s JOIN msMovie m ON s.MovieId = m.MovieId
				  JOIN msStudio st ON st.StudioId = s.StudioId
WHERE st.Name LIKE 'Satin%' AND m.Duration > 120
GROUP BY st.StudioID, st.Name
)

SELECT * FROM [Movie Schedule Viewer]

--10
CREATE VIEW [Refreshment Transaction Summary Viewer]
AS
(
SELECT 
	[Transaction Count] = CAST( COUNT(RefreshmentID) AS VARCHAR) + ' transactions',
	[Quantity Sold] = CAST( SUM(Quantity) AS VARCHAR) + ' products'
FROM trDetailRefreshmentSale td JOIN trRefreshmentSale tr ON td.RefreshmentSaleId = tr.RefreshmentSaleId
WHERE DATENAME(WEEKDAY, TransactionDate) = 'Saturday' OR DATENAME(WEEKDAY, TransactionDate) = 'Sunday'
HAVING SUM(Quantity) > 5
)

SELECT * FROM [Refreshment Transaction Summary Viewer]