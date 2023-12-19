-- EXPLORING THE DATA WE ARE GOING TO USE
	SELECT *
	FROM NashvilleHousing AS NH
	Standardize Date Format

	SELECT SaleDate
	FROM NashvilleHousing AS NH
-- Standardize Date Format
	ALTER TABLE NashvilleHousing
	Add ConvertedSaleDate datetime;

	UPDATE NashvilleHousing 
	SET ConvertedSaleDate = CAST(SaleDate AS Date)
-- Standardizing Data
	-- Change Y and N to Yes and No in "SoldasVacant" field
	SELECT DISTINCT(SoldAsVacant),COUNT(SoldAsVacant) AS Count
	FROM NashvilleHousing
	GROUP BY SoldAsVacant
	ORDER BY COUNT

	Select SoldAsVacant,
	CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END AS SoldAsVacantt
	From NashvilleHousing

	Update NashvilleHousing
	SET SoldAsVacant = 
	CASE   When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
-- Splitting Data
	-- Breaking out PropertyAddress into Individual Columns (Address, City)
		SELECT PropertyAddress
		FROM NashvilleHousing AS NH

		SELECT
		SUBSTRING(NH.PropertyAddress,1,CHARINDEX(',',NH.PropertyAddress)-1) AS Adress,
		SUBSTRING(NH.PropertyAddress,CHARINDEX(',',NH.PropertyAddress1)+1,lEN(NH.PropertyAddress)) AS City
		FROM NashvilleHousing AS NH

		ALTER TABLE NashvilleHousing
		ADD PropertyAddressSplited NVARCHAR(255)

		UPDATE NashvilleHousing
		SET PropertyAddressSplited = SUBSTRING(PropertyAddress,1,CHARINDEX(",",PropertyAddress)-1)

		ALTER TABLE NashvilleHousing
		ADD CITY_PropertyAddressSplited NVARCHAR(255)

		UPDATE NashvilleHousing
		SET CITY_PropertyAddressSplited = SBSTRING(PropertyAddress,CHARINDEX(",",PropertyAddress)+1,LEN(PropertyAddress))
	-- Breaking out OwnerAddress into Individual Columns (Address, City, State)
		SELECT NH.OwnerAddress
		FROM NashvilleHousing AS NH

		Select
		PARSENAME(REPLACE(NH.OwnerAddress, ',', '.') , 3)
		,PARSENAME(REPLACE(NH.OwnerAddress, ',', '.') , 2)
		,PARSENAME(REPLACE(NH.OwnerAddress, ',', '.') , 1)
		From FROM NashvilleHousing AS NH

		ALTER TABLE NashvilleHousing
		Add OwnerSplitAddress Nvarchar(255);

		Update NashvilleHousing
		SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


		ALTER TABLE NashvilleHousing
		Add OwnerSplitCity Nvarchar(255);

		Update NashvilleHousing
		SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



		ALTER TABLE NashvilleHousing
		Add OwnerSplitState Nvarchar(255);

		Update NashvilleHousing
		SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
--Handling NULL Values
	-- Populate Property Address data
			SELECT PropertyAddress
			FROM NashvilleHousing AS NH
			WHERE NH.PropertyAddress IS NULL

			SELECT NA1.ParcelID,NA1.PropertyAddress,NA2.ParcelID,NA2.PropertyAddress,ISNULL(NA1.PropertyAddress,NA2.PropertyAddress)
			FROM NashvilleHousing NA1 JOIN NashvilleHousing NA2
			ON NA1.ParcelID = NA2.ParcelID AND NA1.UniqueID <> NA2.UniqueID
			WHERE NA1.PropertyAddress IS NULL 

			UPDATE NashvilleHousing
			SET PropertyAddress = ISNULL(NA1.PropertyAddress,NA2.PropertyAddress)
			FROM NashvilleHousing NA1 JOIN NashvilleHousing NA2
			ON NA1.ParcelID = NA2.ParcelID 
			AND NA1.UniqueID <> NA2.UniqueID
			WHERE NA1.PropertyAddress IS NULL 
	-- Remove NULL VALUES 
		Delete FROM NashvilleHousing
		WHERE column_name IS NULL
-- Remove Duplicates
	WITH RemoveDuplicate AS (
	SELECT *, ROW_NUMBER() OVER(
					PARTITION BY ParcelID,
						PropertyAddress,
						SalePrice,
						SaleDate,
						LegalReference
						ORDER BY UniqueID
						) AS row_num
	FROM NashvilleHousing
				)
							
	Select *
	From RemoveDuplicate
	Where row_num > 1
	Order by PropertyAddress


	DELETE
	From RemoveDuplicate
	Where row_num > 1

	Select *
	From NashvilleHousing
-- Delete Unused Columns
	Select *
	From NashvilleHousing

	ALTER TABLE NashvilleHousing
	DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
