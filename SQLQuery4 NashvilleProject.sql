SELECT*
FROM Nashvilledata.dbo.NashvilleHousing

--Standardise SaleDate
SELECT SaleDateConverted,CONVERT(Date,SaleDate)
FROM Nashvilledata.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate=CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted=CONVERT(Date,SaleDate)

--Property Address

SELECT *
FROM Nashvilledata.dbo.NashvilleHousing
--WHERE PropertYAddress IS null
ORDER BY ParcelID


SELECT A.ParcelID, A.PropertyAddress,B.ParcelID,B.PropertyAddress,ISNULL( A.PropertyAddress,B.PropertyAddress)
FROM Nashvilledata.dbo.NashvilleHousing A
JOIN Nashvilledata.dbo.NashvilleHousing B
ON A.ParcelID=B.ParcelID
AND A.UniqueID<>B.UniqueID
WHERE A.PropertyAddress is NULL

UPDATE A
SET PropertyAddress=ISNULL( A.PropertyAddress,B.PropertyAddress)
FROM Nashvilledata.dbo.NashvilleHousing A
JOIN Nashvilledata.dbo.NashvilleHousing B
ON A.ParcelID=B.ParcelID
AND A.UniqueID<>B.UniqueID
WHERE A.PropertyAddress is NULL

--Breaking out Address into individual columns(address,city,state)
SELECT PropertyAddress
FROM Nashvilledata.dbo.NashvilleHousing
--WHERE PropertYAddress IS null
--ORDER BY ParcelID

SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) AS Address
FROM Nashvilledata.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD PropertyCityAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertyCityAddress=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

SELECT OwnerAddress
FROM Nashvilledata.dbo.NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM Nashvilledata.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
ADD OwnerCityAddress Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerCityAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerStateAddress Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerStateAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT *
FROM Nashvilledata.dbo.NashvilleHousing

--Change 1 and 0 to yeas and no in Sold As Vacant.

SELECT DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
FROM Nashvilledata.dbo.NashvilleHousing
GROUP BY SoldAsVacant

--SELECT SoldAsVacant
--,CASE WHEN  SoldAsVacant='1'THEN 'YES'
--WHEN SoldAsVacant='0' THEN 'NO'
--ELSE SoldAsVacant
--END
--FROM Nashvilledata.dbo.NashvilleHousing



--remove dublicates
WITH RowNumCTE AS (
SELECT *,
   ROW_NUMBER() OVER (
   PARTITION BY ParcelID,
              PropertyAddress,
			  SalePrice,
			  SaleDate,
			  LegalReference
			  ORDER BY 
			  UniqueID
			  )row_num

   FROM Nashvilledata.dbo.NashvilleHousing
   --ORDER BY ParcelID
   )

   
SELECT*
FROM RowNumCTE
WHERE row_num>1
--ORDER BY PropertyAddress

--Delete Unused Columns

SELECT*
FROM Nashvilledata.dbo.NashvilleHousing

ALTER TABLE Nashvilledata.dbo.NashvilleHousing
DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress

ALTER TABLE Nashvilledata.dbo.NashvilleHousing
DROP COLUMN SaleDate







