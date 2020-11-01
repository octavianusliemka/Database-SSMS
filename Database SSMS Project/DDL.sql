CREATE DATABASE BlytzMegaplex
GO
USE BlytzMegaplex

CREATE TABLE msStaff(
	StaffId CHAR(5) PRIMARY KEY CHECK(StaffId LIKE 'SF[0-9][0-9][0-9]'),
	[Name] VARCHAR(MAX) NOT NULL,
	Email VARCHAR(MAX) NOT NULL,
	Gender VARCHAR(6) NOT NULL,
	DateOfBirth DATE NOT NULL,
	PhoneNumber VARCHAR(20) NOT NULL,
	[Address] VARCHAR(MAX) NOT NULL,
	CONSTRAINT check_name CHECK (LEN([Name]) BETWEEN 7 AND 30),
	CONSTRAINT check_age CHECK (DATEDIFF(DAY,DateOfBirth,GETDATE()) >= DATEDIFF(DAY,DateOfBirth,DATEADD(YEAR, 18, DateOfBirth))),
	CONSTRAINT check_gender CHECK (Gender IN ('Male','Female'))
)

CREATE TABLE msMovie(
	MovieId CHAR(5) PRIMARY KEY CHECK(MovieId LIKE 'MV[0-9][0-9][0-9]'),
	[Name] VARCHAR(MAX) NOT NULL,
	LicenseNumber VARCHAR(MAX) NOT NULL,
	Duration INT NOT NULL,
	CONSTRAINT check_duration CHECK (Duration <= 240)
)

CREATE TABLE msStudio(
	StudioId CHAR(5) PRIMARY KEY CHECK(StudioId LIKE 'ST[0-9][0-9][0-9]'),
	[Name] VARCHAR(MAX) NOT NULL,
	Price INT NOT NULL,
	CONSTRAINT check_price CHECK (Price BETWEEN 35000 AND 65000)
)

CREATE TABLE msRefreshmentType(
	RefreshmentTypeId CHAR(5) PRIMARY KEY CHECK(RefreshmentTypeId LIKE 'RT[0-9][0-9][0-9]'),
	[Name] VARCHAR(MAX) NOT NULL
)

CREATE TABLE msRefreshment(
	RefreshmentId CHAR(5) PRIMARY KEY CHECK(RefreshmentId LIKE 'RE[0-9][0-9][0-9]'),
	RefreshmentTypeId CHAR(5) NOT NULL,
	[Name] VARCHAR(MAX) NOT NULL,
	Price INT NOT NULL,
	Stock INT NOT NULL,
	FOREIGN KEY (RefreshmentTypeId) REFERENCES msRefreshmentType(RefreshmentTypeId),
	CONSTRAINT check_stock CHECK(Stock > 50)
)

CREATE TABLE trSchedule(
	ScheduleId CHAR(5) PRIMARY KEY CHECK(ScheduleId LIKE 'MS[0-9][0-9][0-9]'),
	MovieId CHAR(5) NOT NULL,
	StudioId CHAR(5) NOT NULL,
	ShowDate DATE NOT NULL,
	ShowTime TIME NOT NULL,
	FOREIGN KEY (MovieId) REFERENCES msMovie(MovieId),
	FOREIGN KEY (StudioId) REFERENCES msStudio(StudioId),
	CONSTRAINT check_datetime CHECK(DATEDIFF(DAY,GETDATE(),CAST(ShowDate AS DATETIME) + CAST(ShowTime AS DATETIME)) >= 7)
)

CREATE TABLE trMovieSale(
	MovieSaleId CHAR(6) PRIMARY KEY CHECK(MovieSaleId LIKE 'MTr[0-9][0-9][0-9]'),
	StaffId CHAR(5) NOT NULL,
	TransactionDate DATETIME NOT NULL,
	FOREIGN KEY (StaffId) REFERENCES msStaff(StaffId)
)

CREATE TABLE trRefreshmentSale(
	RefreshmentSaleId CHAR(6) PRIMARY KEY CHECK(RefreshmentSaleId LIKE 'RTr[0-9][0-9][0-9]'),
	StaffId CHAR(5) NOT NULL,
	TransactionDate DATETIME NOT NULL,
	FOREIGN KEY (StaffId) REFERENCES msStaff(StaffId)
)

CREATE TABLE trDetailMovieSale(
	MovieSaleId CHAR(6),
	ScheduleId CHAR(5),
	Seats INT NOT NULL,
	PRIMARY KEY (MovieSaleId, ScheduleId),
	FOREIGN KEY (MovieSaleId) REFERENCES trMovieSale(MovieSaleId),
	FOREIGN KEY (ScheduleId) REFERENCES trSchedule(ScheduleId)
)

CREATE TABLE trDetailRefreshmentSale(
	RefreshmentSaleId CHAR(6),
	RefreshmentId CHAR(5),
	Quantity INT NOT NULL,
	PRIMARY KEY (RefreshmentSaleId, RefreshmentId),
	FOREIGN KEY (RefreshmentSaleId) REFERENCES trRefreshmentSale(RefreshmentSaleId),
	FOREIGN KEY (RefreshmentId) REFERENCES msRefreshment(RefreshmentId)
)