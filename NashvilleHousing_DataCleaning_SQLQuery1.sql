SELECT *
FROM PortfolioProject..NashvilleHousing

-- Standardise Date Format

SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM PortfolioProject..NashvilleHousing

UPDATE PortfolioProject..NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE PortfolioProject..NashvilleHousing
Add SaleDateConverted Date

UPDATE PortfolioProject..NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

-- Property Address Data

SELECT *
FROM PortfolioProject..NashvilleHousing
--WHERE PropertyAddress is null
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
	JOIN PortfolioProject..NashvilleHousing b
		ON a.ParcelID = b.ParcelID
		and a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null
--ORDER BY ParcelID

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
	JOIN PortfolioProject..NashvilleHousing b
		ON a.ParcelID = b.ParcelID
		and a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null
--ORDER BY ParcelID

-- Separating The Address Into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address , 
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
FROM PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
Add PropertySplitAddress NVARCHAR(255)

UPDATE PortfolioProject..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE PortfolioProject..NashvilleHousing
Add PropertySplitCity NVARCHAR(255)

UPDATE PortfolioProject..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

SELECT *
FROM PortfolioProject..NashvilleHousing

-- Owner Address

SELECT OwnerAddress
FROM PortfolioProject..NashvilleHousing
ORDER BY OwnerAddress desc

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)
FROM PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
Add OwnerSplitAddress NVARCHAR(255)

UPDATE PortfolioProject..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)

ALTER TABLE PortfolioProject..NashvilleHousing
Add OwnerSplitCity NVARCHAR(255)

UPDATE PortfolioProject..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)

ALTER TABLE PortfolioProject..NashvilleHousing
Add OwnerSplitState NVARCHAR(255)

UPDATE PortfolioProject..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)

SELECT *
FROM PortfolioProject..NashvilleHousing

-- Sold As Vacant

SELECT *
FROM PortfolioProject..NashvilleHousing

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

-- change Y to Yes using CASE
-- change N to No using CASE

SELECT SoldAsVacant
, CASE When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	ELSE SoldAsVacant
	END
FROM PortfolioProject..NashvilleHousing

UPDATE PortfolioProject..NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	ELSE SoldAsVacant
	END

-- Remove Duplicates using CTEs

SELECT *
FROM PortfolioProject..NashvilleHousing

WITH Row_NumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
					UniqueID
					) Row_Num
FROM PortfolioProject..NashvilleHousing
)
SELECT *
FROM Row_NumCTE
Where Row_Num > 1
--ORDER BY PropertyAddress

WITH Row_NumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
					UniqueID
					) Row_Num
FROM PortfolioProject..NashvilleHousing
)
DELETE
FROM Row_NumCTE
Where Row_Num > 1
--ORDER BY PropertyAddress

--Delete Unused Columns

SELECT *
FROM PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN SaleDate