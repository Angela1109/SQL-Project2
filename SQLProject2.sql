-- Cleaning Data in SQL Queries

SELECT *
FROM NashvilleHousing

-- Standardize Date Format
SELECT SaleDate, CONVERT(date, SaleDate)
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(date, SaleDate)
--Not work

--ALTER to modify the data
ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate)

SELECT SaleDateConverted, CONVERT(date, SaleDate)
FROM NashvilleHousing


-- thay gtri cot saledate ve gtri ngay saledateconverted

-- Populate Property Adress Data
SELECT PropertyAddress
FROM NashvilleHousing
WHERE PropertyAddress IS NULL

SELECT *
FROM NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT *
FROM NashvilleHousing a
JOIN NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM NashvilleHousing a
JOIN NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

--ISNULL de kiem tra gia tri A.PropertyAdress co phai la gia tri rong hay khong, neu la null thi se thay the bang b.PropertyAdress
-- neu cot a.PropertyAddress la gtri NULL thi se dc thay the bang gia tri cot b.PropertyAddress

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

--update, thay cac gia tri null bang gia tri cua bang b
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

--Co the thay the bang 1 chuoi "string" trong ham ISNULL
ISNULL(a.PropertyAddress, 'No Adress')

 --check lai xem con hien gia tri NULL hay khong, khong hien tuc la cac gia tri da dc dien du
 SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM NashvilleHousing a
JOIN NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

--Breaking out address into Individual Column (Address, City, State)
SELECT PropertyAddress
FROM NashvilleHousing

-- TR�CH XU?T CHU?I TRC D?U PH?Y
SELECT 
SUBSTRING( PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) AS Address,
CHARINDEX(',', PropertyAddress)
FROM NashvilleHousing

--C�u l?nh tr�n c?ng s? d?ng c�c h�m SUBSTRING v� CHARINDEX trong SQL Server ?? tr�ch xu?t m?t ph?n c?a chu?i t? m?t tr??ng PropertyAddress.

--H�m CHARINDEX ???c s? d?ng ?? t�m v? tr� c?a d?u ph?y , trong tr??ng PropertyAddress. ?i?u n�y gi�p x�c ??nh v? tr� ??u ti�n c?a d?u ph?y trong chu?i.

--Sau ?�, k?t qu? c?a h�m CHARINDEX n�y ???c s? d?ng l�m ??i s? th? ba trong h�m SUBSTRING. H�m SUBSTRING s? tr�ch xu?t m?t ph?n c?a chu?i t? v? tr� ??u ti�n ??n v? tr� ???c x�c ??nh b?i h�m CHARINDEX. ?i?u n�y c� ngh?a l� n� s? tr�ch xu?t ph?n c?a chu?i tr??c d?u ph?y trong tr??ng PropertyAddress.

--V� d?:
--N?u PropertyAddress l� '123 Main St, Apt 2', th� k?t qu? c?a c�u l?nh tr�n s? l� '123 Main St', v� n� s? tr�ch xu?t ph?n c?a chu?i tr??c d?u ph?y.

--B? d?u ph?y
SELECT 
SUBSTRING( PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1 ) AS Address
FROM NashvilleHousing


-- Ch?n c�c tr??ng n?m sau d?u ph?y
--+1 ?? b? ?i d?u ph?y
SELECT 
SUBSTRING( PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1 ) AS AddressLine1,
SUBSTRING( PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS AddressLine2
FROM NashvilleHousing


ALTER TABLE NashvilleHousing
ADD AddressLine1 nvarchar(255);

UPDATE NashvilleHousing
SET AddressLine1 = SUBSTRING( PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1 )


ALTER TABLE NashvilleHousing
ADD AddressLine2 nvarchar(255);

UPDATE NashvilleHousing
SET AddressLine2 = SUBSTRING( PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT *
FROM NashvilleHousing





SELECT OwnerAddress
FROM NashvilleHousing


--Parsename ch? c� t�c d?ng v?i d?u ch?m, k c� td v?i d?u ph?y)
--Check th? TH
SELECT REPLACE(OwnerAddress, ',' , '.')
FROM NashvilleHousing
-- kq l� 1 chu?i ??a ch? ?c thay th? d?u ph?y sang ch?m

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'), 3),
PARSENAME(REPLACE(OwnerAddress,',','.'), 2),
PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
FROM NashvilleHousing



-- REPLACE(OwnerAddress, ',', '.'): H�m n�y s? thay th? t?t c? c�c d?u ph?y trong chu?i OwnerAddress b?ng d?u ch?m. K?t qu? c?a ph?n n�y l� m?t chu?i m?i v?i d?u ph?y ?� ???c thay th? b?ng d?u ch?m.

--PARSENAME(..., 3): Ph?n n�y s? d?ng h�m PARSENAME ?? tr�ch xu?t th�nh ph?n th? ba t? cu?i c?a chu?i ?� ???c thay ??i t? b??c tr??c. ?i?u n�y c� ngh?a l� n?u chu?i ???c ph�n t�ch c� ba ph?n c�ch nhau b?ng d?u ch?m, th� h�m PARSENAME s? tr? v? ph?n th? ba c?a chu?i ?�.

--V� d?:
--N?u OwnerAddress l� '123 Main St, Apt 2, City', sau khi th?c hi?n REPLACE, chu?i s? tr? th�nh '123 Main St. Apt 2. City'. Sau ?�, PARSENAME s? tr? v? th�nh ph?n th? ba t? cu?i, t?c l� 'Main St'.

-- thay v�o b?ng d? li?u:

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)

SELECT *
FROM NashvilleHousing


---------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as vacannt" field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY (SoldAsVacant)
ORDER BY 2

SELECT SoldAsVacant,
CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END
FROM NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant = 
CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END
FROM NashvilleHousing

--CHECK LAI

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY (SoldAsVacant)
ORDER BY 2

-------------------------------------------------------------------------
--REMOVE DUPICATES (XOA TRONG CAC BANG DU LIEU TAM THOI, KO XOA TRONG DATABASE VI SO MAT DU LIEU)


--DELETE UNUSED COLUMN

SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID, 
				 PropertyAddress, 
				 SalePrice, 
				 SaleDate, 
				 LegalReference 
				 ORDER BY 
					UniqueID
					) rownum
FROM NashvilleHousing
ORDER BY ParcelID

SELECT *
FROM NashvilleHousing






WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
FROM NashvilleHousing
)
Select *
From RowNumCTE


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
FROM NashvilleHousing
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
FROM NashvilleHousing
)
DELETE
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


-------------------------------------
-- Delete Unused Columns
SELECT *
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate
